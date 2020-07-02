#!/bin/bash

genome=../data/00_util/

bismark2report --alignment_report ../data/03_aligned/one_mismatch.K562_1_chr22_val_1_bismark_bt2_PE_report.txt \
	       --dedup_report ../data/04_deduplicated/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplication_report.txt \
	       --splitting_report ../data/05_bismark_extractor/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt \
	       --mbias_report ../data/05_bismark_extractor/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.M-bias.txt \
	       --nucleotide_report ../data/04_deduplicated/one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt
