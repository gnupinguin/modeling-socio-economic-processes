#!/usr/bin/env perl
use 5.010;
use strict;
open my $in, "Copy/SpainPopulation.txt" or die "Sorry? I can't find this file =(";

my %total;
my @data;
while (<$in>){
  @data = split/\s+/, $_;
  $total{$data[0]} += $data[3];# 0 - year, 1 - age, 2 - female, 3 - male, 4 - total
}

for my $var(1960..1974){
  say "$var\t$total{$var}"
}
