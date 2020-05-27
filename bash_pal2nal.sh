#!/usr/bin/env bash
## utilizing pal2nal.pl with input of CDS and protein sequence to generate codon-based fasta for PAML
cd /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/aligned_protein_sequences
#Protein_align cluster.9.protein.fasta_align
#CDS sequences cluster.737.protein.fasta
align=$(ls cluster.*.protein.fasta_align)
for f in ${align[*]}; do  
g=$(echo $f | sed 's/_align//g'); 
o=$(echo $g | sed 's/protein\.fasta/cds.align/g');
perl /mnt/cheng/software/pal2nal.v14/pal2nal.pl $f $g -output fasta -nogap -nomismatch -codontable 1 >  /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/aligned_cds_by_pal2nal/$o;  
done

