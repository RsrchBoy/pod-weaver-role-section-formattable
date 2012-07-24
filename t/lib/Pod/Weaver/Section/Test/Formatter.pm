package Pod::Weaver::Section::Test::Formatter;

use Moose;
use namespace::autoclean;

with 'Pod::Weaver::Role::Section::Formattable';

sub default_format { 'Hi there %n, remember to eat your pears!' }

sub default_section_name { 'PEARS!' }

sub codes {
    my ($self) = @_;

    return {

        n => sub { shift->{name} },
    }
}

__PACKAGE__->meta->make_immutable;
!!42;
__END__
