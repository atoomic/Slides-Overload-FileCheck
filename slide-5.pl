#!perl

use Test2::Bundle::Extended;
use Test2::Tools::Explain;

use Overload::FileCheck q(:all);

use constant MY_CUSTOM_PATH => '/my/custom/path';

my $stat_as;    # ...

mock_stat( \&my_stat );

{
    $stat_as = 'file';
    note explain [ stat MY_CUSTOM_PATH ];
}

{
    $stat_as = 'directory';
    note explain [ stat MY_CUSTOM_PATH ];
}

{
    $stat_as = 'array';
    note explain [ stat MY_CUSTOM_PATH ];
}

{
    $stat_as = 'hash';
    note explain [ stat MY_CUSTOM_PATH ];
}

{
    $stat_as = 'directory with args';
    note explain [ stat MY_CUSTOM_PATH ];
}

pass and done_testing;

sub my_stat {
    my ( $stat_or_lstat, $file_or_fh ) = @_;

    return FALLBACK_TO_REAL_OP unless $file_or_fh && $file_or_fh eq MY_CUSTOM_PATH;

    if (   $stat_or_lstat eq 'stat'
        || $stat_or_lstat eq 'lstat' ) {

        note "... running stat with stat_as eq '$stat_as'";

        return [ 1 .. 13 ] if $stat_as eq 'array';
        return {
            st_dev     => 1,
            st_ino     => 2,
            st_mode    => 3,
            st_nlink   => 4,
            st_uid     => 5,
            st_gid     => 6,
            st_rdev    => 7,
            st_size    => 8,
            st_atime   => 9,
            st_mtime   => 10,
            st_ctime   => 11,
            st_blksize => 12,
            st_blocks  => 13,
        } if $stat_as eq 'hash';

        # or use one of the helper...

        return stat_as_directory() if $stat_as eq 'directory';

        if ( $stat_as eq 'directory with args' ) {
            return stat_as_directory( uid => 'root', gid => 4_243, mtime => 123_456 );
        }

        my $now = time();

        return stat_as_file() if $stat_as eq 'file';
        return stat_as_symlink( mtime => $now ) if $stat_as eq 'link';
        return stat_as_socket( mtime => $now, atime => $now ) if $stat_as eq 'socket';
        # ...
    }

    return FALLBACK_TO_REAL_OP;
}