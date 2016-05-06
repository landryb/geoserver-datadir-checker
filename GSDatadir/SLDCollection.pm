use warnings;
use strict;
use 5.010;

package GSDatadir::SLDCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::SLD;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args, "SLD");
	$self->{glob} = "$self->{path}/{workspaces/*/,}styles/*.sld";
	return $self;
}

1;
