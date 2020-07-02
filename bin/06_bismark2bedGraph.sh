#!/bin/bash

echo "bismark2bedGraph"; date
IN=../data/05_bismark_extractor

ls -l ${IN}

OUT=../data/06_bedGraph
name=one_mismatch.K562_1_chr22_val_1_bismark_bt2_pe.deduplicated.txt.gz

bismark2bedGraph --dir ${OUT} \
                 --output ${name} \
                 --buffer_size 10000M \
                 --CX_context \
                 $( ls ${IN}/C*${name} )
