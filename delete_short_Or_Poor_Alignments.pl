#!/usr/bin/perl
use warnings;
#This scrpt was used to delete files that do not have all the species and sequences do not have enouch length or too much Ns in the current working folder.
my $usage = "perl   this_script   target_dir";
my $indir = shift or die "$usage\n";
opendir DIR, $indir or die "Cannot open $indir: $!";
my $filenumber = 0;
my $deleted_number = 0;
foreach my $file (sort readdir DIR){#read files available in the direcotrory.
        if($file =~ /gb$/){
           $filenumber++;
           my $filehandle = 'IN'."$filenumber";
           open $filehandle, "<$indir/$file" or die;
           my $SeqName = '';
           my %sequences = ();
           while(<$filehandle>){
                 chomp;
                 if(/^>/){
                   $SeqName = $_;
                 }
                 else {
                   $sequences{$SeqName} .= $_;
                }
          }
          my $indicator = 0;
          foreach my $temname (keys %sequences){
                  my $seqLength = length ($sequences{$temname});
                  my $n_count = ($sequences{$temname} =~ tr/N/N/);
                  if (($seqLength >= 150) and ($n_count/$seqLength < 0.2)){
                       $indicator++;
                  }
          }
          if($indicator < 19){#Here to define how many species do you need.
             system ("rm $indir/$file");
             $deleted_number++;
          }
          close $filehandle;
        }
}
print "Total file number $filenumber\nDeleted number $deleted_number\n";
