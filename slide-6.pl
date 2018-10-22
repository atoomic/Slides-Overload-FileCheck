#!perl

use Test::More;

use Overload::FileCheck '-from-stat' => \&my_stat, q{:check};

sub my_stat {
    my ( $stat_or_lstat, $file_or_fh ) = @_;

    return FALLBACK_TO_REAL_OP unless $file_or_fh && $file_or_fh eq '/any/path';

    if (   $stat_or_lstat eq 'stat'
        || $stat_or_lstat eq 'lstat' ) {

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
        } if $stat_as_hash;

        # or use one of the helper...

        return stat_as_directory() if $stat_as eq 'directory';

        if ( $stat_as eq 'use helper: with args' ) {
            return stat_as_directory( uid => 'root', gid => 0, operms => 0755 );
        }

        my $now = now();
        stat_as_file( size => 1234 ) if $stat_as eq 'file';
        stat_as_symlink( mtime => $now ) if $stat_as eq 'link';
        stat_as_socket( mtime => $now, atime => $now ) if $stat_as eq 'socket';

        # ...
    }

    return FALLBACK_TO_REAL_OP;
}

{
    $stat_as = 'file';
    #
    ok -e q[/any/path];
    ok -e q[/any/path] && -f _;
    ok -e q[/any/path] && !-d _;
    is -s _, 12345;
    my @stat = stat q[/any/path];
}

exit;
