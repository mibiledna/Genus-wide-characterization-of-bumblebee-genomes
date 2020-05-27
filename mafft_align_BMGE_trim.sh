#!/usr/bin/env bash

cd /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/23beeOrtholog/orthologous_proteins
un_align=$(ls cluster.*.protein.fasta)

for fn in ${un_align[*]};do
    mafft --quiet --thread 70 --auto $fn > $fn"_align"
    java -jar ~/software/BMGE.jar -t AA -i $fn"_align" -of $fn"_trimed_align" 
done


