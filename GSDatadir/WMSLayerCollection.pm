use warnings;
use strict;
use 5.010;

package GSDatadir::WMSLayerCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::WMSLayer;
use LWP::Simple;
use URI::URL;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "nothing";
	my $url = url $self->{path};
	$self->{host} = $url->host;
	return $self;
}

sub list {
	my $self = shift;
	my $ua = LWP::UserAgent->new(ssl_opts => { SSL_verify_mode => 'SSL_VERIFY_NONE' });
	my $response = $ua->get($self->{path});
	if ($response->is_success) {
		$self->{xml} = $response->decoded_content;
	} else {
		die $response->status_line;
	}
	$self->{parser} = XML::XPath->new(xml => $self->{xml});
	#parse getcapabilities, create WMSLayer
	foreach ($self->{parser}->findnodes('WMS_Capabilities/Capability/Layer/Layer')->get_nodelist) {
		my $item = $self->itemtype->new($self->{gc}, $_);
		$self->{coll}{$item->{id}} = $item;
	}
}

sub itemtype { return "GSDatadir::WMSLayer"; }

1;
