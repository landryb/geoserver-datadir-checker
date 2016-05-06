use warnings;
use strict;
use 5.010;

package GSDatadir::VectorDataCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::VectorData;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args, "VectorData");
	$self->{glob} = "find ".$self->{path}." -iname *.shp";
	return $self;
}

sub list {
	my $self = shift;
	foreach (`$self->{glob}`) {
		chomp;
		$self->{coll}{$_} = GSDatadir::VectorData->new($self->{gc}, $_);
	}
}

1;
