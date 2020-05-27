#!/usr/bin/env bash
cd /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/aligned_cds_by_pal2nal
target=$(ls cluster.*.cds.align)
for file in ${target[*]};do
    /mnt/cheng/software/Gblocks_0.91b/Gblocks $file -t=c 
done
