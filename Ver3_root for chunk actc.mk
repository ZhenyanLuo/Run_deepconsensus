## Save as chunk_actc.sh
```
n_total=100
bam_file=GM1_PL100274085-1_C01
for ((n=1;n<=100;n++));
do
#shard_id="$(to_shard_id "${n}" "${n_total}")"
actc_cmd="
if [ ! -f ${bam_file}_chunk${n}.subreads_to_ccs.bam ];then actc -j 6 ${bam_file}.subreads.bam ${bam_file}.ccs.bam ${bam_file}_chunk${n}.subreads_to_ccs.bam --chunk ${n}/100;rm ${bam_file}_chunk${n}.subreads_to_ccs.bam.fasta;fi
"
echo -e $actc_cmd >>actc.loop.sh
done
```

## Run 
bash actc.loop.sh


## Once we have 10 files
```
#Adjust n value when needed
for ((n=1;n<=10;n++));
do
rsync -avz --compress-level=9 --progress --partial ${bam_file}_chunk${n}.subreads_to_ccs.bam ${Destination}
done
```

## Create multiple files for submitting deepconsensus job on NCI
```
PBS_setting="
#!/bin/bash
#PBS -q normal
#PBS -l mem=50GB
#PBS -l walltime=2:00:00
#PBS -l jobfs=50GB
#PBS -l ncpus=48
#PBS -l wd
#PBS -P xf3
#PBS -l storage=scratch/xf3+gdata/xf3
set -xue
source /g/data/xf3/miniconda/etc/profile.d/conda.sh 
conda activate deepconsensus
cd /g/data/xf3/${USER}/Apsidii_2023/C01
"
#Run deepconsensus
for ((n=1;n<=10;n++));
do
bam_file=GM1_PL100274085-1_C01
deep_cmd="
if [ ! -f ${bam_file}_chunk${n}.fastq];
then
pbindex ${bam_file}_chunk${n}.subreads_to_ccs.bam
deepconsensus run --ccs_bam=${bam_file}.ccs.bam --subreads_to_ccs=${bam_file}_chunk${n}.subreads_to_ccs.bam --checkpoint=model/checkpoint --output=${bam_file}_chunk${n}.fastq --batch_size=2048 --batch_zmws=1000
#Remove the following command if have enough space
rm ${bam_file}_chunk${n}.subreads_to_ccs.bam
fi
"
echo -e "${PBS_setting}\n${deep_cmd}" >chunk_${n}_deepconsensus.pbs.sh
done
```
Submit this with for i in *.pbs.sh; do qsub ${i} ; done
