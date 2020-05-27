#!/usr/bin/perl
use warnings;
#This scrpt was used to convert multiple sequence alignments in FASTA format to NEXUS format.
my $usage = "perl   this_script   target_dir";#Files in one directory will be converted into suitable format.
my $indir = shift or die "$usage\n";
opendir DIR, $indir or die "Cannot open $indir: $!";
my $filenumber = 0;
foreach my $file (sort readdir DIR){#read files available in the direcotrory.
        if($file =~ /\.fas$/){
           $filenumber++;                 
           system("/mnt/cheng/software/clustalw-2.1/src/clustalw2 -INFILE=$indir/$file -CONVERT -TYPE=DNA -OUTFILE=$indir/$file.nexus -OUTPUT=NEXUS -OUTORDER=INPUT");#Here you could change the multiple alignments into PHYLIP, NEXUS and whatever format do you need.
        }
}
print "Total file number $filenumber\n"; 
