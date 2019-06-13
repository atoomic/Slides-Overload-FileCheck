#!perl

use Test2::Bundle::Extended;

use Overload::FileCheck q(:all);

ok ! -e '/any/path';
ok ! -d '/any/path';
ok ! -f '/any/path';

mock_file_check( '-e' => \&dash_check );

ok -e '/any/path';
ok ! -d '/any/path';
ok ! -f '/any/path';

mock_file_check( '-d' => \&dash_check );

ok -e '/any/path';
ok -d '/any/path';
ok ! -f '/any/path';

mock_file_check( '-f' => \&dash_check );

ok -e '/any/path';
ok -d '/any/path';
ok -f '/any/path';

sub dash_check {
    my ($file_or_fh) = @_;

    return CHECK_IS_TRUE if $file_or_fh eq '/any/path';
    return FALLBACK_TO_REAL_OP;
}

done_testing;
