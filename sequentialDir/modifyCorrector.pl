#!/usr/bin/env perl
######################################################################
sub usage {
  print "Usage: modifyCorrector.pl origLattice.lte newLattice.lte corrName newStrength\n";
  exit(0);
}

usage if ($#ARGV!=3);

my ($orig,$new,$corrName,$str)=@ARGV;

open my $IN, "<$orig" or die "Couldn't open $orig for reading: $!\n";
open my $OUT, ">$new" or die "Couldn't open $new for writing: $!\n";
my $foundCorr=0;
my $setKick=0;
while (<$IN>) {
  chomp;
  if (/^$corrName:/) { $foundCorr=1; print "found corr: $_\n"; }
  if ($foundCorr && !$setKick) {
    if (/KICK=/) {
      s/KICK=[^,]+,/KICK=$str,/;
      $setKick=1;
      print "set kick: $_\n";
    }
  }
  print $OUT "$_\n";
}
close $IN or die "Couldn't close $orig for reading: $!\n";
close $OUT or die "Couldn't close $new for writing: $!\n";
