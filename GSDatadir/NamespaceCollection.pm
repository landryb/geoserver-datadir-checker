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
	$self->{glob} = "$path/workspaces/*/namespace.xml";
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
	my @a = keys %{$self->{coll}};
	say "NamespaceCollection: path=$self->{path}, glob=$self->{glob}, ".($#a + 1)." items";
	foreach (@a) {
		say "NS:$_";
		$self->{coll}{$_}->dump;
	}
}

1;
