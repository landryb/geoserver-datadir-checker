use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Featuretype;
use Data::Dumper;
use LWP::Simple;
use HTML::Entities;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	$self->{file} = shift;
	$self->{id} = undef;
	$self->{name} = undef;
	$self->{title} = undef;
	$self->{nativename} = undef;
	$self->{declaredsrs} = undef;
	$self->{namespaceid} = undef;
	$self->{datastoreid} = undef;
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{id} = $xp->getNodeText('/featureType/id');
	$self->{name} = $xp->getNodeText('/featureType/name');
	$self->{title} = $xp->getNodeText('/featureType/title');
	$self->{declaredsrs} = $xp->getNodeText('/featureType/srs');
	$self->{nativename} = $xp->getNodeText('/featureType/nativeName');
	$self->{namespaceid} = $xp->getNodeText('/featureType/namespace/id');
	$self->{datastoreid} = $xp->getNodeText('/featureType/store/id');
	foreach ($xp->findnodes('/featureType/metadataLinks/metadataLink')->get_nodelist) {
		my $url = decode_entities($xp->findvalue('content', $_));
		my $uuid = $url;
		$uuid =~ s/.*(uuid|ID)=//;
		$uuid =~ s/&.*//;
		push @{$self->{mdlinks}}, {
			content_type => $xp->findvalue('type', $_),
			uuid => $uuid,
			csw => ($url =~ /service=csw/i ? 1 : 0),
			url => $url
		};
	}
}

sub dump {
	my $self = shift;
	say "Featuretype: file=$self->{file}, id=$self->{id}, name=$self->{name}, title=$self->{title}"
}

sub check {
	my $self = shift;
	my $namespace = $self->{gc}->{ns}->get_item($self->{namespaceid});
	unless ($namespace) {
		say "Featuretype '$self->{name}' ($self->{id}) references a non-existent namespace: $self->{namespaceid}";
		return -1;
	}
	$self->{namespace} = \$namespace;
	my $datastore = $self->{gc}->{ds}->get_item($self->{datastoreid});
	unless ($datastore) {
		say "Featuretype '$self->{name}' ($self->{id}) references a non-existent datastore: $self->{datastoreid}";
		return -1;
	}
	$self->{datastore} = \$datastore;
	if ($datastore->{connurl}) {
		my $fulldatapath = $datastore->{connurl}.$self->{nativename};
		$fulldatapath =~ s/^file://;
		my $vd = $self->{gc}->{vd}->get_item($fulldatapath.".shp");
		$vd = $self->{gc}->{vd}->get_item($fulldatapath.".SHP") unless ($vd);
		unless ($vd) {
			say "Featuretype '$self->{name}' ($self->{id}) references a non-existent vectordata at $fulldatapath.{shp,SHP}";
			return -1;
		}
	}
	my @layers = $self->{gc}->{l}->look_for_featuretypeid($self->{id});
	unless (@layers) {
		say "Featuretype '$self->{name}' ($self->{id}) isnt referenced by any layer";
		return -1;
	}
	$self->{referenced_by} = \@layers;
	if (0) {
		foreach (@{$self->{mdlinks}}) {
			my $ua = LWP::UserAgent->new(ssl_opts => { SSL_verify_mode => 'SSL_VERIFY_NONE' });
			my $response = $ua->head($_->{url});
			unless ($response->is_success) {
				say "Featuretype '$self->{name}' ($self->{id}) has a broken metadataLink: $_->{url} - response is ".$response->status_line;
			}
		}
	}
	return 0;
}

1;
