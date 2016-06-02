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
	$self->{namespaceid} = $xp->getNodeText('/featureType/namespace/id');
	$self->{datastoreid} = $xp->getNodeText('/featureType/store/id');
	push @{$self->{mdlinks}}, decode_entities($_->string_value) foreach ($xp->findnodes('/featureType/metadataLinks/metadataLink/content')->get_nodelist)
}

sub dump {
	my $self = shift;
	say "Featuretype: file=$self->{file}, id=$self->{id}, name=$self->{name}, title=$self->{title}"
}

sub check {
	my $self = shift;
	my $namespace = $self->{gc}->{ns}->get_item($self->{namespaceid});
	unless ($namespace) {
		say "$self->{id}/$self->{name} references a non-existent namespace: $self->{namespaceid}";
		return -1;
	}
	$self->{namespace} = \$namespace;
	my $datastore = $self->{gc}->{ds}->get_item($self->{datastoreid});
	unless ($datastore) {
		say "$self->{id}/$self->{name} references a non-existent datastore: $self->{datastoreid}";
		return -1;
	}
	$self->{datastore} = \$datastore;
	my @layers = $self->{gc}->{l}->look_for_featuretypeid($self->{id});
	unless (@layers) {
		say "no layer references featuretype '$self->{name}' ($self->{id})";
		return -1;
	}
	$self->{referenced_by} = \@layers;
	if (0) {
		foreach (@{$self->{mdlinks}}) {
			my @resp = head($_);
			unless (@resp) {
				say "for $self->{id}/$self->{name}, metadataLink $_ failed";
			}
		}
	}
	return 0;
}

1;
