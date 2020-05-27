#!/usr/local/bin/perl-w
#This script was used to rank the RepeatMasker output (.out file).
my $usage = "perl   this-script    rmsk_output";
my $input = shift or die "$usage\n";
my %peaks = ();#This hash was used to hold all the rmsk items.
open IN, "<$input" or die;
open OUT, ">$input.ranked.txt" or die;
while(<IN>){
      chomp;
      s/^\s+//;#Delete blanks for each item to make the beginning of each line is data.
      if(/^\d+/){
         my @tem = split /\s+/;
         $peaks{$tem[4]} .= "$_".'SEPERATE';
      }
}
close IN;
foreach my $chromosoma (keys %peaks){
        my @chrPeaks = split /SEPERATE/,$peaks{$chromosoma};
        my %startPoint_peak = ();#This hash was used to hold peak information based on its start point.
        foreach my $peak_item (@chrPeaks){
                my @tem = split /\s+/,$peak_item;
                if(exists $startPoint_peak{$tem[5]}){
                   my $newKey = $tem[5] + 1;
                   $startPoint_peak{$newKey} = $peak_item;
                }
                else {
                   $startPoint_peak{$tem[5]} = $peak_item;
                }
        }
        foreach my $start_point (sort {$a <=> $b} (keys %startPoint_peak)){
                print OUT "$startPoint_peak{$start_point}\n";
       }       
}
close OUT;
