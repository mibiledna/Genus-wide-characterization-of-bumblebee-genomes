#!/usr/bin/perl-w
#This script was used to get rid of protein names that turn out to be LncRNAs in a two-column mating data.
use strict;
my $usage = "perl  this_script.pl  GeneNamesThatAreLncRNAs   two-column mating data";
my $LncRNAnames = shift or die "$usage\n"; #This is a file contain gene names that turns out to be LncRNAs.
my $two_column = shift or die "$usage\n"; #This is the  two-column mating data file.
open READ, "<$LncRNAnames" or die "$usage\n";
my $LncRNA = '';#This string was used to keep all the LncRNA names. 
while(<READ>){
      chomp;
      #BIMP17397-RA
      $LncRNA .= "$_".'SEP';
}
close READ;
open OrthoGroup, "<$two_column" or die;
open OUT, ">$two_column.noLncRNA.txt" or die;
while(<OrthoGroup>){
      chomp;
      #BIMP:000000  BIMP17397-RA
      my @tem = split /\s+/;      
      my $tem_match = "$tem[1]".'SEP';
      if($LncRNA !~ /$tem_match/){
         print OUT "$tem[0]\t$tem[1]\n";
      }
}
close READ;
close OrthoGroup;
close OUT;

