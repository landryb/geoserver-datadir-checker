use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Datastore;
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
	$self->{enabled} = undef;
	$self->{workspaceid} = undef;
	$self->{connurl} = undef;
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{id} = $xp->getNodeText('/dataStore/id');
	$self->{name} = $xp->getNodeText('/dataStore/name');
	$self->{type} = $xp->getNodeText('/dataStore/type');
	$self->{enabled} = $xp->getNodeText('/dataStore/type');
	$self->{workspaceid} = $xp->getNodeText('/dataStore/workspace/id');
	$self->{connurl} = $xp->getNodeText('/dataStore/connectionParameters/entry[@key="url"]');
}

sub dump {
	my $self = shift;
	say "Datastore: file=$self->{file}, id=$self->{id}, name=$self->{name}, type=$self->{type}, connurl=$self->{connurl}"
}

1;
