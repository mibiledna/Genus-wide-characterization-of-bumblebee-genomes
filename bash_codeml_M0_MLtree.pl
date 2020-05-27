#!/usr/bin/perl
use warnings;
##This scrpt was used to run codeml on each ortholog alignment, the control file will be changed correspondingly and with a run model of 0.
my $usage = "perl   this_script   target_dir    controlFile(M0)";#Target directory is where you put trimmed alignments and corresponding tree files.
my $indir = shift or die "$usage\n";#Should without /.
my $control = shift or die "$usage\n";
open IN, "<$control" or die;
my @array = ();#Used to hold the control File information.
my $i = 0;
while(<IN>){
      chomp;
      $array[$i] = $_;
      $i++;
}
close IN;
opendir DIR, $indir or die;
my $fileNumber = 0;
my $runNumber = 0;
foreach my $file (sort readdir DIR){#read files available in the direcotrory.
        #File name cluster.7843.fas
        if($file =~ /cluster\.\d+\.fas$/){#Here to define the file type to avoid incorrectly read unrelated files. Also you could add the first letter of cluster number to do it in parallel.
           $fileNumber++;
           my $controlhandle = 'OUT'."$i";
           $i++;
           open $controlhandle, ">./controlFileM0.txt" or die;
           foreach (@array){
                   #seqfile = template
                   if(/seqfile/){
                      print $controlhandle "      seqfile = $indir/$file\n";
                   }
                   elsif(/outfile/){
                       print $controlhandle "      outfile = /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/pamlM0ResultMLtree/$file.mlc\n";#Here you could redirect output folder.
                   }
                   elsif(/treefile/){
                        print $controlhandle "     treefile = $indir/$file.raxml.bestTree\n";
                   }
                   else {
                        print  $controlhandle "$_\n";
                   }
           }
           system ("/mnt/cheng/software/paml4.9i/bin/codeml ./controlFileM0.txt");
           $runNumber++;
           close $controlhandle;
      }
}
closedir DIR;
print "total file processed: $fileNumber\n\t total codeml run: $runNumber\n";
