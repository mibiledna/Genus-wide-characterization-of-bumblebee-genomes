#!/usr/bin/perl-w
#This script was used to extract representive sequence names for given clusters.
use strict;
my $usage = "perl  this_script.pl  known_clusterNumbers output_of_OrthoDBsoft(formatted)";
my $input = shift or die "$usage\n"; #The known cluster numbers list.
my $clusterInfo = shift or die "$usage\n"; #The og file.
open READ, "<$input" or die "$usage\n";
my $known_cluster_num = '';#This string was used to hold cluster names.
while(<READ>){
      chomp;
      #1177        whatever
      if(/^(\d+)\s*/){
         $known_cluster_num .= 'SEP'."$1".'SEP';
      }
}
close READ;
open CLUSTER, "<$clusterInfo" or die "$usage\n";
open OUT, ">$input.geneNames.txt" or die;
while(<CLUSTER>){
      chomp;
      my @array=();
      if (/^\d+\s+\w+/){
         @array = split /\s+/;
         my $ClusterNumber = 'SEP'."$array[0]".'SEP';
         if($known_cluster_num =~ /$ClusterNumber/){
            if($array[1] =~ /superbus/){#Here to define which species do you want to keep.
               $ClusterNumber =~ s/SEP//g;
               print OUT "$ClusterNumber\t$array[1]\n";
            }
         }
    }
}
close CLUSTER;
close OUT;
