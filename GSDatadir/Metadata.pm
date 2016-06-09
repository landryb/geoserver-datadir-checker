use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Metadata;
use File::Basename;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	$self->{file} = shift;
	$self->{id} = basename($self->{file});
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{title} = $xp->getNodeText('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString');
	# XXX handle several values
	$self->{onlineresurl} = $xp->getNodeText('//gmd:onLine/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString[text()="OGC:WMS"]/../../gmd:linkage/gmd:URL');
	$self->{onlineresname} = $xp->getNodeText('//gmd:onLine/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString[text()="OGC:WMS"]/../../gmd:name/gco:CharacterString');
}

sub dump {
	my $self = shift;
	say "Metadata: id=$self->{id}, title=$self->{title}";
}

sub check {
	my $self = shift;
	# XXX check that onlineresurl and onlineresname point to a valid workspace/layer
	return 0;
}

1;
