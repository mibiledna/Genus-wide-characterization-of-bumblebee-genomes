#!/usr/bin/perl-w
#This script was used to extract GO terms for representive sequence names.
use strict;
my $usage = "perl  this_script.pl  known_GeneNumbers GO_annotation(agriGO or WEGO format)";
my $input = shift or die "$usage\n"; #The known cluster numbers list.
my $go_Info = shift or die "$usage\n"; #The og file.
open READ, "<$input" or die "$usage\n";
my $known_gene_names = '';#This string was used to hold cluster names.
while(<READ>){
      chomp;
      #40      B.superbus0037020
      if(/^\d+\s+(\S+)/){
         $known_gene_names .= "$1".'SEP';
      }
}
close READ;
open GO, "<$go_Info" or die "$usage\n";
open OUT, ">$input.WEGO.txt" or die;
while(<GO>){
      chomp;
      #B.superbus0112800       GO:0005875
      my @array=();
      @array = split /\s+/;
      my $tem_match = "$array[0]".'SEP';
      if($known_gene_names =~ /$tem_match/){
            print OUT "$_\n";
      }
}
close GO;
close OUT;
