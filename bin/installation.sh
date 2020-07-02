#!/bin/bash

## https://askubuntu.com/questions/1116133/ubuntu-18-04-libcrypto-so-1-0-0-cannot-open-shared-object-file-no-such-file-o

# conda create -n bismark_examples
# conda activate bismark_examples
# data/00_util/chrM.fa

genome=./data/00_util/
FQ1=data/01_fastq/K562_1_chr22.fq
FQ2=data/01_fastq/K562_2_chr22.fq

mismatches=1
PREFIX=one_mismatch
OUT=./data/03_aligned/

which samtools bowtie2

##############################################################################################################################

# bismark_genome_preparation ${genome}

##############################################################################################################################

OUT=./data/02_fastq_trimmed/

# trim_galore --quality 20 --gzip --paired --phred33 --fastqc \
#             --illumina --output_dir ${OUT} \
#             --cores 4 ${FQ1} ${FQ2}

##############################################################################################################################

FQ1=./data/02_fastq_trimmed/K562_1_chr22_val_1.fq.gz
FQ2=./data/02_fastq_trimmed/K562_2_chr22_val_2.fq.gz
OUT=./data/03_aligned
## 7 min 4 cpus 
echo "bismark aligned"; date
# bismark --bowtie2 -p 2 --parallel 1 --bam --fastq -N ${mismatches} \
#  	--output_dir ${OUT} \
#         --prefix ${PREFIX} \
#         --genome_folder ${genome} \
#  	-1 ${FQ1} -2 ${FQ2}

##############################################################################################################################

BAM_IN=./data/03_aligned/*_bismark_bt2_pe.bam
OUT=./data/04_deduplicated

echo "Start deduplication"; date
# deduplicate_bismark --paired \
#                     --bam  \
#                     --output_dir ${OUT} \
#                     ${BAM_IN}

##############################################################################################################################

BAM_IN=./data/04_deduplicated/one_mismatch*.bam
OUT=./data/05_bismark_extractor/
genome=./data/00_util/

echo "bismark_methylation_extractor"; date
# bismark_methylation_extractor --paired-end \
#                               --parallel 1 \
#                               --ignore_r2 2 \
# 			      --gzip \
#                               --output ${OUT} \
#                               --genome_folder ${genome} \
#                               ${BAM_IN}

##################################################################################################################################

genome=./data/00_util/
IN=./data/04_deduplicated/one*.bam
OUT=./data/04_deduplicated
# bam2nuc --genome_folder ${genome} --dir ${OUT} ${IN}

##############################################################################################################################

echo "bismark2bedGraph"; date
IN=./data/05_bismark_extractor
OUT=./data/06_bedGraph
name=one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.txt.gz


# bismark2bedGraph --dir ${OUT} \
#                  --output ${name} \
#                  --buffer_size 10000M \
#                  --CX_context \
#                  $( ls ${IN}/C*${name} )

##############################################################################################################################

genome=data/00_util/
# /home/ahcorcha/projects/rrg-hsn/ahcorcha/resources/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta
COV=./data/06_bedGraph/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.txt.gz.bismark.cov.gz
OUT=./data/07_cytosine_report
out_cyt_report=one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.txt.gz.bismark

# coverage2cytosine --genome_folder ${genome} \
#                   --zero_based \
#                   --CX_context \
#                   --dir ${OUT} \
#                   --output ${out_cyt_report} \
#                   ${COV}

##################################################################################################################################
genome=./data/00_util/

# bismark2report --alignment_report ./data/03_aligned/one_mismatch.K562_1_chr22_val_1_bismark_bt2_PE_report.txt \
# 	       --dedup_report ./data/04_deduplicated/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplication_report.txt \
# 	       --splitting_report ./data/05_bismark_extractor/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt \
# 	       --mbias_report ./data/05_bismark_extractor/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.M-bias.txt \
# 	       --nucleotide_report ./data/04_deduplicated/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt


exit

cyt_report=./data/07_cytosine_report/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.txt.gz.bismark.CX_report.txt
chr_sizes=00_util/hg38.chrom.sizes

sort --output=${cyt_report}.sorted --parallel=2 --buffer-size=5G -k 1,1 -k2,2n ${cyt_report}

awk '{FS="\t";OFS="\t"} { print $1,$2,$2+1,$4 }' ${cyt_report}.sorted  > ${cyt_report}.sorted.meth  

echo "bedGraphToBigWig meth."; date                                                                                                                                                         
bedGraphToBigWig ${cyt_report}.sorted.meth.clipped \
		 ${chr_sizes} \
		 ${cyt_report}.sorted.meth.clipped.bw; date


echo "Unmeth"; date
awk '{FS="\t";OFS="\t"} { print $1,$2,$2+1,$5 }' \
    ${cyt_report}.sorted  > ${cyt_report}.sorted.unmeth

ls -lahgt ${cyt_report}.sorted.unmeth

echo "bedClip unmeth."; date
bedClip -verbose=2 \
        ${cyt_report}.sorted.unmeth \
        ${chr_sizes} \
        ${cyt_report}.sorted.unmeth.clipped

ls -lahgt ${cyt_report}.sorted.unmeth.clipped

echo "bedGraphToBigWig meth."; date
bedGraphToBigWig ${cyt_report}.sorted.unmeth.clipped \
                 ${chr_sizes} \
                 ${cyt_report}.sorted.unmeth.clipped.bw









# --parallel <int>         May also be --multicore <int>. Sets the number of cores to be used for the methylation extraction process.
#                          If system resources are plentiful this is a viable option to speed up the extraction process (we observed a
#                          near linear speed increase for up to 10 cores used). Please note that a typical process of extracting a BAM file
#                          and writing out '.gz' output streams will in fact use ~3 cores per value of --parallel <int>
#                          specified (1 for the methylation extractor itself, 1 for a Samtools stream, 1 for GZIP stream), so
#                          --parallel 10 is likely to use around 30 cores of system resources. This option has no bearing
#                          on the bismark2bedGraph or genome-wide cytosine report processes.
