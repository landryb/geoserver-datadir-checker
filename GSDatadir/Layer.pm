use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Layer;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	$self->{file} = shift;
	$self->{id} = undef;
	$self->{name} = undef;
	$self->{type} = undef;
	$self->{defaultstyleid} = undef;
	$self->{styleids} = ();
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
	# XXX handle multiplestyles
	push @{$self->{styleids}}, $_->string_value foreach ($xp->findnodes('/layer/styles/style/id')->get_nodelist);
	push @{$self->{styleids}}, $self->{defaultstyleid};
	$self->{featuretypeid} = $xp->getNodeText('/layer/resource/id');
}

sub dump {
	my $self = shift;
	say "Layer: file=$self->{file}, id=$self->{id}, name=$self->{name}"
}

sub check {
	my $self = shift;
	my $defaultstyle = $self->{gc}->{s}->get_item($self->{defaultstyleid});
	my $featuretype = $self->{gc}->{ft}->get_item($self->{featuretypeid});
	unless ($defaultstyle) {
		say "Layer '$self->{name}' ($self->{id}) references a non-existent defaultstyle: $self->{defaultstyleid}";
		return -1;
	}
	$self->{defaultstyle} = \$defaultstyle;
	unless ($featuretype) {
		return 0 if ($self->{featuretypeid} =~ /^CoverageInfoImpl/);
		say "Layer '$self->{name}' ($self->{id}) references a non-existent featuretype: $self->{featuretypeid}";
		return -1;
	}
	$self->{featuretype} = \$featuretype;
	return 0;
}

1;
