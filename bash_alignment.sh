#!/usr/bin/env bash

cd /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/aligned_protein_sequences
un_align=$(ls *)

for fn in ${un_align[*]};do
    mafft --quiet --thread 60 --auto $fn > $fn"_align"
done

