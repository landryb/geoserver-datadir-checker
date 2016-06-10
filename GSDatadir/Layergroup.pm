use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Layergroup;
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
	$self->{workspaceid} = undef;
	$self->{layerids} = ();
	$self->{styleids} = ();
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{id} = $xp->getNodeText('/layerGroup/id')->value;
	$self->{name} = $xp->getNodeText('/layerGroup/name')->value;
	$self->{title} = $xp->getNodeText('/layerGroup/title')->value;
	$self->{workspaceid} = $xp->getNodeText('/layerGroup/workspace/id')->value;

	push @{$self->{layerids}}, $_->string_value foreach ($xp->findnodes('/layerGroup/publishables/published[@type="layer"]/id')->get_nodelist);
	push @{$self->{styleids}}, $_->string_value foreach ($xp->findnodes('/layerGroup/styles/style/id')->get_nodelist);
}

sub dump {
	my $self = shift;
	say "Layergroup: file=$self->{file}, id=$self->{id}, name=$self->{name}, contains ".scalar @{$self->{layerids}}." layers";
}

sub check {
	my $self = shift;
	my $workspace = $self->{gc}->{ws}->get_item($self->{workspaceid});
	unless ($workspace) {
		say "Layergroup '$self->{name}' ($self->{name}) references a non-existent workspace: $self->{workspaceid}";
		return -1;
	}
	$self->{workspace} = \$workspace;
	$self->{layers} = ();
	foreach (@{$self->{layerids}}) {
		my $layer = $self->{gc}->{l}->get_item($_);
		unless ($layer) {
			say "Layergroup '$self->{name}' ($self->{name}) references a non-existent layer: $_";
			return -1;
		}
		push @{$self->{layers}}, $layer;
	}
	$self->{styles} = ();
	foreach (@{$self->{styleids}}) {
		my $style = $self->{gc}->{s}->get_item($_);
		unless ($style) {
			say "Layergroup '$self->{name}' ($self->{name}) references a non-existent style: $_";
			return -1;
		}
		push @{$self->{styles}}, $style;
	}
	return 0;
}
1;
