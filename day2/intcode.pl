use strict;
use warnings;
use Data::Dumper;
# use Smart::Comments;

my $inputline = <STDIN>;
chomp $inputline;
my @memory = split /,/,  $inputline;

@memory = map {int $_} @memory;

my $op_code_pos = 0;
my $pos_1 = 1;
my $pos_2 = 2;
my $loc_pos = 3;
my $pc = 4;

my @actions = (sub {print "noop"}, sub {return $_[0] + $_[1]}, sub {return $_[0] * $_[1]});

my $output = 0;

my $one_inc = 0;
my $two_inc = 0;
my $turn = 0;
my @mem = @memory;

foreach my $x (0..99) {
    foreach my $y (0..99) {

        @mem = @memory;
        $mem[1] = $x;
        $mem[2] = $y;

        for (my $add = 0; $add < scalar @mem; $add += $pc) {

            my $op_code = $mem[$add + $op_code_pos];
            last if ($op_code == 99);

            my $op_1 = $mem[$mem[$add + $pos_1]];
            my $op_2 = $mem[$mem[$add + $pos_2]];
            my $loc = $mem[$add + $loc_pos];
            my $res = $actions[$op_code]->($op_1, $op_2);

            $mem[$loc] = $res;
        }
        $output = $mem[0];
        ### $output
        exit if $output == 19690720;
    }
}

# print Dumper \@mem;
# print join ',', @mem;
END {
    print STDERR "Output: >$mem[0]<\nFor mem[1] = $mem[1] and mem[2] = $mem[2]\n";
    print 100 * $mem[1] + $mem[2];
}
