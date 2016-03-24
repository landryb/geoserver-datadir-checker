use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Layer;
use Data::Dumper;

sub new {
	my $class = shift;
	my $file = shift;
	my $self = {};
	bless ($self, $class);
	$self->{file} = $file;
	$self->{id} = undef;
	$self->{name} = undef;
	$self->{type} = undef;
	$self->{defaultstyleid} = undef;
	$self->{featuretypeid} = undef;
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{id} = $xp->getNodeText('/layer/id');
	$self->{name} = $xp->getNodeText('/layer/name');
	$self->{type} = $xp->getNodeText('/layer/type');
	$self->{defaultstyleid} = $xp->getNodeText('/layer/defaultStyle/id');
	$self->{featuretypeid} = $xp->getNodeText('/layer/resource/id');
}

sub dump {
	my $self = shift;
	say "Layer: file=$self->{file}, id=$self->{id}, name=$self->{name}"
}

1;
