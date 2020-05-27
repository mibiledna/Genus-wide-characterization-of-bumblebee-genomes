#!/usr/bin/perl
use warnings;
##This scrpt was used to run codeml on each ortholog alignment, the control file will be changed correspondingly and with a run model of 2 positive.
my $usage = "perl   this_script   target_dir    controlFileModel2posi  marked_species";#Target directory is where you put trimmed alignments and corresponding tree files.
my $indir = shift or die "$usage\n";
my $control = shift or die "$usage\n";
my $species = shift or die "$usage\n";
system ("mkdir /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/$species-pamlM2PositiveResult");
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
        if($file =~ /cluster\.\d+\.fas$/){#Here to define the file type to avoid incorrectly read unrelated files.
           $fileNumber++;
           my $controlhandle = 'OUT'."$i";
           $i++;
           my $treehandle = 'tree'."$fileNumber";
           open $treehandle, "<$indir$file.tree";
           open TREE, ">./$species.tree" or die;
           while(<$treehandle>){
                  chomp;
                  s/[:]?-\d+\.\d+//g;#Get rid of branch length.
                  s/$species/$species#1/;#Here you could set the foregrond branches.
                  #s/skorikovi/skorikovi#1/;
                  #s/difficillimus/difficillimus#1/;
                  #s/waltoni/waltoni#1/;
                  print TREE "$_";
            }
            close $treehandle;
            close TREE;
           open $controlhandle, ">./controlFileM2positive.$species.txt" or die;
           foreach (@array){
                   #seqfile = template
                   if(/seqfile/){
                      print $controlhandle "      seqfile = $indir$file\n";
                   }
                   elsif(/outfile/){
                       print $controlhandle "      outfile = /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/$species-pamlM2PositiveResult/$file.M2positive.mlc\n";#Here you could redirect output folder.
                   }
                   elsif(/treefile/){
                        print $controlhandle "     treefile = ./$species.tree\n";
                   }
                   else {
                        print  $controlhandle "$_\n";
                   }
           }
           system ("/mnt/cheng/software/paml4.9i/bin/codeml ./controlFileM2positive.$species.txt");
           $runNumber++;
           close $controlhandle;
      }

}
closedir DIR;
print "total file processed: $fileNumber\n\t total codeml run: $runNumber\n";
