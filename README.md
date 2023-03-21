# Run_deepconsensus
### Create and install dependencies
```
conda create -n deepconsensus -y
conda activate deepconsensus
conda install python=3.9 -y
pip install deepconsensus[cpu]==1.2.0
conda install -c bioconda pbbam pbccs actc -y
```

### Files are copied to nci with 
```
rsync -avz --compress-level=9 --progress --partial  ${file}  ${NCI_PATH}
```

### Since deepconsensus have three steps, we start from ccs
```
#Index bam files if we don't have (but we have)
pdindex ${subreads.bam}
```

[deepconsensus quickstart] (https://github.com/google/deepconsensus/blob/r1.2/docs/quick_start.md)

### Create lots of job submit script (save as .sh and run with bash .sh, after pbs scripts created, run for i in *.pbs; do qsub ${i} ; done
```
PBS_setting="
#!/bin/bash
#PBS -q normal
#PBS -l mem=50GB
#PBS -l walltime=2:00:00
#PBS -l jobfs=50GB
#PBS -l ncpus=48
#PBS -l wd
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -M
set -xue
source /home/106/${USER}/.bashrc
source /g/data/xf3/miniconda/etc/profile.d/conda.sh 
conda activate deepconsensus
cd /g/data/xf3/${USER}/Apsidii_2023
"
function to_shard_id {
  # ${1}: n=1-based counter
  # ${2}: n_total=1-based count
  echo "$( printf %03g "${1}")-of-$(printf "%03g" "${2}")"
}
###Parameter
n_total=500
bam_file=GM1_PL100274085-1_C01.subreads.bam
#Adjust n here to larger number if needed
for ((n=1;n<=10;n++));
do
shard_id="$(to_shard_id "${n}" "${n_total}")"
ccs_cmd="ccs --min-rq=0.88 -j 48 --chunk="${n}"/"${n_total}" ${bam_file} ${bam_file%.subreads.bam}_${shard_id}.ccs.bam"
echo -e "${PBS_setting}\n${ccs_cmd}" >"$shard_id"_ccs.pbs
done
```

### After finishing all chunks in the ccs step (not sure)
```
#!/bin/bash
#PBS -q normal
#PBS -l mem=200GB
#PBS -l walltime=2:00:00
#PBS -l jobfs=200GB
#PBS -l ncpus=48
#PBS -l wd
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -M
set -xue
source /home/106/${USER}/.bashrc
source /g/data/xf3/miniconda/etc/profile.d/conda.sh 
conda activate deepconsensus
#Change to file name of ccs output
bam_file=GM1_PL100274085-1_C01.ccs.bam
samtools merge -@48 GM1_PL100274085-1_C01.ccs.bam *500.ccs.bam
pbindex GM1_PL100274085-1_C01.ccs.bam
```

### Then create lots of pbs scripts for actc (save as .sh and run with bash .sh, after pbs scripts created, run for i in *.pbs; do qsub ${i} ; done
```
PBS_setting="
#!/bin/bash
#PBS -q normal
#PBS -l mem=50GB
#PBS -l walltime=2:00:00
#PBS -l jobfs=50GB
#PBS -l ncpus=48
#PBS -l wd
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -M
set -xue
source /home/106/${USER}/.bashrc
source /g/data/xf3/miniconda/etc/profile.d/conda.sh 
conda activate deepconsensus
cd /g/data/xf3/${USER}/Apsidii_2023
"
function to_shard_id {
  # ${1}: n=1-based counter
  # ${2}: n_total=1-based count
  echo "$( printf %03g "${1}")-of-$(printf "%03g" "${2}")"
}
###Parameter
n_total=500
bam_file=GM1_PL100274085-1_C01.subreads.bam
#Adjust n here to larger number if needed
for ((n=1;n<=10;n++));
do
shard_id="$(to_shard_id "${n}" "${n_total}")"
actc_cmd="
pbindex ${bam_file%.subreads.bam}_${shard_id}.ccs.bam
actc -j 48 ${bam_file} ${bam_file%.subreads.bam}_${shard_id}.ccs.bam ${bam_file%.subreads.bam}_${shard_id}.subreads_to_ccs.bam
"
echo -e "${PBS_setting}\n${actc_cmd}" >"$shard_id".subreads_to_ccs.pbs
done
```

### Once we get all actc output, then create lots of pbs scripts for deepconsensus (save as .sh and run with bash .sh, after pbs scripts created, run for i in *.pbs; do qsub ${i} ; done
```
PBS_setting="
#!/bin/bash
#PBS -q normal
#PBS -l mem=50GB
#PBS -l walltime=2:00:00
#PBS -l jobfs=50GB
#PBS -l ncpus=48
#PBS -l wd
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -M
set -xue
source /home/106/${USER}/.bashrc
source /g/data/xf3/miniconda/etc/profile.d/conda.sh 
conda activate deepconsensus
cd /g/data/xf3/${USER}/Apsidii_2023
"
function to_shard_id {
  # ${1}: n=1-based counter
  # ${2}: n_total=1-based count
  echo "$( printf %03g "${1}")-of-$(printf "%03g" "${2}")"
}
###Parameter
n_total=500
bam_file=GM1_PL100274085-1_C01.subreads.bam
#Adjust n here to larger number if needed
for ((n=1;n<=10;n++));
do
shard_id="$(to_shard_id "${n}" "${n_total}")"
deep_cmd="
deepconsensus run --ccs_bam=${bam_file%.subreads.bam}_${shard_id}.ccs.bam --subreads_to_ccs=${bam_file%.subreads.bam}_${shard_id}.subreads_to_ccs.bam --checkpoint=model/checkpoint --output=${bam_file%.subreads.bam}_${shard_id}.output.fastq --batch_size=2048 --batch_zmws=1000
"
echo -e "${PBS_setting}\n${deep_cmd}" >"$shard_id".deepconsensus.pbs
done
```

### Combine all fastq file with
```
PBS_setting="
#!/bin/bash
#PBS -q normal
#PBS -l mem=1200GB
#PBS -l walltime=2:00:00
#PBS -l jobfs=1200GB
#PBS -l ncpus=48
#PBS -l wd
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -M
set -xue
bam_file=GM1_PL100274085-1_C01.subreads.bam
cat *.output.fastq >>${bam_file%.subreads.bam}.fastq
```
