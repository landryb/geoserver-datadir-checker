use warnings;
use strict;
use 5.010;

package GSDatadir::WMSLayerCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::WMSLayer;
use LWP::Simple;
use IO::Socket::SSL;
use URI;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "nothing";
	my $url = URI->new($self->{path});
	if($url->scheme eq 'http' or $url->scheme eq 'https') {
		$self->{host} = $url->host;
	} else {
		$self->{host} = $self->{path}; # should be found from elsewhere, because the get() below will fail
	}
	return $self;
}

sub list {
	my $self = shift;
	my $ua = LWP::UserAgent->new(ssl_opts => { SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE});
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
