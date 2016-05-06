use warnings;
use strict;
use 5.010;

package GSDatadir::LayergroupCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::Layergroup;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "$self->{path}/workspaces/*/layergroups/*.xml";
	return $self;
}

sub itemtype { return "GSDatadir::Layergroup"; }

1;
