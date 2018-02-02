#!/usr/bin/env perl
######################################################################
sub usage {
  print "Usage: modifyQuad.pl origLattice.lte newLattice.lte quadName newStrength\n";
  exit(0);
}

usage if ($#ARGV!=3);

my ($orig,$new,$quadName,$str)=@ARGV;

open my $IN, "<$orig" or die "Couldn't open $orig for reading: $!\n";
open my $OUT, ">$new" or die "Couldn't open $new for writing: $!\n";
my $foundQuad=0;
my $setKick=0;
while (<$IN>) {
  chomp;
  if (/^$quadName:/) { $foundQuad=1; print "found Quad: $_\n"; }
  if ($foundQuad && !$setKick) {
    if (/K1=/) {
      s/K1=[^,]+,/K1=$str,/;
      $setKick=1;
      print "set k1: $_\n";
    }
  }
  print $OUT "$_\n";
}
close $IN or die "Couldn't close $orig for reading: $!\n";
close $OUT or die "Couldn't close $new for writing: $!\n";
