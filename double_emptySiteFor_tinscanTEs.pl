#!/usr/local/bin/perl-w
use strict;
use Bio::SearchIO;
#This script was used to identify empty sites that are present in the two most ancient genomes based on BLASTn.
my $usage = "perl    this_script    TinScanResults.gff   genomeSeq;#candidate TEs were identified by tinscan. 
my $input = shift or die "$usage\n";
my $genome = shift or die "$usage\n";
open IN, "<$input" or die "$usage\n";
open OUT, ">$input.doubleEmptySites.gff" or die;
while(<IN>){
     chomp;
     if(/Candidate_Insertion/){
         my $indictor = 0;
         my $chromosome = '';
         my $start = 0;
         my $stop = 0;
         #flattened_line_1539-0   InsertScanner   Candidate_Insertion     10338   11094   .       +       .       ID=IS_00001
         my @array = split /\s+/;
         my $array_length = $array[4] - $array[3] + 1;
         my $db = Bio::DB::Fasta->new("$genome");
         my $seq = $db->get_Seq_by_id("$array[0]");
         my $length = $seq->length;
         $chromosome = $array[0];
         $start = $array[3] - 200;
         $stop = $array[4] + 200;
         if(($start > 0) and ($stop < $length) and ($length > 3000) and ($array_length > 80)){#Make sure coordinates are within sequence range.
             open QUERY, ">BLAST_seq.txt" or die;
             my $upstream = $seq->subseq($start=>$array[3]);
             my $downstream = $seq->subseq($array[4]=>$stop);
             my $BLAST_seq = "$upstream"."$downstream";
             print QUERY ">$chromosome:$start-$stop\n$BLAST_seq\n";
             close QUERY;
        }
        open BLASTOUTPUTFILE1, ">blastOutputFile1" or die "$!";
        my $blastSysString = "/mnt/cheng/software/ncbi-blast-2.4.0+/bin/blastn -task blastn -dust no -db /mnt/cheng/blast_db/B.waltoni_Scaffolds_pass7.fa -query BLAST_seq.txt -out blastOutputFile1 -evalue 0.0000000001";
        system($blastSysString);
        my $blastIn = new Bio::SearchIO(-format => 'blast', -file => 'blastOutputFile1');
        LOOP:while(my $result = $blastIn->next_result ){
                        while (my $hit = $result->next_hit ){
                               while (my $hsp = $hit->next_hsp){
                                      my $hitName = $hit->name;
                                      my $qStart = $hsp->start('query');
                                      my $qEnd = $hsp->end('query');
                                      my $qLength = $hsp->length('query');
                                      my $sStart = $hsp->start('hit');
                                      my $sEnd = $hsp->end('hit');
                                      my $qString = $hsp->query_string;
                                      my $sString = $hsp->hit_string;
                                      if(($qStart <= 50) and ($qEnd >= 350) and ($all_seq ne '')){#We allow 50 bp of missing.
                                          $indictor++;
                                          last LOOP;
                                      }
                                }
                         }
        }
        close BLASTOUTPUTFILE1;
        if($indictor == 1){
          print OUT "$_\n";
        }
  }
}
system ("rm BLAST_seq.txt blastOutputFile1");
close IN;
close OUT;
print "This script has been done successfully!\n";

