#!/usr/bin/perl-w
#This script was used to get the summary of TE families based on the output of RepeatMasker;
use strict;
no strict 'refs';
my $usage = "perl  summarize_TE_landscape_v1.0.pl    .out_file_of_RepeatMasker";
my $in = shift or die "$usage";
open IN, "<$in" or die "$!";
open OUT, ">$in.TEsummary.txt";
print OUT "TEsuperfamily\tTEfragments\tTEtotallength\n";
my %TEclass = ();
my @tem = ();
my $k=0;
#At first, generate a hash to hold the names of different TE families.
while (<IN>){
    chomp;
    #scaffold_122_uid_1508205462     7834    7909    C       flattened_line_157-1.fa_69320   LINE/Jockey
    @tem = split /\s+/, $_;
    $k++;
    $TEclass{$tem[5]} = $k;
}
close IN;
my $tename;
my $i = 0;
foreach $tename(sort {$a cmp $b} keys %TEclass){
      my $TEtotallength = 0;
      my $TEnumber = 0;
      $i++; #open and close one handle frequently will disable the program, so create different handles here.
      my $filehandlename = 'IN'."$i";
      open $filehandlename, "<$in" or die "$!";  
      while (<$filehandlename>){
            chomp;
            @tem = split /\s+/, $_;
            if (/^\w+/){
                  if ($tem[5] =~ /^$tename$/){ 
                      my $temvalue = $tem[2] - $tem[1] + 1;
                      if($temvalue >= 80){
                         $TEtotallength = $temvalue + $TEtotallength;
                         $TEnumber++;
                      }
                  }
            }
      }
      #my $rate = sprintf "%.4f", $TEtotallength/40558985; #The total TE length should be divided by the length of shotgun reads for this genome.
      print OUT "$tename\t$TEnumber\t$TEtotallength\n";
      close $filehandlename;
}
close OUT;

