#!/bin/bash

cyt_report=../data/07_cytosine_report/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.txt.gz.bismark.CX_report.txt
chr_sizes=../data/00_util/hg38.chrom.sizes


sort --output=${cyt_report}.sorted --parallel=2 --buffer-size=5G -k 1,1 -k2,2n ${cyt_report}

awk '{FS="\t";OFS="\t"} { print $1,$2,$2+1,$4 }' ${cyt_report}.sorted  > ${cyt_report}.sorted.meth  

# echo "bedClip meth."; date
# bedClip -verbose=2 \
#         ${cyt_report}.sorted.meth \
#         ${chr_sizes} \
#         ${cyt_report}.sorted.meth.clipped

echo "bedGraphToBigWig meth."; date
bedGraphToBigWig ${cyt_report}.sorted.meth \
		 ${chr_sizes} \
		 ${cyt_report}.sorted.meth.bw; date




echo "Unmeth"; date
awk '{FS="\t";OFS="\t"} { print $1,$2,$2+1,$5 }' \
    ${cyt_report}.sorted  > ${cyt_report}.sorted.unmeth

ls -lahgt ${cyt_report}.sorted.unmeth

# echo "bedClip unmeth."; date
# bedClip -verbose=2 \
#         ${cyt_report}.sorted.unmeth \
#         ${chr_sizes} \
#         ${cyt_report}.sorted.unmeth.clipped

echo "bedGraphToBigWig meth."; date
bedGraphToBigWig ${cyt_report}.sorted.unmeth \
                 ${chr_sizes} \
                 ${cyt_report}.sorted.unmeth.bw

