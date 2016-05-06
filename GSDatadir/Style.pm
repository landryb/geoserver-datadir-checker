use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Style;
use File::Basename;
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

sub check {
	my $self = shift;
	my $sldfile = dirname($self->{file})."/".$self->{filename};
	my $sld = $self->{gc}->{sl}->get_item($sldfile);
	unless ($sld) {
		say "$self->{id}/$self->{name} references a non-existent sld: $sldfile";
		return -1;
	}
	$self->{sld} = \$sld;

	if ($self->{workspaceid}) {
		my $workspace = $self->{gc}->{ws}->get_item($self->{workspaceid});
		unless ($workspace) {
			say "$self->{id}/$self->{name} references a non-existent workspace: $self->{workspaceid}";
			return -1;
		}
		$self->{workspace} = \$workspace;
	} else {
			say "$self->{id}/$self->{name} references no workspace: global style?";
	}
	return 0;
}
1;
