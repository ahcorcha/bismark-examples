#!/bin/bash

FQ1=../data/01_fastq/K562_1_chr22.fq.gz
FQ2=../data/01_fastq/K562_2_chr22.fq.gz

OUT=../data/02_fastq_trimmed

trim_galore --quality 20 --gzip --paired --phred33 --fastqc \
            --illumina --output_dir ${OUT} \
            --cores 4 ${FQ1} ${FQ2}
