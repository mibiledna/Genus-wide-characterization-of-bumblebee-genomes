#!/usr/local/bin/perl-w
use strict;
#This script was used to format the output of Parallel LASTZ results to meet the requirment of tinscan-find.
my $usage = "perl   this_script   LASTZoutput";
my $input = shift or die "$usage\n";
open IN, "<$input" or die;
open OUT, ">$input.tinscan.tab" or die;
print OUT "#name1\tstrand1\tstart1\tend1\tname2\tstrand2\tstart2+\tend2+\tscore\tidentity\n";
while(<IN>){
#input format
#2404814 flattened_line_1216-0   +       57306   0       32667   scaffold_18_uid_1494243949      +       8215226 302232  334783  28901/31654     91.3%   32667/57306     57.0%
      chomp;
      my @tem = split /\t/;
      $tem[12] =~ s/%//;
      print OUT "$tem[1]\t$tem[2]\t$tem[4]\t$tem[5]\t$tem[6]\t$tem[7]\t$tem[9]\t$tem[10]\t$tem[0]\t$tem[12]\n";      
      #name1  strand1 start1  end1    name2   strand2 start2+ end2+   score   identity
}
close IN;
close OUT;

