#!/usr/bin/env perl
use strict;
use warnings;

use List::Util 'min';
# use Smart::Comments;
use Data::Dumper;

sub manhattan_distance {
    my $ref = shift;
    my ($x, $y) = @{$ref};

    return abs(0 - $x) + abs(0 - $y);
}

sub pedometer {
    my $ref = shift;
    my ($x, $y, $step_1, $step_2) = @{$ref};
    return $step_1 + $step_2;
}

my %directions = (
    'U' => [0, 1],
    'D' => [0,-1],
    'R' => [1, 0],
    'L' => [-1,0]
);

my $turn = 0;
my @intersections = ();
my %map;

while(<>) {
    chomp;
    my @path = split /,/;
    my @coord = (0,0); # Starting point
    my $num_steps = 0;

    if (!$turn){
        foreach my $way (@path) {
            my ($dir, $speed) = ($1, $2) if ($way =~ /(\w)(\d+)/) or die "$!";
            for (1..$speed) {
                $coord[0] += @{$directions{$dir}}[0];
                $coord[1] += @{$directions{$dir}}[1];
                $num_steps++;
                $map{"$coord[0],$coord[1]"} = $num_steps;
            }
        }
        $turn = !$turn;
    } else {
        foreach my $way (@path) {
            my ($dir, $speed) = ($1, $2) if ($way =~ /(\w)(\d+)/) or die "$!";
            for (1..$speed) {
                $coord[0] += @{$directions{$dir}}[0];
                $coord[1] += @{$directions{$dir}}[1];
                $num_steps++;
                if (exists $map{"$coord[0],$coord[1]"}) {
                    push @intersections, [@coord,$num_steps,$map{"$coord[0],$coord[1]"}];
                }
            }
        }
    }
}

# print Dumper \@intersections;
print(min(map {pedometer($_);} @intersections));


