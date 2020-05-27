#!/usr/bin/perl
use warnings;
##This scrpt was used to run codeml on candidate PSGs alignment, the control file is for Model 1
my $usage = "perl   this_script   candidatePSGs  DIRcontainingAln&Tree  codemlM1template";
my $PSG_cluster = shift or die "$usage\n";
my $indir = shift or die "$usage\n";
my $control = shift or die "$usage\n";
open IN, "<$PSG_cluster" or die;
my $cluster_string = '';#This string was used to hold all the cluster numbers.
while(<IN>){
      chomp;
      my @tem = split /\s+/;
      $tem[0] =~ s/BEB//;
      $cluster_string .= 'SEP'."$tem[0]".'SEP';
}
close IN;
open IN1, "<$control" or die;
my @array = ();#Used to hold the control File information.
my $i = 0;
while(<IN1>){
      chomp;
      $array[$i] = $_;
      $i++;
}
close IN1;
opendir DIR, $indir or die;
my $fileNumber = 0;
my $runNumber = 0;
foreach my $file (sort readdir DIR){#read files available in the direcotrory.
        #cluster.2153.fas
        #cluster.2153.fas.tree
        if($file =~ /^cluster\.([456789]\d+)\.fas$/){#Here to define the file type to avoid incorrectly read unrelated files.
           my $tem_match = 'SEP'."$1".'SEP';
           if($cluster_string =~ /$tem_match/){
              $fileNumber++;
              my $controlhandle = 'OUT'."$i";
              $i++;
              open $controlhandle, ">./controlFileM1.txt" or die;
              foreach (@array){
                   #seqfile = template
                   if(/seqfile/){
                      print $controlhandle "      seqfile = $indir$file\n";
                   }
                   elsif(/outfile/){
                       print $controlhandle "      outfile = /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/pamlM1Result/$file.mlc\n";#Here you could redirect output folder.
                   }
                   elsif(/treefile/){
                        print $controlhandle "     treefile = $indir$file.tree\n";
                   }
                   else {
                        print  $controlhandle "$_\n";
                   }
           }
           system ("/mnt/cheng/software/paml4.9i/bin/codeml ./controlFileM1.txt");
           $runNumber++;
           close $controlhandle;
       }
   }
}
closedir DIR;
print "total file processed: $fileNumber\n\t total codeml run: $runNumber\n";
