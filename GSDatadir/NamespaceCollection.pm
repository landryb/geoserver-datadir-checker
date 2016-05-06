use warnings;
use strict;
use 5.010;

package GSDatadir::NamespaceCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::Namespace;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args, "Namespace");
	$self->{glob} = "$self->{path}/workspaces/*/namespace.xml";
	return $self;
}

1;
