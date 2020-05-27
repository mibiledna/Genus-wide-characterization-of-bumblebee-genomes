#!/usr/local/bin/perl-w
use strict;
#This script was used to summarize the number of TEs within exon/CDS, intron and 1kb upstream or downstream of its nearest genes.
my $usage = "perl  this_script.pl  Gene_annotation_gff_file  RepeatMakser.outFile";
my $gff = shift or die "$usage\n";
my $TE = shift or die "$usage\n";#This file contains the coordinates of identified TEs. 
my %gene = ();#This hash was used to keep gene coordinates.
my %exon = ();#This hash was used to keep exon/CDS coordinates.
open GFF, "<$gff" or die;
my $gene_name = '';
while(<GFF>){
      chomp;
      #NC_015762.1     Gnomon  gene    2279    18548   .       - ;Name=LOC105680230; 
      #NT_176422.1     Gnomon  exon    4011    4212    .       + 
      #flattened_line_1059-0   maker   gene    16152   16448
      #flattened_line_1059-0   maker   exon    16152   16258   .       + ID=B.breviceps0000020-mRNA-1
      if(/^(\S+)\s+\S+\s+gene\s+(\d+)\s+(\d+).+;Name=([^;]+);/){
         my $tem_string = "$2".'COOR'."$3".'COOR'."$4";#Each $tem_string contains info for each gene.
         $gene_name = $4;
         $gene{$1} .= "$tem_string".'SEPRATE';
      }
      if(/^(\S+)\s+\S+\s+CDS\s+(\d+)\s+(\d+).+ID=$gene_name/){#Here you could match CDS or exon.
         my $tem_string = "$2".'COOR'."$3";##Each $tem_string contains info for the CDS/exons of each gene.
         $exon{$gene_name} .= "$tem_string".'SEPRATE';
      }
}
close GFF;
open TE, "<$TE" or die;
my $in_intron = 0;#Total number of TEs in introns.
my $in_exon = 0;#Total number of TEs in exons/CDSs.
my $in_promoter = 0;#Total number of TEs in promoters.
open OUT, ">$TE.potentialFunctional.txt" or die;
print OUT "CoordinatesOfTEs\tPositionOfGene\tAssociatedGene\n";
my %TEcoordinates = ();
my $totalTEnumber = 0;
while(<TE>){#Depends on the format of RMSK output, please change here correspondingly.
      chomp;
      #scaffold_2298_uid_1510577946    2       1715    C       B.pic73 LTR/TRIM
      if(!/Simple_repeat|Low_complexity|OOORRR|SSR|PotentialHostGene/){
          my @tem = split /\s+/;
          $totalTEnumber++;
          my $temkey = "$tem[0]-$tem[1]-$tem[2]";
          $TEcoordinates{$temkey} = 1;#Get rid of redundancy in the RMSK out file.
       }
}
close TE;
foreach (keys %TEcoordinates){#Take one TE at a time.
      my ($chromosome, $start, $stop) = split /-/;#Get its coordinate.
      foreach my $chr (keys %gene){#Extract one chromosome at a time.
              if($chromosome eq $chr){#If chromosome number is the same.
                 my @coordinates = split /SEPRATE/, $gene{$chr};#@coordinates contains the coordinates and names for genes on each chromosome.
                 SINE:foreach my $coor (@coordinates){#Take one gene at a time.
                            my @position = split /COOR/,$coor;#Conain start, end, and gene name info for each gene.
                            if(($start >= $position[0]) and ($stop <= $position[1])){                                
                                my @exon_coordinates = split /SEPRATE/, $exon{$position[2]};#Get the exons for each gene.
                                my $indicator = 0;#To check if one TE has been found in one exon.
                                foreach my $exon_coor (@exon_coordinates){
                                        my @exon_position = split /COOR/,$exon_coor;
                                        if(($start >= $exon_position[0]) and ($start <= $exon_position[1])){
                                            if(($start - $exon_position[0] >= 50) or ($exon_position[1] - $start >= 50)){#At least 50 bp of overlap.
                                                $in_exon++;
                                                $indicator++;
                                                print OUT "$chromosome:$start-$stop\tCDS\t$position[2]\n";
                                                last SINE;
                                            }
                                        }
                                        elsif(($stop >= $exon_position[0]) and ($stop <= $exon_position[1])){
                                               if(($stop - $exon_position[0] >= 50) or ($exon_position[1] - $stop >= 50)){#At least 50 bp of overlap.
                                                   $in_exon++;
                                                   $indicator++;
                                                   print OUT "$chromosome:$start-$stop\tCDS\t$position[2]\n";
                                                   last SINE;
                                               }
                                        }
                               }
                               if($indicator == 0){
                                  $in_intron++;
                                  print OUT "$chromosome:$start-$stop\tIntron\t$position[2]\n";
                                  last SINE;
                               }      
                         }
                         elsif(($stop < $position[0]) and ($position[0]-$stop <= 950)){#at least 50 bp is within 1kb upstream.
                                $in_promoter++;
                                print OUT "$chromosome:$start-$stop\t1Kb2CDS\t$position[2]\n";
                                last SINE;
                        }
                        elsif(($start > $position[1]) and ($start-$position[1] <= 950)){#at least 50 bp is within 1kb downsteam.
                               $in_promoter++;
                               print OUT "$chromosome:$start-$stop\t1Kb2CDS\t$position[2]\n";
                               last SINE;
                       }
                 }
        }
      }
}
close TE;
#print "Exon\t$in_exon\tIntron\t$in_intron\t1Kb2Exon\t$in_promoter\tTotalTEnumber\t$totalTEnumber\n";
print "$in_exon\t$in_intron\t$in_promoter\t$totalTEnumber\n";
