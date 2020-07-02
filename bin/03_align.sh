#!/bin/bash


genome=../data/00_util/
mismatches=1
PREFIX=one_mismatch

FQ1=../data/02_fastq_trimmed/K562_1_chr22_val_1.fq.gz
FQ2=../data/02_fastq_trimmed/K562_2_chr22_val_2.fq.gz
OUT=../data/03_aligned


echo "bismark aligned"; date
bismark --bowtie2 -p 2 --parallel 1 --bam --fastq -N ${mismatches} \
 	--output_dir ${OUT} \
        --prefix ${PREFIX} \
        --genome_folder ${genome} \
 	-1 ${FQ1} -2 ${FQ2}
