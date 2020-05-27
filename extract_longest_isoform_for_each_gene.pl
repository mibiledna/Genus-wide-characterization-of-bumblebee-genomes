#!/usr/bin/perl-w
#This script was used to extract the longest cds or pep for annotations coming from GenBank.
use Bio::SeqIO;
my $usage = "perl   thisScript    GenBank_annotation    all_GenBank_protein.fa\n";
my $annotation = shift or die "$usage\n";
my $Sequence_Input = shift  or die "$usage\n";
my %cds = ();#hold the lengthes of all cds.
my %gene = ();#hold all the genes, along with their cds names.
open ANNO, "<$annotation" or die;
#NW_003789112.1  Gnomon  CDS     111496  111662  .       -       0       ID=cds-XP_012341479.1;
#NW_003789106.1  Gnomon  gene    125     490     .       -       .       ID=gene-LOC105734758;
my $genename = '';
my $inNumber = 0;
while(<ANNO>){
      chomp;
      my @tem = split /\s+/;
      if($tem[2] eq 'CDS'){
         if($tem[8] =~ /ID=cds-(\w+\.\d+);/){
            my $cdsname = $1;
            $cds{$cdsname} += $tem[4] - $tem[3] + 1;
            $gene{$genename} .= "$cdsname".'SEP';
         }
      }
      if($tem[2] eq 'gene'){
         if($tem[8] =~ /ID=gene-(\w+);/){
            $genename = $1;
            $inNumber++;
         }
      }
}
close ANNO;
my $geneWithCDS = 0;
my $finalCDSstring = '';#This varial was used to hold all the longest CDS names.
foreach my $eachGene (keys %gene){
        my $cds_length = 0;#This was used to hold the longest cds length.
        my $cds_name = '';##This was used to hold the longest cds name.
        my @tem = split /SEP/, $gene{$eachGene};
        foreach my $eachCDS (@tem){
                if($cds{$eachCDS} > $cds_length){
                   $cds_name = $eachCDS;
                   $cds_length = $cds{$eachCDS};
                }
        }
        if($cds_name ne ''){
           $finalCDSstring .= "$cds_name";
           $geneWithCDS++;
        }
}
my $inseq = Bio::SeqIO -> new(-file => "<$Sequence_Input", -format => "fasta");
open OUT, ">$Sequence_Input.longestIsoform.fa" or die;
while(my $seq = $inseq->next_seq){
      my $seq_name = $seq->id;
      my $sequences = $seq->seq;
      if($finalCDSstring =~ /$seq_name/){
         print OUT ">$seq_name\n$sequences\n";
         $outNumber++;
      }
}
close OUT;
print "TotalGeneNumber $inNumber\tGeneWithCDS $geneWithCDS\tSequencePrinted $outNumber\n";
