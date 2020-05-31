#!/usr/bin/perl-w
#This script was used to change sequence names in '.og' file based on a two-column mating data (the first is the name in OrthoGroup, the second is the original one).
#Only items with successfully replaced sequence names will be kept for futher analysis.
use strict;
my $usage = "perl  this_script.pl  MatingDatePairCombined  input_OrthoGroup_file(.og file)";
my $matePair = shift or die "$usage\n"; #This is a file contain two columns,the first is the name in OrthoGroup file, the second is the original one.When there are multiple species, cat all the files into one.
my $OrthoGroup = shift or die "$usage\n"; #This is the OrthoGroup file obtained from OrthoDB software.
open READ, "<$matePair" or die "$usage\n";
my %matingNames = ();#This hash was used to keep the mating information of sequence names. 
while(<READ>){
      chomp;
      my @array = ();
      @array = split /\s+/;
      $matingNames{$array[0]} = $array[1];
}
close READ;
open OrthoGroup, "<$OrthoGroup" or die;
open OUT, ">$OrthoGroup.noLncRNA.og" or die;
while(<OrthoGroup>){
      chomp;
      #0	BBREVICEPS:000703	0	10745	83	10827	40992.9	62.9691	0
      #if(/^\d+\s+(\S+)\s+\d+\s+\d+\s+\d+\s+/){
      if(!/^\#/){
         my @tem = split /\s+/;      
         if(exists $matingNames{$tem[1]}){
            print OUT "$tem[0]\t$tem[1]\t$tem[2]\t$tem[3]\t$tem[4]\t$tem[5]\t$tem[6]\t$tem[7]\t$tem[8]\n";
        }
      }
}
close READ;
close OrthoGroup;

