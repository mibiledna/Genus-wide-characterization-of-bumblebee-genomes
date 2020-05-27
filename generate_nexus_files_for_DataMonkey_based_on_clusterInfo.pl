#!/usr/bin/perl
use warnings;
#This scrpt was used to prepare alignments in nexus format (include both DNA sequences and NJ or ML tree).
my $usage = "perl   this_script   known_cluster_number  target_dir";#Target directory contains aligned, trimmed DNA sequences and corresponding NJ trees.
my $cluster = shift or die "$usage\n";#This file contains cluster numbers.
my $indir = shift or die "$usage\n";#This directory contains the alignment file and NJ tree file..
open IN, "<$cluster" or die "$usage\n";
my %ClusterNumber = ();#This hash will hold cluster numbers.
while(<IN>){
      chomp;
      #11; 22; 23456;
      my @tem = split /\s+/;
      $ClusterNumber{$tem[0]} = 'piRNA';#Here you could change tem[1] to gene type.
}
close IN;
my $total_number = 0;#Count how many clusters were obtained.
opendir DIR, $indir or die "Cannot open $indir: $!";
LINE:foreach my $fileName (sort readdir DIR){#read files available in the direcotrory.
        #cluster.3765.fas.nexus
        #cluster.3766.fas.tree
        foreach my $clusterNumber (keys %ClusterNumber){
                if($fileName =~ /^cluster\.$clusterNumber\.fas\.nexus/){
                   system ("cat $indir/$fileName  $indir/cluster.$clusterNumber.fas.raxml.bestTree > ./cluster.$clusterNumber.$ClusterNumber{$clusterNumber}.nexus");#ML tree
                   #system ("cat $indir/$fileName  $indir/cluster.$clusterNumber.fas.tree > ./cluster.$clusterNumber.$ClusterNumber{$clusterNumber}.nexus");# NJ tree
                   $total_number++;
                   next LINE;
                }
       }
} 
print "Total $total_number files!\n";
