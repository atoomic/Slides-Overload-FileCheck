#!perl

package My::Code;

sub do_something {
    return unless -e q[/any/path];

    return "This is a Dir"  if -d q[/any/path];
    return "This is a File" if -f q[/any/path];

    return "No Ideas come back later";
}

### .
package my::test::File;

use Overload::FileCheck q(:all);

mock_all_file_checks( \&dash_check );

sub dash_check {
    my ( $check, $file_or_fh ) = @_;

    return FALLBACK_TO_REAL_OP unless $check =~ qr{^[def]$};

    if ( $file_or_fh eq '/any/path' ) {
        return CHECK_IS_FALSE if $check eq 'd';
        return CHECK_IS_TRUE;
    }

    return FALLBACK_TO_REAL_OP;
}
