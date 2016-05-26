use warnings;
use strict;
use 5.010;

package GSDatadir::WMSLayerCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::WMSLayer;
use LWP::Simple;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "nothing";
	$self->{xml} = get($self->{path}) or die;
	return $self;
}

sub list {
	my $self = shift;
	$self->{parser} = XML::XPath->new(xml => $self->{xml});
	#parse getcapabilities, create WMSLayer
	foreach ($self->{parser}->findnodes('WMS_Capabilities/Capability/Layer/Layer')->get_nodelist) {
		my $item = $self->itemtype->new($self->{gc}, $_);
		$self->{coll}{$item->{id}} = $item;
	}
}

sub itemtype { return "GSDatadir::WMSLayer"; }

1;
