use warnings;
use strict;
use 5.010;

package GSDatadir::NamespaceCollection;
use GSDatadir::Namespace;
use Data::Dumper;

sub new {
	 my $class = shift;
	my $path = shift;
	my $self = {};
	bless ($self, $class);
	$self->{path} = $path;
	$self->{glob} = "$path/namespaces/*/namespace.xml";
	$self->{coll} = undef;
	return $self;
}

sub list {
	my $self = shift;
	foreach (glob "$self->{glob}") {
		my $ws = GSDatadir::Namespace->new($_);
		$self->{coll}{$ws->{id}} = $ws;
	}
}

sub dump {
	my $self = shift;
	say "NamespaceCollection: path=$self->{path}, glob=$self->{glob}";
	foreach (keys %{$self->{coll}}) {
		say "NS:$_";
		$self->{coll}{$_}->dump;
	}
}

1;
