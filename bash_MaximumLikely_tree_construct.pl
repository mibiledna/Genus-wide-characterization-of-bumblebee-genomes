#!/usr/bin/perl
use warnings;
#This scrpt was used to produce ML tree by RAxML in batch.
my $usage = "perl   this_script   target_dir";#No / after direcotry name.
my $indir = shift or die "$usage\n";#This is the directory contains all the trimmed CDSs.
opendir DIR, $indir or die "Cannot open $indir: $!";
my $fileNumber = 0;#Used to count the number of files.
foreach my $file (sort readdir DIR){#read files available in the direcotrory.
        #cluster.3250.fas
        if($file =~ /^cluster\.\d+\.fas$/){
           $fileNumber++;
            system("~/software/raxml_ng/bin/raxml-ng --msa $indir/$file --model GTR+G --prefix /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/RAxMLtrees_scOrtholog/$file --threads 1 --seed 2");
        system("rm /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/RAxMLtrees_scOrtholog/$file.raxml.startTree  /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/RAxMLtrees_scOrtholog/$file.raxml.bestModel");
        }
}
close DIR;
print "Total file number $fileNumber\n";
