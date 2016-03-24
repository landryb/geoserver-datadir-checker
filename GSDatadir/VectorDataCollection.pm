use warnings;
use strict;
use 5.010;

package GSDatadir::VectorDataCollection;
use GSDatadir::VectorData;
use Data::Dumper;

sub new {
	 my $class = shift;
	my $path = shift;
	my $self = {};
	bless ($self, $class);
	$self->{path} = $path;
	$self->{glob} = "find $path -iname *.shp";
	$self->{coll} = undef;
	return $self;
}

sub list {
	my $self = shift;
	foreach (`$self->{glob}`) {
		chomp;
		$self->{coll}{$_} = GSDatadir::VectorData->new($_);
	}
}

sub dump {
	my $self = shift;
	my @a = keys %{$self->{coll}};
	say "VectorDataCollection: path=$self->{path}, glob=$self->{glob}, ".($#a + 1)." items";
	foreach (@a) {
		say "VectorData:$_";
		$self->{coll}{$_}->dump;
	}
}

1;
