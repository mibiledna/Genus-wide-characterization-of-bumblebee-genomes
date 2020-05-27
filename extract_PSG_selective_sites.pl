#!/usr/local/bin/perl-w
#This script was used to capture the codon site under positive seleciton for a bunch of clusters.
my $usage = "perl    this_script    clusterNumber_PSGs     directory_containing_Model2positiveResults";
my $cluster = shift or die "$usage\n";
my $indir = shift or die "$usage\n";
open IN, "<$cluster" or die;
my $cluster_string = '';#This string was used to hold all the cluster numbers.
while(<IN>){
      chomp;
      my @tem = split /\s+/;
      $cluster_string .= 'SEP'."$tem[0]".'SEP';
}
close IN;
my $filenumber = 0;
my %selectiveCodon = ();#Hold all the cluster, along with their selective codons.
opendir DIR, $indir or die;
my $key = '';#Used to give a unique key for hash.
foreach my $file (sort readdir DIR){#read files available in the direcotrory.
        #File name:cluster.5986.fas.M2positive.mlc
        if($file =~ /cluster\.(\d+)\.\S+\.mlc/){
           my $clusterNum = $1;
           my $tem_name = 'SEP'."$clusterNum".'SEP';
           if($cluster_string =~ /$tem_name/){
              my $handle = 'IN'."$filenumber";
              open $handle, "<$indir$file" or die;
              while(<$handle>){
                    chomp;
                    #Naive Empirical Bayes (NEB)     
                    #   580 V 0.501*
                    #   Bayes Empirical Bayes
                    #   #   580 V 0.991**
                    if(/\(NEB\)/){
                       $key = "$clusterNum".'NEB';
                    }
                    if(/\(BEB\)/){
                       $key = "$clusterNum".'BEB';
                    }
                    if(/^\s+(\d+\s\w\s\d\.\d+[*]+)$/){
                        $selectiveCodon{$key} .= "$1"."\t";
                    }
              }
              close $handle;
              $filenumber++;
          }
     }
}
closedir DIR;
open OUT, ">$cluster.selectiveCodons.txt";
foreach (keys %selectiveCodon){
         if(/BEB/){
            print OUT "$_\t$selectiveCodon{$_}\n";
         }
}
close OUT;
