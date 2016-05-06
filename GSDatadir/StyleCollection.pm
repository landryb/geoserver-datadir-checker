use warnings;
use strict;
use 5.010;

package GSDatadir::StyleCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::Style;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "$self->{path}/{workspaces/*/,}styles/*.xml";
	return $self;
}

sub itemtype { return "GSDatadir::Style"; }

1;
