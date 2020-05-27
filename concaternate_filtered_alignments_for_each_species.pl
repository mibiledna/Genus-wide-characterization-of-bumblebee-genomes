#!/usr/bin/perl
use warnings;
##This scrpt was used to concaternate all the eligible trimmed aligned files in one folder for each species.
my $usage = "perl   this_script   target_dir";
my $indir = shift or die "$usage\n";#No / after direcotroy.
my %sequences = ();
my $fileNumber = 0;
my $seqname = '';
my %superSequence = ();#This hash was used to keep the concatenated supersequence for each species.
my $speciesName = '';#The varial was used to keep the species name.
opendir DIR, $indir or die;
foreach my $file (sort readdir DIR){#read files available in the direcotrory.
        #File name: cluster.10867.protein.fasta_trimed_align
        if($file =~ /trimed_align$/){#Here to define the file type to avoid incorrectly read unrelated files.
           $fileNumber++;
           my $handleName = 'OUT'."$fileNumber";
           open $handleName, "<$indir/$file" or die;
           while(<$handleName>){
                 chomp;
                 if(/^>(\w+)\|/){
                    $speciesName = $1;
                 }
                 else {
                    $superSequence{$speciesName} .= $_; 
                 }
           }
           close $handleName;
      }
}
closedir DIR;
open OUT, ">23AlignedTrimmedSupersequences.fasta" or die;
foreach my $name (keys %superSequence){
        print OUT ">$name\n$superSequence{$name}\n";
}
close OUT;
print "Total files processed: $fileNumber\n";
