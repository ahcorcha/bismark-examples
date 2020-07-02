#!/bin/bash

genome=../data/00_util/
COV=../data/06_bedGraph/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.txt.gz.bismark.cov.gz
OUT=../data/07_cytosine_report
out_cyt_report=one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.txt.gz.bismark

coverage2cytosine --genome_folder ${genome} \
                  --zero_based \
                  --CX_context \
                  --dir ${OUT} \
                  --output ${out_cyt_report} \
                  ${COV}
