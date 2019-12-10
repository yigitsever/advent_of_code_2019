use strict;
use warnings;

my $file_name = $ARGV[0];

if (not defined $file_name) {
    die "missing filename\n";
}

open my $fh, "<", $file_name or die "Can't open $file_name, $!\n";

my %orbit;

while (<$fh>) {
    chomp;
    my ($from, $to) = split /\)/;
    push @{ $orbit{$from} }, $to;
}

close $fh;

my @to_value = ('---', 'COM');
my $dist = 0;
my $total = 0;

while ( 1 ) {

    my $cur = pop @to_value;

    print $total and exit unless @to_value;

    if ($cur eq '---') {
        unshift @to_value, '---';
        $dist++;
    } else {
        $total += $dist;
        unshift @to_value, @{ $orbit{$cur} } if exists $orbit{$cur};
    }
}
