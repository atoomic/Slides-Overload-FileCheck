#!perl

use Test2::Bundle::Extended;
use Test2::Tools::Explain;

use Overload::FileCheck '-from-stat' => \&my_stat, q{:all};

=pod

use Overload::FileCheck q{:all};
mock_all_from_stat( \&my_stat );

=cut

use constant MY_CUSTOM_PATH => '/my/custom/path';

my $stat_as;

{
    $stat_as = 'null file';
    #
    ok -e MY_CUSTOM_PATH;
    ok -e MY_CUSTOM_PATH && -f _;
    ok -e MY_CUSTOM_PATH && !-d _;
    is -s _, 0, "-s file is null";
    ok -z _, "-z file is null";
}

{
    $stat_as = 'file not null';
    #
    ok -e MY_CUSTOM_PATH;
    ok -e MY_CUSTOM_PATH && -f _;
    ok -e MY_CUSTOM_PATH && !-d _;
    is -s _, 98765, "-s file is 98765";
    ok !-z _, "-z file is not null";
}

pass and done_testing;

sub my_stat {
    my ( $stat_or_lstat, $file_or_fh ) = @_;

    return FALLBACK_TO_REAL_OP unless $file_or_fh && $file_or_fh eq MY_CUSTOM_PATH;

    if (   $stat_or_lstat eq 'stat'
        || $stat_or_lstat eq 'lstat' ) {

        note "... running stat with stat_as eq '$stat_as'";

        return stat_as_file() if $stat_as eq 'null file';        
        return stat_as_file( size => 98765 ) if $stat_as eq 'file not null';
    }

    return FALLBACK_TO_REAL_OP;
}