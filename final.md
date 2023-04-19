# Run_deepconsensus


Prepare data for transferring
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
https://github.com/google/deepconsensus/blob/r1.2/docs/quick_start.md
install deepconsensus, (python=3.9.16)
```
name: deepconsensus
channels:
  - anaconda
  - hcc
  - conda-forge
  - bioconda
  - defaults
dependencies:
  - _libgcc_mutex=0.1=main
  - _openmp_mutex=5.1=1_gnu
  - actc=0.2.0=h9ee0642_0
  - aiohttp=3.8.1=py39hb9d737c_1
  - aiosignal=1.3.1=pyhd8ed1ab_0
  - argcomplete=3.0.2=pyhd8ed1ab_0
  - aspera-cli=3.9.6=h5e1937b_0
  - async-timeout=4.0.2=pyhd8ed1ab_0
  - attrs=22.2.0=pyh71513ae_0
  - boto=2.49.0=py_0
  - brotlipy=0.7.0=py39hb9d737c_1004
  - bzip2=1.0.8=h7b6447c_0
  - c-ares=1.19.0=h5eee18b_0
  - ca-certificates=2023.01.10=h06a4308_0
  - cachetools=5.3.0=pyhd8ed1ab_0
  - certifi=2022.12.7=py39h06a4308_0
  - cffi=1.15.0=py39h4bc2ebd_0
  - crcmod=1.7=py39hb9d737c_1008
  - cryptography=3.4.8=py39h95dcef6_1
  - fasteners=0.17.3=pyhd8ed1ab_0
  - frozenlist=1.3.3=py39h5eee18b_0
  - gcs-oauth2-boto-plugin=3.0=pyhd8ed1ab_0
  - google-apitools=0.5.32=pyhd8ed1ab_0
  - google-auth=2.16.2=pyh1a96a4e_0
  - google-reauth=0.1.1=pyhd3deb0d_0
  - gsutil=5.21=pyhd8ed1ab_0
  - htslib=1.12=h9093b5e_1
  - idna=3.4=pyhd8ed1ab_0
  - krb5=1.19.4=h568e23c_0
  - ld_impl_linux-64=2.38=h1181459_1
  - libcurl=7.88.1=h91b91d3_0
  - libdeflate=1.7=h27cfd23_5
  - libedit=3.1.20221030=h5eee18b_0
  - libev=4.33=h7f8727e_1
  - libffi=3.4.2=h6a678d5_6
  - libgcc-ng=11.2.0=h1234567_1
  - libgomp=11.2.0=h1234567_1
  - libnghttp2=1.46.0=hce63b2e_0
  - libssh2=1.10.0=h8f2d780_0
  - libstdcxx-ng=11.2.0=h1234567_1
  - monotonic=1.5=py_0
  - multidict=6.0.2=py39h5eee18b_0
  - ncurses=6.4=h6a678d5_0
  - oauth2client=4.1.3=py_0
  - openssl=1.1.1t=h7f8727e_0
  - pbbam=1.7.0=h058f120_1
  - pbccs=6.4.0=h9ee0642_0
  - pip=23.0.1=py39h06a4308_0
  - pyasn1=0.4.8=py_0
  - pycparser=2.21=pyhd8ed1ab_0
  - pyopenssl=20.0.1=pyhd8ed1ab_0
  - pyparsing=3.0.9=pyhd8ed1ab_0
  - pysocks=1.7.1=pyha2e5f31_6
  - python=3.9.16=h7a1cb2a_2
  - python_abi=3.9=2_cp39
  - pyu2f=0.1.5=pyhd8ed1ab_0
  - readline=8.2=h5eee18b_0
  - requests=2.28.2=pyhd8ed1ab_0
  - retry_decorator=1.1.1=pyh9f0ad1d_0
  - rsa=4.9=pyhd8ed1ab_0
  - setuptools=65.6.3=py39h06a4308_0
  - six=1.16.0=pyh6c4a22f_0
  - socksipy-branch=1.01=pyh9f0ad1d_0
  - sqlite=3.41.1=h5eee18b_0
  - tk=8.6.12=h1ccaba5_0
  - typing-extensions=4.5.0=hd8ed1ab_0
  - typing_extensions=4.5.0=pyha770c72_0
  - tzdata=2022g=h04d1e81_0
  - urllib3=1.26.15=pyhd8ed1ab_0
  - wheel=0.38.4=py39h06a4308_0
  - xz=5.2.10=h5eee18b_1
  - yarl=1.7.2=py39hb9d737c_2
  - zlib=1.2.13=h5eee18b_0
  - pip:
      - absl-py==1.0.0
      - astunparse==1.6.3
      - charset-normalizer==3.1.0
      - click==8.1.3
      - colorama==0.4.6
      - contextlib2==21.6.0
      - contourpy==1.0.7
      - cycler==0.11.0
      - cython==0.29.33
      - deepconsensus==1.2.0
      - dm-tree==0.1.8
      - etils==1.1.1
      - flatbuffers==1.12
      - fonttools==4.39.2
      - gast==0.4.0
      - gin-config==0.5.0
      - google-api-core==2.11.0
      - google-api-python-client==2.81.0
      - google-auth-httplib2==0.1.0
      - google-auth-oauthlib==0.4.6
      - google-pasta==0.2.0
      - googleapis-common-protos==1.58.0
      - grpcio==1.51.3
      - h5py==3.8.0
      - httplib2==0.21.0
      - importlib-metadata==6.1.0
      - importlib-resources==5.12.0
      - intel-tensorflow==2.9.1
      - joblib==1.2.0
      - kaggle==1.5.13
      - keras==2.9.0
      - keras-preprocessing==1.1.2
      - kiwisolver==1.4.4
      - libclang==15.0.6.1
      - lxml==4.9.2
      - markdown==3.4.1
      - markupsafe==2.1.2
      - matplotlib==3.7.1
      - ml-collections==0.1.1
      - numpy==1.24.2
      - oauthlib==3.2.2
      - opencv-python-headless==4.7.0.72
      - opt-einsum==3.3.0
      - packaging==23.0
      - pandas==1.5.1
      - pillow==9.4.0
      - portalocker==2.7.0
      - promise==2.3
      - protobuf==3.19.6
      - psutil==5.9.4
      - py-cpuinfo==9.0.0
      - pyasn1-modules==0.2.8
      - pycocotools==2.0.6
      - pysam==0.19.0
      - python-dateutil==2.8.2
      - python-slugify==8.0.1
      - pytz==2022.7.1
      - pyyaml==5.4.1
      - regex==2022.10.31
      - requests-oauthlib==1.3.1
      - sacrebleu==2.3.1
      - scikit-learn==1.2.2
      - scipy==1.10.1
      - sentencepiece==0.1.97
      - seqeval==1.2.2
      - tabulate==0.9.0
      - tensorboard==2.9.1
      - tensorboard-data-server==0.6.1
      - tensorboard-plugin-wit==1.8.1
      - tensorflow==2.9.3
      - tensorflow-addons==0.19.0
      - tensorflow-datasets==4.8.3
      - tensorflow-estimator==2.9.0
      - tensorflow-hub==0.13.0
      - tensorflow-io-gcs-filesystem==0.31.0
      - tensorflow-metadata==1.12.0
      - tensorflow-model-optimization==0.7.3
      - tensorflow-text==2.9.0
      - termcolor==2.2.0
      - text-unidecode==1.3
      - tf-models-official==2.9.1
      - tf-slim==1.1.0
      - threadpoolctl==3.1.0
      - toml==0.10.2
      - tqdm==4.65.0
      - typeguard==3.0.1
      - uritemplate==4.1.1
      - werkzeug==2.2.3
      - wrapt==1.15.0
      - zipp==3.15.0
prefix: /g/data/xf3/miniconda/envs/deepconsensus
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
bash the above script
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
