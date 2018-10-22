#!perl

package My::Code;

sub do_something {
    return unless -e q[/any/path];

    return "Something";
}

### .
package my::test::File;

use Overload::FileCheck q(:all);

mock_file_check(
    '-e' => sub {
        my ($file_or_fh) = @_;

        return CHECK_IS_TRUE if $file_or_fh eq '/any/path';
        return FALLBACK_TO_REAL_OP;
    }
);

