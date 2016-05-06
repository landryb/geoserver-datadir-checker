use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Style;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	$self->{file} = shift;
	$self->{id} = undef;
	$self->{name} = undef;
	$self->{filename} = undef;
	$self->{workspaceid} = undef;
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{id} = $xp->getNodeText('/style/id');
	$self->{name} = $xp->getNodeText('/style/name');
	$self->{workspaceid} = $xp->getNodeText('/style/workspace/id');
	$self->{filename} = $xp->getNodeText('/style/filename');
}

sub dump {
	my $self = shift;
	say "Style: file=$self->{file}, id=$self->{id}, name=$self->{name}, filename=$self->{filename}"
}

1;
