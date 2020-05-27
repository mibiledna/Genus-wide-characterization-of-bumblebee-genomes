#!/usr/bin/perl
use warnings;
##This scrpt was used to identify positive selected genes based on the two output of codeml, M2positive and M2 null.
my $usage = "perl   this_script   theDIRCodemlM2null theDIRCodemlM2positive";#keep / for directory.
my $indir1 = shift or die "$usage\n";
my $indir2 = shift or die "$usage\n";
my $species = '';
if($indir1 =~ /(\S+)-pamlM2nullResult/){
   $species = $1;
}
my %M2nullData = ();#This hash was used to hold the results from M2 null.
opendir DIR1, $indir1 or die;
my $fileNumber = 0;
foreach my $file (sort readdir DIR1){#read files available in the direcotrory.
        #cluster.99.fas.M2positive.mlc
        if($file =~ /^cluster\.(\d+)\.\S+\.mlc/){
            my $geneName = $1;
            $fileNumber++;
            my $handle = 'IN'."$fileNumber";
            open $handle, "<$indir1$file" or die;
            while(<$handle>){
                  chomp;
                  #lnL(ntime:  5  np:  9):  -3100.373572      +0.000000
                  if(/^lnL/){
                      my @array  = split /\s+/;
                      $M2nullData{$geneName} = $array[4];
                  }
           }
           close $handle;
       }
}
closedir DIR1;
opendir DIR2, $indir2 or die;
open OUT, ">./$species.GeneAndM2PositiveVsNull.txt" or die;
print OUT "ClusterNumber\tM2positive\tM2null\n";
foreach my $file2 (sort readdir DIR2){#read files available in the direcotrory.
        if($file2 =~ /^cluster\.(\d+)\.\S+\.mlc/){
            my $geneName = $1;
            $fileNumber++;
            my $handle = 'IN'."$fileNumber";
            open $handle, "<$indir2$file2" or die;
            while(<$handle>){
                  chomp;
                  #lnL(ntime:  5  np:  9):  -3100.373572      +0.000000
                  if(/^lnL/){
                     my @array  = split /\s+/;
                     print OUT "$geneName\t$array[4]\t$M2nullData{$geneName}\n";
                 }
            }
            close $handle;
        }
}
closedir DIR2;
