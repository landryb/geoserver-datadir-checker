use warnings;
use strict;
use 5.010;

package GSDatadir::MetadataCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::Metadata;
use LWP::Simple;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "find ".$self->{path}."/*" if $self->{path};
	return $self;
}

sub itemtype { return "GSDatadir::Metadata"; }

sub list {
	my $self = shift;
	unless ($self->{path}) {
		$self->{path} = '/nonexistent';
		$self->{glob} = 'nonexistent';
		return;
	}
	foreach (`$self->{glob}`) {
		chomp;
		$self->{coll}{$_} = GSDatadir::Metadata->new($self->{gc}, $_);
	}
}

1;
