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

##Run 
bash actc.loop.sh
