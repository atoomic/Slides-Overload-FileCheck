#!perl

package my::test::File;

use Test2::Bundle::Extended;

# load it before your code
use Overload::FileCheck q(:all);

is My::Code::do_something(), undef, "-e is unmocked";

mock_file_check(
    '-e' => sub {
        my ($file_or_fh) = @_;
        return CHECK_IS_TRUE if $file_or_fh eq '/any/path';
        return FALLBACK_TO_REAL_OP;
    }
);

is My::Code::do_something(), "Something", "-e is now mocked";

unmock_file_check('-e');
is My::Code::do_something(), undef, "-e is unmocked";

done_testing;
exit;

# ------------------------------------------------------------

package My::Code;

sub do_something {
    return unless -e q[/any/path];

    return "Something";
}
