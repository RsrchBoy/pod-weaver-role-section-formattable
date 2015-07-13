use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

# List our own version used to generate this
my $v = "\nGenerated by Dist::Zilla::Plugin::ReportVersions::Tiny v1.12\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = '5.006';
    $v .= "perl: $] (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    (my $file = "$module.pm") =~ s{::}{/}g;
    $wanted = " (want $wanted)";
    my $pmver;
    eval { require $file };
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('ExtUtils::MakeMaker','any version') };
eval { $v .= pmver('File::Spec','any version') };
eval { $v .= pmver('IO::Handle','any version') };
eval { $v .= pmver('IPC::Open3','any version') };
eval { $v .= pmver('Moose','any version') };
eval { $v .= pmver('Moose::Autobox','0.10') };
eval { $v .= pmver('Moose::Role','any version') };
eval { $v .= pmver('Moose::Util::TypeConstraints','any version') };
eval { $v .= pmver('MooseX::AttributeShortcuts','any version') };
eval { $v .= pmver('MooseX::CurriedDelegation','any version') };
eval { $v .= pmver('MooseX::Types::Common::String','any version') };
eval { $v .= pmver('PPI','any version') };
eval { $v .= pmver('Pod::Elemental','any version') };
eval { $v .= pmver('Pod::Elemental::Selectors','any version') };
eval { $v .= pmver('Pod::Elemental::Transformer::Nester','any version') };
eval { $v .= pmver('Pod::Elemental::Transformer::Pod5','any version') };
eval { $v .= pmver('Pod::Weaver','any version') };
eval { $v .= pmver('Pod::Weaver::Role::Section','any version') };
eval { $v .= pmver('String::Formatter','any version') };
eval { $v .= pmver('Test::CheckDeps','0.010') };
eval { $v .= pmver('Test::Differences','any version') };
eval { $v .= pmver('Test::More','0.94') };
eval { $v .= pmver('lib','any version') };
eval { $v .= pmver('namespace::autoclean','any version') };
eval { $v .= pmver('strict','any version') };
eval { $v .= pmver('warnings','any version') };


# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve your problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;