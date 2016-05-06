use warnings;
use strict;
use 5.010;

package GSDatadir::VectorDataCollection;
use GSDatadir::VectorData;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	my $path = shift;
	$self->{path} = $path;
	$self->{glob} = "find $path -iname *.shp";
	$self->{coll} = undef;
	return $self;
}

sub list {
	my $self = shift;
	foreach (`$self->{glob}`) {
		chomp;
		$self->{coll}{$_} = GSDatadir::VectorData->new($self->{gc}, $_);
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

sub check {
	my $self = shift;
	my @err = ();
	foreach (keys %{$self->{coll}}) {
		if ($self->{coll}{$_}->check < 0) {
			push @err, $_;
			say "VD $_ has an issue";
		}
	}
}
1;
