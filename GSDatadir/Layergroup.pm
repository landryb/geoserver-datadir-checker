use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Layergroup;
use Data::Dumper;

sub new {
	my $class = shift;
	my $file = shift;
	my $self = {};
	bless ($self, $class);
	$self->{file} = $file;
	$self->{id} = undef;
	$self->{name} = undef;
	$self->{title} = undef;
	$self->{workspaceid} = undef;
	$self->{layerids} = ();
	$self->{styleids} = ();
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{id} = $xp->getNodeText('/layerGroup/id');
	$self->{name} = $xp->getNodeText('/layerGroup/name');
	$self->{title} = $xp->getNodeText('/layerGroup/title');
	$self->{workspaceid} = $xp->getNodeText('/layerGroup/workspace/id');

	push @{$self->{layerids}}, $_->string_value foreach ($xp->findnodes('/layerGroup/publishables/published[@type="layer"]/id')->get_nodelist);
	push @{$self->{styleids}}, $_->string_value foreach ($xp->findnodes('/layerGroup/styles/style/id')->get_nodelist);
}

sub dump {
	my $self = shift;
	say "Layergroup: file=$self->{file}, id=$self->{id}, name=$self->{name}, contains ".scalar @{$self->{layerids}}." layers";
}

1;
