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
	$self->{id} = $xp->getNodeText('/featureType/id')->value;
	$self->{name} = $xp->getNodeText('/featureType/name')->value;
	$self->{title} = $xp->getNodeText('/featureType/title')->value;
	$self->{declaredsrs} = $xp->getNodeText('/featureType/srs')->value;
	$self->{nativename} = $xp->getNodeText('/featureType/nativeName')->value;
	$self->{namespaceid} = $xp->getNodeText('/featureType/namespace/id')->value;
	$self->{datastoreid} = $xp->getNodeText('/featureType/store/id')->value;
	foreach ($xp->findnodes('/featureType/metadataLinks/metadataLink')->get_nodelist) {
		my $url = decode_entities($xp->findvalue('content', $_)->value);
		my $uuid = $url;
		$uuid =~ s/.*(uuid|ID)=//;
		$uuid =~ s/&.*//;
		push @{$self->{mdlinks}}, {
			content_type => $xp->findvalue('type', $_)->value,
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
	# only check if MDCollection contains items
	if (scalar(keys %{$self->{gc}->{md}->{coll}}) > 0) {
		my %metadatas;
		foreach (@{$self->{mdlinks}}) {
			my $md = $self->{gc}->{md}->get_item($_->{uuid});
			unless ($md) {
				say "Featuretype '$self->{name}' ($self->{id}) references a non-existent metadata: $_->{uuid}";
				return -1;
			}
			$metadatas{$_->{uuid}} = $md;
		}
		$self->{metadatas} = \%metadatas;
	}
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
