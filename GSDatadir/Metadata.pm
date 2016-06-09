use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Metadata;
use File::Basename;
use URI::URL;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	$self->{file} = shift;
	$self->{id} = basename($self->{file});
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{title} = $xp->getNodeText('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString');
	foreach ($xp->findnodes('//gmd:onLine/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString[text()="OGC:WMS"]/../..')->get_nodelist) {
		push @{$self->{onlineres}}, {
			url => $xp->findvalue('gmd:linkage/gmd:URL', $_),
			name => $xp->findvalue('gmd:name/gco:CharacterString', $_)
		};
	}
}

sub dump {
	my $self = shift;
	say "Metadata: id=$self->{id}, title=$self->{title}";
}

sub check {
	my $self = shift;
	my %wmslayers;
	foreach (@{$self->{onlineres}}) {
		my $url = url $_->{url};
		my $name = $_->{name};
		my $workspace;
		my $fullname;
		# check that it's a layer coming from the local geoserver
		if ($url->host eq $self->{gc}->{wm}->{host}) {
			# if it's not a prefixed layer name, extract the workspace and prepend it
			unless ($name =~ /:/) {
				# XXX assumes path is in the form of /foo/[workspace]/xxx ...
				$workspace = ($url->path_components)[2];
				$fullname = $workspace.":".$_->{name};
			} else {
				$fullname = $name;
				($workspace, $name) = split (/:/, $fullname);
			}
			my $wmslayer = $self->{gc}->{wm}->get_item($fullname);
			unless ($wmslayer) {
				say "Metadata '$self->{title}' ($self->{id}) references a non-existent WMS layer: $fullname";
				return -1;
			}
			$wmslayers{$fullname} = $wmslayer;
		}
	}
	$self->{wmslayers} = \%wmslayers;
	return 0;
}

1;
