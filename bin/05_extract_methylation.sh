#!/bin/bash


BAM_IN=../data/04_deduplicated/one_mismatch*.bam
OUT=../data/05_bismark_extractor/
genome=../data/00_util/

echo "bismark_methylation_extractor"; date
bismark_methylation_extractor --paired-end \
                              --parallel 1 \
                              --ignore_r2 2 \
			      --gzip \
                              --output ${OUT} \
                              --genome_folder ${genome} \
                              ${BAM_IN}
