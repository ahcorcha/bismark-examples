#!/bin/bash

genome=../data/00_util/
IN=../data/04_deduplicated/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.bam
OUT=../data/04_deduplicated

bam2nuc --genome_folder ${genome} --dir ${OUT} ${IN}
