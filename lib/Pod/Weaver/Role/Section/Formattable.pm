package Pod::Weaver::Role::Section::Formattable;

# ABSTRACT: Role for a formattable section

use Moose::Role;
use namespace::autoclean;
use MooseX::AttributeShortcuts;
use MooseX::CurriedDelegation;
use MooseX::Types::Common::String ':all';
use Moose::Autobox;
use Moose::Util::TypeConstraints 'class_type';

with 'Pod::Weaver::Role::Section';

use String::Formatter;

# debugging...
#use Smart::Comments '###';

=method codes

This method returns a hashref of codes suitable to building a
L<String::Formatter> with.  For our list of codes, see OVERVIEW, below.

Sections consuming this role should consider creating a C<additional_codes>
method, as codes returned by that method will be merged in with our default
codes.  C<additional_codes> should return a list, not a hashref.

Of course, the choice is yours.

=head1 CODES

We provide the following codes:

=begin :list

* %v - distribution version

* %d - distribution name

* %p - package name

* %{mm} - "main module" name

* %{tf} - "trial flag", e.g. "-TRIAL" if trial, an empty string if not

* %t - a tab

* %n - a newline

=end :list

=cut

sub codes {
    my ($self) = @_;

    my %codes = (
        V => sub { shift->{version} },
        d => sub { shift->{zilla}->name },

        #mm => sub { shift->{zilla}->main_module },
        #tf => sub { shift->{zilla}->is_trial ? '-TRIAL' : q{} },

        n => sub { "\n" },
        t => sub { "\t" },

        p => sub { shift
            ->{ppi_document}
            ->find_first('PPI::Statement::Package')
            ->namespace
            ;
        },

        $self->additional_codes,
    );

    return \%codes;
}

sub additional_codes { () }

=attr formatter

This lazily-built attribute holds our formatter.

=method format_section $input

Return the text representing the formatted section.  This method is called
with the C<$input> taken from C<weave_section>.

=cut

sub default_formatter {
    my $self = shift @_;

    return String::Formatter->new({
        input_processor => 'require_single_input',
        string_replacer => 'method_replace',
        codes           => $self->codes,
    });
}


has formatter => (
    is      => 'ro',
    isa     => class_type('String::Formatter'),
    lazy    => 1,
    builder => 'default_formatter',
    handles => { format_section => { format => [ sub { shift->format } ] } },
);

=attr section_name

This attribute holds the section name a consuming plugin will use.

=required_method default_section_name

Generate our default section name.

This is a builder method for the C<section_name> attribute.

=cut

has section_name => (
    is      => 'ro',
    isa     => NonEmptySimpleStr,
    lazy    => 1,
    builder => 'default_section_name',
);

requires 'default_section_name';

=attr format

The string to use when generating the version string.

=required_method default_format

The default string to use as the format, when one has not been specified in
the configuration.

This is a builder method for the C<format> attribute.

=cut

has format => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => 'default_format',
);

requires 'default_format';

=method build_content($document, $input)

This method is passed the same C<$document> and C<$input> that the
C<weave_section> method is called with, and should return a list of pod
elements to insert.

In almost all cases, this method is used internally, but could be usefully
overridden in a subclass.

=cut

sub _para {
    my ($self, $content) = @_;

    return Pod::Elemental::Element::Pod5::Ordinary->new({ content => $content });
}

sub build_content {
    my ($self, $document, $input) = @_;

    # we're going to make the assumption here that we always end up with text.

    ### keys input: keys %$input
    my $text       = $self->format_section($input);
    my @paragraphs; # = ();
    my $paragraph  = q{};

    ### $text
    for my $line (split /\n/, $text) {
        
        chomp $line;
        if ($line =~ /^\s*$/) {

            ### new: $line
            ### $paragraph
            push @paragraphs, $paragraph
                unless $paragraph eq q{};
            $paragraph = q{};
        }
        else {

            ### append: $line
            $line =~ s/\s+$/ /;
            $paragraph .= "$line ";
        }
    }
    push @paragraphs, $paragraph
        unless $paragraph eq q{};

    ### @paragraphs
    return (map { $self->_para($_) } @paragraphs);
}

=method weave_section

Build our section.

=cut

sub weave_section {
    my ($self, $document, $input) = @_;

    my $nested = Pod::Elemental::Element::Nested->new({
        command  => 'head1',
        content  => $self->section_name,
        children => [ $self->build_content($document, $input) ],
    });

    ### $nested
    $document->children->push($nested);
}

!!42;
__END__

=head1 OVERVIEW

This role is consumed by sections that operate through the mechanisim of
L<String::Formatter>, namely that they take a format and input data, and
generate a top-level section from that.

=cut
