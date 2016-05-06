use warnings;
use strict;
use 5.010;

package GSDatadir::FeaturetypeCollection;
use GSDatadir::Featuretype;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	my $path = shift;
	$self->{path} = $path;
	$self->{glob} = "$path/workspaces/*/*/*/featuretype.xml";
	$self->{coll} = undef;
	return $self;
}

sub list {
	my $self = shift;
	foreach (glob "$self->{glob}") {
		my $ft = GSDatadir::Featuretype->new($self->{gc}, $_);
		$self->{coll}{$ft->{id}} = $ft;
	}
}

sub dump {
	my $self = shift;
	my @a = keys %{$self->{coll}};
	say "FeaturetypeCollection: path=$self->{path}, glob=$self->{glob}, ".($#a + 1)." items";
	foreach (@a) {
		say "FT:$_";
		$self->{coll}{$_}->dump;
	}
}

1;
