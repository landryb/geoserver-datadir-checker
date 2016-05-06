use warnings;
use strict;
use 5.010;

package GSDatadir::LayergroupCollection;
use GSDatadir::Layergroup;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	my $path = shift;
	$self->{path} = $path;
	$self->{glob} = "$path/workspaces/*/layergroups/*.xml";
	$self->{coll} = undef;
	return $self;
}

sub list {
	my $self = shift;
	foreach (glob "$self->{glob}") {
		my $lg = GSDatadir::Layergroup->new($self->{gc}, $_);
		$self->{coll}{$lg->{id}} = $lg;
	}
}

sub dump {
	my $self = shift;
	my @a = keys %{$self->{coll}};
	say "LayergroupCollection: path=$self->{path}, glob=$self->{glob}, ".($#a + 1)." items";
	foreach (@a) {
		say "LG:$_";
		$self->{coll}{$_}->dump;
	}
}

1;
