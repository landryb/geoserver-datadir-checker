use warnings;
use strict;
use 5.010;

package GSDatadir::LayerCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::Layer;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args, "Layer");
	$self->{glob} = "$self->{path}/workspaces/*/*/*/layer.xml";
	return $self;
}

1;
