package Pod::Weaver::Section::Generic::Bugs;

# ABSTRACT: A generic, formattable BUGS section

use Moose;
use namespace::autoclean;
use MooseX::AttributeShortcuts;

with 'Pod::Weaver::Role::Section::Formattable';

sub default_section_name { 'BUGS' }

sub default_format {

'All complex software has bugs lurking in it, and this module is no exception.

Please report any bugs to the issue tracker at %i.  Better yet, fork the
repository (details in the SOURCE section), and submit a patch (pull request,
even better) or test case that demonstrates the bug or feature desired.

For other issues, or commercial enhancement or support, contact the author.
'

 }

sub additional_codes {
    my ($self) = @_;

    return (
        # repository url
        r => sub { 'repo' },
        # issue tracker url
        i => sub { shift->{distmeta}->{resources}->{bugtracker}->{web} },
        # version
        #v => sub { shift->{version} },
    );
}

__PACKAGE__->meta->make_immutable;
!!42;
__END__
