use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Workspace;
use Data::Dumper;

sub new {
	my $class = shift;
	my $file = shift;
	my $self = {};
	bless ($self, $class);
	$self->{file} = $file;
	$self->{id} = undef;
	$self->{name} = undef;
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{id} = $xp->getNodeText('/workspace/id');
	$self->{name} = $xp->getNodeText('/workspace/name');
}

sub dump {
	my $self = shift;
	say "Workspace: file=$self->{file}, id=$self->{id}, name=$self->{name}"
}

1;
