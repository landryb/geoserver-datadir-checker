use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Featuretype;
use Data::Dumper;

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
}

sub dump {
	my $self = shift;
	say "Featuretype: file=$self->{file}, id=$self->{id}, name=$self->{name}, title=$self->{title}"
}

1;
