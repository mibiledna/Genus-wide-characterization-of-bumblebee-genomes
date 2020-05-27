#!/usr/bin/perl
use warnings;
#This scrpt was used to format the 19/12way alignments to make the file name and sequence name are recognized by PAML.
my $usage = "perl   this_script   target_dir";
my $indir = shift or die "$usage\n";
my $filenumber = 0;
my $deletenumber = 0;
opendir DIR, $indir or die "Cannot open $indir: $!";
LINE:foreach my $file (sort readdir DIR){#read files available in the direcotrory.
        #cluster.9.protein.fasta_CDSalign.fasta-gb;the file contain the alignment.
        #Sequence Names:>B.breviceps0147420;>gi|815908618|ref|XP_012239976.1|;>ref|XP_012167048.1|
        if($file =~ /cluster\.(\d+)\.cds\.align-gb$/){
           my $cluster_number = $1;
           my %speciesNumber = ();#This hash was used to count the number of gene copy for each species.
           $filenumber++;
           my $filehandleIN = 'IN'."$filenumber";
           my $filehandleOUT = 'OUT'."$filenumber";
           open $filehandleIN, "<$indir/$file" or die;
           open $filehandleOUT, ">/mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/data4paml/cluster.$cluster_number.fas" or die;
           while(<$filehandleIN>){
                 chomp;
                 if(/^>(B\.\D+)\d+$/){
                   my $tem_species = $1;
                   print $filehandleOUT ">$tem_species\n";
                   $speciesNumber{$tem_species}++;
                 }
                 #XP_003401942.1
                 elsif(/^>\w\w_\d+\.\d+$/){
                   print $filehandleOUT ">B.terrestris\n";
                   my $tem_species = 'B.terrestris';
                   $speciesNumber{$tem_species}++;
                 }
                 #BIMP15269-PA
                 elsif(/^>B\w+-PA$/){
                   print $filehandleOUT ">B.impatiens\n";
                   my $tem_species = 'B.impatiens';
                   $speciesNumber{$tem_species}++;
                 }
                 else {
                   print $filehandleOUT "$_\n";
                }
          }
          close $filehandleIN;
          close $filehandleOUT;
          foreach my $specis (keys %speciesNumber){
                  if($speciesNumber{$specis} > 1){#which means some species has more than one gene copy.
                     system ("rm /mnt/cheng/pangenome/all_predicted_proteins_single_isoform/selection_analysis/data4paml/cluster.$cluster_number.fas");
                     $deletenumber++;
                     next LINE;
                  }
          }
     }
}
print "Total file number $filenumber\tDeleted number $deletenumber\n";
