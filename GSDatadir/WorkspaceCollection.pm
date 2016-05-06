use warnings;
use strict;
use 5.010;

package GSDatadir::WorkspaceCollection;
use GSDatadir::Workspace;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	my $path = shift;
	$self->{path} = $path;
	$self->{glob} = "$path/workspaces/*/workspace.xml";
	$self->{coll} = undef;
	return $self;
}

sub list {
	my $self = shift;
	foreach (glob "$self->{glob}") {
		my $ws = GSDatadir::Workspace->new($self->{gc}, $_);
		$self->{coll}{$ws->{id}} = $ws;
	}
}

sub dump {
	my $self = shift;
	my @a = keys %{$self->{coll}};
	say "WorkspaceCollection: path=$self->{path}, glob=$self->{glob}, ".($#a + 1)." items";
	foreach (@a) {
		say "WS:$_";
		$self->{coll}{$_}->dump;
	}
}

1;
