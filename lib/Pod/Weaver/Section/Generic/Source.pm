package Pod::Weaver::Section::Generic::Source;

# ABSTRACT: A generic, formattable SOURCE section

use Moose;
use namespace::autoclean;
use MooseX::AttributeShortcuts;

with 'Pod::Weaver::Role::Section::Formattable';

sub default_section_name { 'SOURCE' }

sub default_format {

'The development source for %d is publicly accessible.
A web interface at %{web}R and the repository itself is
accessible through %{type}R at:

%{url}R

Patches and pull requests are quite welcome!
'

 }

sub additional_codes {
    my ($self) = @_;

    my $_r = sub { shift->{distmeta}->{resources}->{repository} };

    return (
        # repository url
        #r => sub { 'repo' },
        # issue tracker url
        i => sub { shift->{distmeta}->{resources}->{bugtracker}->{web} },
        #vcs_url => sub { shift->{distmeta}->{resources}->{}->{web} },
        #R => sub { $_r->(shift)->{shift} },
        X => sub { 'ARGH' },
        R => sub { #shift->{distmeta}->{resources}->{repository}->{shift} },
            # ## @_
            ### $_[0]->{distmeta}
            ### $_[1]
            $_r->(shift)->{shift}; },
        #R => sub { $_r->(shift)->{shift} },
        #vcs_type => sub { $_r->(shift)->{type} },
        #vcs_web  => sub { $_r->(shift)->{web}  },
        #vcs_url  => sub { $_r->(shift)->{url}  },
    );
}

__PACKAGE__->meta->make_immutable;
!!42;
__END__
