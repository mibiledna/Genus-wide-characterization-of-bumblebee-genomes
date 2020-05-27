#!/usr/bin/perl
use warnings;
#This script was used to format the 19 way tree file to make species names be recognized by PAML.
my $usage = "perl   this_script   target_dir";#Direcotroy contains ML besttrees.
my $indir = shift or die "$usage\n";
opendir DIR, $indir or die "Cannot open $indir: $!";
foreach my $file (sort readdir DIR){#read files available in the direcotrory.
        my $filenumber = 0;
        # cluster.7774.fas.raxml.bestTree
        #(((((B.pyrosoma:0.006010,B.cullumanus:0.007683):0.001075,B.breviceps:0.007053):0.000717,B.sibiricus:0.006508):0.002811,(((B.terrestris:0.004207,B.ignitus:0.002242):0.011040,B.polaris:0.006061):0.003393,(((B.waltoni:0.005173,B.superbus:0.004269):0.019139,B.confuses:0.015256):0.010932,(B.picipes:0.006543,B.impatiens:0.008421):0.002825):0.001116):0.000630):0.000001,B.soroeensis:0.016306,((B.difficillimus:0.008092,((B.opulentus:0.008977,(B.skorikovi:0.004679,B.turneri:0.004731):0.003589):0.000450,B.haemorrhoidalis:0.013768):0.000827):0.000568,B.consobrinus:0.008551):0.000924):0.0;
        if($file =~ /cluster\.(\d+)\.fas\.raxml\.bestTree/){
           my $filehandleIN = 'IN'."$filenumber";
           my $filehandleOUT = 'OUT'."$filenumber";
           open $filehandleIN, "<$indir/$file" or die;
           open $filehandleOUT, ">/mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/data4paml/cluster.$1.fas.raxml.bestTree";
           while(<$filehandleIN>){
                 chomp;
                 my $whole_string = $_;
                 $whole_string =~ s/:0\.\d+//g;
                 $whole_string =~ s/:-?0\.\d+e-\d+//g;
                 print $filehandleOUT "$whole_string\n";
          }
          $filenumber++;
          close $filehandleIN;
          close $filehandleOUT;
     }
}
