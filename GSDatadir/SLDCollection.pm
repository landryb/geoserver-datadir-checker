use warnings;
use strict;
use 5.010;

package GSDatadir::SLDCollection;
use GSDatadir::SLD;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	my $path = shift;
	$self->{path} = $path;
	$self->{glob} = "$path/{workspaces/*/,}styles/*.sld";
	$self->{coll} = undef;
	return $self;
}

sub list {
	my $self = shift;
	foreach (glob "$self->{glob}") {
		$self->{coll}{$_} = GSDatadir::SLD->new($self->{gc}, $_);
	}
}

sub dump {
	my $self = shift;
	my @a = keys %{$self->{coll}};
	say "SLDCollection: path=$self->{path}, glob=$self->{glob}, ".($#a + 1)." items";
	foreach (@a) {
		say "SLD:$_";
		$self->{coll}{$_}->dump;
	}
}

1;
