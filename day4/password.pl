use strict;
use warnings;

use Data::Dumper;

my $low_bound = 353096;
my $upper_bound = 843212;

my $count = 0;

for (my $number = $low_bound; $number < $upper_bound; $number++) {
    my @nums = split //, $number;
    my @cmp = sort {$a <=> $b} @nums;
    if (@nums == @cmp and join ("\0", @nums) eq join ("\0", @cmp)) {
        my %digits = ();
        foreach (@nums) {
            $digits{$_}++;
        }
        foreach my $reps (values %digits) {
            if ($reps == 2) {
                print "$number\n";
                $count++;
                last;
            }
        }
    }
}

print ">$count\n";
