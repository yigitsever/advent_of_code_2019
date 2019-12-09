use strict;
use warnings;
use Data::Dumper;
# use Smart::Comments;
use v5.10;

sub pos {
    my ($tape_ref, $index) = @_;
    my @tape = @{ $tape_ref };
    ### returning: $tape[$tape[$index]]
    ### for: $index
    return $tape[$tape[$index]];
}

sub imm {
    my ($tape_ref, $index) = @_;
    my @tape = @{ $tape_ref };
    return $tape[$index];
}

my $inputline = <STDIN>;
chomp $inputline;
my @tape = split /,/,  $inputline;

my $pc = 0; # program counter is no longer consistent

my @actions = (
    sub { print "noop" },                 # no opcode 0
    sub { return $_[0] + $_[1] },         # 1
    sub { return $_[0] * $_[1] },         # 2
    sub { return 5; },                    # 3
    sub { say $_[0]; },                   # 4
    sub { return $_[0] ? $_[1] : -1 },    # 5, ugh, you might want to jump to 0
    sub { return $_[0] ? -1 : $_[1] },    # 6
    sub { return $_[0] < $_[1] ? 1 : 0},  # 7
    sub { return $_[0] == $_[1] ? 1 : 0}, # 8
);

my @modes = (\&pos, \&imm);
my %offsets = qw/1 4 2 4 3 2 4 2 5 3 6 3 7 4 8 4 99 1/;
my $inst_ptr = 0;

while ( 1 ) {

    my $raw_op_code = $tape[$inst_ptr];
    last if ($raw_op_code == 99);

    # print("====================================\n");

    my @modes_and_opcode;
    push @modes_and_opcode, $_ // 0 for $raw_op_code =~ m/^(\d)??(\d)??(\d)??0?(\d)$/g;
    ### @modes_and_opcode

    my $op_code = pop @modes_and_opcode;
    ### $op_code

    # foreach my $x (0..5) {
    #     print("TAPE[" . ($inst_ptr + $x) . "] = $tape[($inst_ptr + $x)]\n")
    # }

    my $toread = $offsets{$op_code} - 1; # excluding opcode
    my @params;
    foreach my $offset (1..$toread) {
        push @params, $modes[ (!($op_code == 4 || $op_code == 5 || $op_code == 6) && $offset == $toread) ? 1 : pop @modes_and_opcode ]->(\@tape, $inst_ptr + $offset);
    }
    ### @params

    $inst_ptr += $offsets{$op_code};

    if ($op_code == 1 || $op_code == 2 || $op_code == 7 || $op_code == 8) { # arithmetic
        my $res = $actions[$op_code]->($params[0], $params[1]);
        $tape[$params[2]] = $res;
        ### writing: $res
        ### on address: $params[2]
    }
    elsif ($op_code == 3) { # input
        my $res = $actions[$op_code]->();
        $tape[$params[0]] = $res;
        ### saved: $res
        ### on: $params[0]
    } elsif ($op_code == 4) { # output
        $actions[$op_code]->($params[0]);
    } elsif ($op_code == 5 || $op_code == 6) { # jumps
        my $res = $actions[$op_code]->($params[0], $params[1]);
        $inst_ptr = $res == -1 ? $inst_ptr : $res;
        ### jumped to: $inst_ptr
        next;
    } else {
        ### OH NO...
        die;
    }
}
