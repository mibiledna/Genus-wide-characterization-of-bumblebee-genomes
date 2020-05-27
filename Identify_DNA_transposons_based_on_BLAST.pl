#!/usr/bin/perl-w
#This script was used to identify DNA transposons by using proteins encoded by known DNA transposon as query to BLAST against candidate DNA transposon seqeunces (with 2kb planking)ge.
use strict;
use Bio::SeqIO;
use Bio::SearchIO;
use Bio::DB::Fasta;
my $usage = "perl   this_script   DNA_protein_database   Target_database";
my $query = shift or die "$usage";
my $genome = shift or die "$usage";
my $inseq = Bio::SeqIO -> new(-file => "<$query", -format => "fasta");
my $db = Bio::DB::Fasta->new("$genome");
my $inputSeqLength = 0;
open OUT, ">$genome.DNAtransposons.txt" or die "$!";
while(my $seq = $inseq->next_seq){
      my $seq_name = $seq->id;
      my $sequence = $seq->seq;
      $inputSeqLength = $seq->length;
      open BLASTInput, ">./BLASTInput.txt" or die "$!";
      print BLASTInput ">$seq_name\n$sequence\n";
      close BLASTInput;
      open BLASTOutput, ">./BLASTOutput.txt" or die "$!";
      my $blastSys = "/mnt/cheng/software/ncbi-blast-2.4.0+/bin/tblastn -db $genome -query BLASTInput.txt -out BLASTOutput.txt -evalue 0.0000000001";
      system($blastSys);
      close BLASTOutput;
      my $blastIn = new Bio::SearchIO(-format => 'blast', -file   => "BLASTOutput.txt");
      while(my $result = $blastIn->next_result ){
             while (my $hit = $result->next_hit ){
                    while (my $hsp = $hit->next_hsp){
                           my $Acc = $hit->name;
                           my $obj = $db->get_Seq_by_id("$Acc");
                           my $hit_seq_length = $obj->length;
                           my $qStart = $hsp->start('query');
                           my $qEnd = $hsp->end('query');
                           my $qLength = $hsp->length('query');
                           my $sStart = $hsp->start('hit');
                           my $coding_start = $sStart;
                           my $sEnd = $hsp->end('hit');
                           my $coding_end = $sEnd;
                           my $sLength = $hit->length('hit');
                           my $qStrand = $hsp->strand('query');
                           my $sStrand = $hsp->strand('hit');
                           my $hit_sequences = $obj->seq;
                           if($qLength >= $inputSeqLength * 0.85){#make sure that the identified TE sequences contain most of the coding regions.
                              open BLAST2query, ">blast2query.txt" or die;
                              print BLAST2query ">$Acc\n$hit_sequences\n";
                              close BLAST2query;
                              open BLAST2subject, ">blast2subject.txt" or die;
                              print BLAST2subject ">$Acc\n$hit_sequences\n";
                              close BLAST2subject;
                              open BLAST2OUTPUT, ">blast2output.txt" or die;
                              my $blast2Sys = "/mnt/cheng/software/ncbi-blast-2.2.28+/bin/blastn -task blastn -subject blast2subject.txt -query blast2query.txt -out blast2output.txt";
                              system($blast2Sys);
                              close BLAST2OUTPUT;
                              my $blast2In = new Bio::SearchIO(-format => 'blast', -file  => "blast2output.txt");
                              SINE:while(my $result2 = $blast2In->next_result ){
                                         while (my $hit2 = $result2->next_hit ){
                                                while (my $hsp2 = $hit2->next_hsp){
                                                       my $Acc2 = $hit2->name;
                                                       my $qLength2 = $hsp2->length('query');
                                                       my $qStart2 = $hsp2->start('query');
                                                       my $qEnd2 = $hsp2->end('query');
                                                       my $sStart2 = $hsp2->start('hit');
                                                       my $sEnd2 = $hsp2->end('hit');
                                                       my $qStrand2 = $hsp2->strand('query');
                                                       my $sStrand2 = $hsp2->strand('hit');
                                                       my $qString2 = $hsp2->query_string('query');
                                                       my $sString2 = $hsp2->hit_string;
                                                       if($qLength2 <= 200){#To get rid of whole sequence alignment and could make sure capture all the TIRs. No TIR could be long than 200.
                                                          if(($sStrand2 eq '-1') or ($sStrand2 == -1) or ($qStrand2 eq '-1') or ($qStrand2 == -1)){#Whenever a plus/minus appear.
                                                              my @coordinates = ($qStart2,$qEnd2,$sStart2,$sEnd2);
                                                              my @sorted_coordinates = sort {$a <=> $b} @coordinates; 
                                                              if(($sorted_coordinates[1] < $coding_start) and ($sorted_coordinates[2] > $coding_end)){
                                                                  my $obj = $db->get_Seq_by_id("$Acc2");
                                                                  my $subseq = $obj->subseq($sorted_coordinates[0] => $sorted_coordinates[3]);
                                                                  print OUT ">$Acc2-$sorted_coordinates[0]\n$subseq\n";
                                                                  last SINE;
                                                              } 
                                                          }
                                                       }
                                               }
                                       }
                             }           
      
                      }
               }
         }
    }
}   
close OUT;
system("rm BLASTOutput.txt BLASTInput.txt");
print "This script has been done successfully!\n";
exit;
