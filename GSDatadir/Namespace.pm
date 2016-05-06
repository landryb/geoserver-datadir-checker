use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Namespace;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	$self->{file} = shift;
	$self->{id} = undef;
	$self->{prefix} = undef;
	$self->{uri} = undef;
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{id} = $xp->getNodeText('/namespace/id');
	$self->{prefix} = $xp->getNodeText('/namespace/prefix');
	$self->{uri} = $xp->getNodeText('/namespace/uri');
}

sub dump {
	my $self = shift;
	say "Namespace: file=$self->{file}, id=$self->{id}, prefix=$self->{prefix}"
}

1;
