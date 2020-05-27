#!/usr/local/bin/perl-w
#This script was used to extract innormal information from results of codeml modle 1.dS > 1.
my $usage = "perl   this_script   target_dir";
my $indir = shift or die "$usage\n";
opendir DIR, $indir or die;
my $fileNumber = 0;#File counter.
my $outNumber = 0;#Count the eligible gene number.
open OUT, ">CodemlM1ResultsdS1Genes.txt" or die;
print OUT "geneName\tBranch\n";
foreach my $file (sort readdir DIR){#read files available in the direcotrory.
        if($file =~ /(\S+)\.mlc/){#Only main results file of codeml will be analyzed.
           $fileNumber++;
           my $geneName = $1;
           my $handle = 'IN'."$fileNumber";
           open $handle, "<$indir$file" or die;
           my @eligibleBranches = ();#This array was used to hold the eligible branches.
           while(<$handle>){
                 chomp;
                 #branch          t       N       S   dN/dS      dN      dS  N*dN  S*dS
                 #20..21     0.018   393.1   116.9  0.5737  0.0052  0.0091   2.1   1.1
                 if(/^\s+\d+\.\.\d+\s+\d+\.\d+\s+\d+\.\d+/){
                     print "$_\n";
                     my @array = split /\s+/;
                     if($array[6] > 1){
                        push @eligibleBranches,$array[0];
                    }
                 }
           }
           close $handle;
           if(@eligibleBranches >= 1){
              $outNumber++;
              print OUT "$geneName\t";#You could change here to show gene names.
              my $i =0;
              foreach (@eligibleBranches){
                      print OUT "$eligibleBranches[$i]\t";
                      $i++;
              }
              print OUT "\n";
         }
      }
}
close OUT;
print "TotalGene $fileNumber\tEligibleGene $outNumber\n";
