#!perl

use Test2::Bundle::Extended;

use Overload::FileCheck q(:all);

mock_all_file_checks( \&dash_check );

ok ! -x '/some/binary',    "-x fails";
ok ! -d '/some/directory', "-d fails";
ok ! -e '/some/path',      "-e fails";

ok -e '/my/custom/path', "/my/custom/path exists";
ok -f '/my/custom/path', "/my/custom/path is a file";
ok ! -d '/my/custom/path', "/my/custom/path is not a directory";

done_testing;

sub dash_check {
    my ( $check, $file_or_fh ) = @_;

    note "... checking -", $check, " ", $file_or_fh;

    return FALLBACK_TO_REAL_OP unless $check =~ qr{^[def]$};

    if ( $file_or_fh eq '/my/custom/path' ) {
        return CHECK_IS_FALSE if $check eq 'd';
        return CHECK_IS_TRUE;
    }

    return FALLBACK_TO_REAL_OP;
}
