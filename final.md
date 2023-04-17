# Run_deepconsensus


```
split -b 100G -d S64049_PL100274086-1_D01.subreads.bam D01_chunk
```

```
#!/bin/bash
#PBS -q normal
#PBS -l mem=190GB
#PBS -l walltime=12:00:00
#PBS -l jobfs=200GB
#PBS -l ncpus=1
#PBS -l wd
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -P xf3
set -xue
source /g/data/xf3/miniconda/etc/profile.d/conda.sh
cd /g/data/xf3/zl1602/Apsidii_2023/D01/
cat D01_chunk* >>D01.subreads.bam
md5sum D01.subreads.bam  >D01.subreads.bam.md5sum 
```

```
#!/bin/bash
#PBS -q normal
#PBS -l mem=190GB
#PBS -l walltime=12:00:00
#PBS -l jobfs=2GB
#PBS -l ncpus=1
#PBS -l wd
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -P xf3
set -xue
source /g/data/xf3/miniconda/etc/profile.d/conda.sh
conda activate deepconsensus
cd /g/data/xf3/zl1602/Apsidii_2023/D01
pbindex D01.subreads.bam
```


```
n_total=500
subreads_path="/g/data/xf3/zl1602/Apsidii_2023/D01/D01.subreads.bam"
for ((n=1;n<=${n_total};n++));
do
function to_shard_id {
  echo "$( printf %03g "${1}")-of-$(printf "%03g" "${2}")"
}
shard_id="$(to_shard_id "${n}" "${n_total}")"
mkdir -p D01_${shard_id}
PBS_setting="#!/bin/bash
#PBS -q normal
#PBS -l mem=10GB
#PBS -l walltime=0:30:00
#PBS -l ncpus=16
#PBS -l wd
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -P xf3
set -xue
source /g/data/xf3/miniconda/etc/profile.d/conda.sh
conda activate deepconsensus
cd /g/data/xf3/zl1602/Apsidii_2023/D01/D01_${shard_id}
"
ccs_cmd="
ccs --min-rq=0.88 -j 16 --chunk=${n}/${n_total} ${subreads_path} D01_${shard_id}.ccs.bam
pbindex D01_${shard_id}.ccs.bam
"
echo -e "${PBS_setting}\n${ccs_cmd}" >D01_${shard_id}/D01_${shard_id}.ccs.pbs.sh
done
```
submit ccs job
```
n_total=500
for ((n=1;n<=${n_total};n++));
do
function to_shard_id {
  echo "$( printf %03g "${1}")-of-$(printf "%03g" "${2}")"
}
shard_id="$(to_shard_id "${n}" "${n_total}")"
qsub D01_${shard_id}/D01_${shard_id}.ccs.pbs.sh
done
```
make actc scripts
```
n_total=500
subreads_path="/g/data/xf3/zl1602/Apsidii_2023/D01/D01.subreads.bam"
for ((n=1;n<=${n_total};n++));
do
function to_shard_id {
  echo "$( printf %03g "${1}")-of-$(printf "%03g" "${2}")"
}
shard_id="$(to_shard_id "${n}" "${n_total}")"
PBS_setting="#!/bin/bash
#PBS -q normal
#PBS -l mem=10GB
#PBS -l walltime=0:30:00
#PBS -l ncpus=16
#PBS -l wd
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -P xf3
set -xue
source /g/data/xf3/miniconda/etc/profile.d/conda.sh
conda activate deepconsensus
cd /g/data/xf3/zl1602/Apsidii_2023/D01/D01_${shard_id}
"
actc_cmd="
actc -j 16 ${subreads_path} D01_${shard_id}.ccs.bam D01_${shard_id}.subreads_to_ccs.bam
pbindex D01_${shard_id}.subreads_to_ccs.bam
"
echo -e "${PBS_setting}\n${actc_cmd}" >D01_${shard_id}/D01_${shard_id}.actc.pbs.sh
done
```
submit actc script
```
n_total=500
for ((n=1;n<=${n_total};n++));
do
function to_shard_id {
  echo "$( printf %03g "${1}")-of-$(printf "%03g" "${2}")"
}
shard_id="$(to_shard_id "${n}" "${n_total}")"
qsub D01_${shard_id}/D01_${shard_id}.actc.pbs.sh
done
```
make deepconsensus script
```
n_total=500
for ((n=1;n<=${n_total};n++));
do
function to_shard_id {
  echo "$( printf %03g "${1}")-of-$(printf "%03g" "${2}")"
}
shard_id="$(to_shard_id "${n}" "${n_total}")"
PBS_setting="#!/bin/bash
#PBS -q normal
#PBS -l mem=60GB
#PBS -l walltime=6:00:00
#PBS -l ncpus=10
#PBS -l jobfs=100GB
#PBS -l wd
#PBS -l storage=scratch/xf3+gdata/xf3
#PBS -P xf3
set -xue
source /g/data/xf3/miniconda/etc/profile.d/conda.sh
conda activate deepconsensus
"
id="D01_${shard_id}"
subreads_path="/g/data/xf3/zl1602/Apsidii_2023/D01/D01.subreads.bam"
subreads_to_ccs="/g/data/xf3/zl1602/Apsidii_2023/D01/${id}/${id}.subreads_to_ccs.bam"
ccs_bam="/g/data/xf3/zl1602/Apsidii_2023/D01/${id}/${id}.ccs.bam"
model="/g/data/xf3/zl1602/Apsidii_2023/D01/model"
PBS_d='$PBS_JOBFS'

deepconsensus_cmd="
cd ${PBS_d}
cp ${subreads_to_ccs} ${subreads_to_ccs}.pbi .
cp ${ccs_bam} ${ccs_bam}.pbi .
cp -r ${model} .
deepconsensus run --subreads_to_ccs=${id}.subreads_to_ccs.bam --ccs_bam=${id}.ccs.bam --checkpoint=model/checkpoint --output=${id}.output.fastq --batch_size=2048 --batch_zmws=1000
cp *.output.* /g/data/xf3/zl1602/Apsidii_2023/D01/${id}
"
echo -e "${PBS_setting}\n${deepconsensus_cmd}" >${id}/${id}.deepconsensus.pbs.sh
done
```
submit deepconsensus script
```
n_total=500
for ((n=1;n<=${n_total};n++));
do
function to_shard_id {
  echo "$( printf %03g "${1}")-of-$(printf "%03g" "${2}")"
}
shard_id="$(to_shard_id "${n}" "${n_total}")"
qsub D01_${shard_id}/D01_${shard_id}.deepconsensus.pbs.sh
done
```
