use warnings;
use strict;
use 5.010;

package GSDatadir::DatastoreCollection;
use GSDatadir::Datastore;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	my $path = shift;
	$self->{path} = $path;
	$self->{glob} = "$path/workspaces/*/*/datastore.xml";
	$self->{coll} = undef;
	return $self;
}

sub list {
	my $self = shift;
	foreach (glob "$self->{glob}") {
		my $ws = GSDatadir::Datastore->new($self->{gc}, $_);
		$self->{coll}{$ws->{id}} = $ws;
	}
}

sub dump {
	my $self = shift;
	my @a = keys %{$self->{coll}};
	say "DatastoreCollection: path=$self->{path}, glob=$self->{glob}, ".($#a + 1)." items";
	foreach (@a) {
		say "DS:$_";
		$self->{coll}{$_}->dump;
	}
}

sub look_for_connurl {
	my $self = shift;
	my $url = shift;
	my @res = grep { $self->{coll}{$_}->{connurl} eq $url } keys %{$self->{coll}};
	return @res;
}
1;
