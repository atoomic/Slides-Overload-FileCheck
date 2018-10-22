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

mock_file_check( '-e' => \&dash_check );
mock_file_check( '-d' => \&dash_check );
mock_file_check( '-f' => \&dash_check );

sub dash_check {
    my ($file_or_fh) = @_;

    return CHECK_IS_TRUE if $file_or_fh eq '/any/path';
    return FALLBACK_TO_REAL_OP;
}
