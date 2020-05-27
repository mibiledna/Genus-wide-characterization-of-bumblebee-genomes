#!/usr/bin/perl
# USAGE: perl 
# unix command line: perl parseOUTcodemlResult.pl *mlc
use strict;
use warnings;
my $input_file;
my $geneName; 

my $output_file = "results.txt"; #change the output file name here
open (OUT, ">", $output_file);
print OUT "geneName\tdN/dS\n";

my $indicator = 0;#This varial was used to indicate if one cluster has estimated dN/dS value.
for $input_file (@ARGV) {
    $geneName = $input_file;
    $geneName =~ s/\.fas\.mlc//;#change the expression pattern here 
    process_file($input_file, $geneName);
    if($indicator ne 10){#means this file does not have omega value.
       print "Redo $input_file\n";
    }
}

sub process_file {
    my ($input_file, $geneName) = @_;
    open (IN, "<", $input_file) or die "Can't open '$input_file': $!";
    while (my $line=<IN>) { 
          $line =~ s/^\s+//g; 
          if ($line=~m/^omega/) {  #change the expression here when the tree changes
              print OUT "$geneName\t$line"; } #if	 
              $indicator = 10;
	  } #while
close IN;
} #sub
close OUT;

