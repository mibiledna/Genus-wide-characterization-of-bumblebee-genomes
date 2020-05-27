#!/usr/local/bin/perl-w
#This script was used to needle the original RepeatMasker file to extend overlapped mask results to its longest.
my $usage = "perl    this_scipt    RMSKoutputFile";
my $input = shift or die "$usage\n";
open IN, "<$input" or die;
open OUT, ">$input.needled.txt";
my $chr = '';
my $TEtype = '';
my $start = 0; #A number that smaller than any random start.
my $end = 100000000;#A number that larger than any random end.
my $last_item = 'NULL';
LINE:while(<IN>){
      chomp;
      if(/^\d+/){
         my @arrayNew = split /\s+/;
         if(($arrayNew[4] eq $chr) and ($arrayNew[10] eq $TEtype)){#change here!!!
             if($arrayNew[5] > $end + 30){#The start site longer than the end site means no overlap any more. To decrease over-fragmented TEs, here we allow 30 bp of mismatch.
                my @array = split /\s+/, $last_item;
                print OUT "$array[4]\t$start\t$end\t$array[8]\t$array[9]\t$array[10]\n";
                $chr = $arrayNew[4];
                $TEtype = $arrayNew[10];
                $start = $arrayNew[5];
                $end = $arrayNew[6];
                $last_item = $_;
             }
             else {
                my @numbers = sort {$a <=> $b} ($arrayNew[5],$arrayNew[6],$start,$end);
                $chr = $arrayNew[4];
                $TEtype = $arrayNew[10];
                $start = $numbers[0];
                $end = $numbers[3];
                $last_item = $_;
            }
        }
        elsif(($start ==  0) and ($chr eq '')){
                $chr = $arrayNew[4];
                $TEtype = $arrayNew[10];
                $start = $arrayNew[5];
                $end = $arrayNew[6];
                $last_item = $_;
        }
        elsif(($arrayNew[4] ne $chr) or ($arrayNew[10] ne $TEtype)){
                 my @array = split /\s+/, $last_item;
                 print OUT "$array[4]\t$start\t$end\t$array[8]\t$array[9]\t$array[10]\n";
                 $chr = $arrayNew[4];
                 $TEtype = $arrayNew[10];
                 $start = $arrayNew[5];
                 $end = $arrayNew[6];
                 $last_item = $_;
       }
   } 
} 
print OUT "$chr\t$start\t$end\tStrand\tRepeatName\t$TEtype\n";#As the last item could not trigger the above conditions so we need to print them out when the circles were completed.
close OUT;
