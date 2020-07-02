#!/bin/bash


BAM_IN=../data/03_aligned/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.bam
OUT=../data/04_deduplicated

echo "Start deduplication"; date
deduplicate_bismark --paired \
                    --bam  \
                    --output_dir ${OUT} \
                    ${BAM_IN}
