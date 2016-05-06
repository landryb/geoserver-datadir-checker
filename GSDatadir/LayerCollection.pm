use warnings;
use strict;
use 5.010;

package GSDatadir::LayerCollection;
use GSDatadir::Layer;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	my $path = shift;
	$self->{path} = $path;
	$self->{glob} = "$path/workspaces/*/*/*/layer.xml";
	$self->{coll} = undef;
	return $self;
}

sub list {
	my $self = shift;
	foreach (glob "$self->{glob}") {
		my $lyr = GSDatadir::Layer->new($self->{gc}, $_);
		$self->{coll}{$lyr->{id}} = $lyr;
	}
}

sub dump {
	my $self = shift;
	my @a = keys %{$self->{coll}};
	say "LayerCollection: path=$self->{path}, glob=$self->{glob}, ".($#a + 1)." items";
	foreach (@a) {
		say "LYR:$_";
		$self->{coll}{$_}->dump;
	}
}

1;
