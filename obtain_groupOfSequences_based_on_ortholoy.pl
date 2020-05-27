#!/usr/bin/perl-w
#This script was used to extract a group of sequences based on the cluster information obtained from OrthoDBsoft.
use strict;
use Bio::DB::Fasta;
no strict 'refs'; 
my $usage = "perl  this_script.pl  output_of_OrthoDBsoft(renamed)  combinedSequences";
my $input = shift or die "$usage\n"; #The og or og_inpar file of OrthoDBsoft.
my $combinedSeq = shift or die "$usage\n"; #The combined sequences from different species.
my $db = Bio::DB::Fasta->new("$combinedSeq");
open READ, "<$input" or die "$usage\n";
my %cluster = ();#This hash was used to keep cluster number and sequence names in it.
while(<READ>){
      chomp;
      my @array=();
      if (/^\d+\s+\w+/){
         @array = split /\s+/;
         my $ClusterNumber = $array[0];
         my $SequenceName = $array[1];
         $cluster{$ClusterNumber} .= "$SequenceName".'SEPSEP';
      }
}
close READ;
foreach my $cluster_name (keys %cluster){
        my @Names = split /SEPSEP/, $cluster{$cluster_name};
        my $handle = 'OUT'."$cluster_name";
        open $handle, ">cluster.$cluster_name.protein.fasta";
        foreach my $seqNameFull (sort @Names){
                # BOPU|B.opulentus0077560
                #  AMEL|Am|GB40007-PA
                if($seqNameFull =~ /^(\w+)\|(\S+)$/){
                    my ($species,$seqName) = ($1,$2);
                    my $length = $db->length("$seqName");
                    my $seqstr = $db->seq($seqName, 1 => $length);
                    if($length > 30){#Here to make sure that the target sequences is available.
                       print $handle ">$seqNameFull\n$seqstr\n";
                    }
                 }
       }
       close $handle;
}
exit;
