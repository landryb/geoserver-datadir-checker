use warnings;
use strict;
use 5.010;
use XML::XPath;
use Digest::SHA;

package GSDatadir::SLD;
use XML::Twig;
use File::Basename;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	my $file = shift;
	$self->{file} = $file;
	$self->{id} = $file;
	$self->{filename} = fileparse($file);
	$self->{size} = (stat($file))[7];
	my $sha = Digest::SHA->new(256);
	$sha->addfile($file);
	$self->{sha256} = $sha->hexdigest;
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $parser = XML::Twig->new();
	if ($self->{size} > 0 && $parser->safe_parsefile($self->{file})) {
		$self->{wellformed} = 1;
		my $xp = XML::XPath->new(filename => $self->{file});
		$self->{name} = $xp->getNodeText('/sld:StyledLayerDescriptor/sld:NamedLayer/sld:Name | /StyledLayerDescriptor/NamedLayer/se:Name | /StyledLayerDescriptor/NamedLayer/Name | /StyledLayerDescriptor/UserLayer/Name | /sld:UserStyle/sld:Name');
		$self->{firstrulename} = $xp->getNodeText('(/sld:StyledLayerDescriptor/sld:NamedLayer/sld:UserStyle/sld:FeatureTypeStyle/sld:Rule)[1]/sld:Name | (/StyledLayerDescriptor/NamedLayer/UserStyle/se:FeatureTypeStyle/se:Rule)[1]/se:Name | (/StyledLayerDescriptor/NamedLayer/UserStyle/FeatureTypeStyle/Rule)[1]/Name | (/sld:UserStyle/sld:FeatureTypeStyle/sld:Rule)[1]/sld:Title');
		unless ($self->{name}) {
			say "didnt found a style name in $self->{file}";
		}
	}
	$self->{name} //= "";
	$self->{firstrulename} //= "";
}

sub dump {
	my $self = shift;
	say "SLD: file=$self->{file}, size=$self->{size}, sha1=$self->{sha256}, name=$self->{name}, firstrulename=$self->{firstrulename}"
}

sub check {
	my $self = shift;
	if ($self->{size} == 0) {
		say "SLD '$self->{id}' is empty";
		return -1;
	}
	my @styles = $self->{gc}->{s}->look_for_sldfilename($self->{filename});
	unless (@styles) {
		say "SLD '$self->{file}' isnt referenced by any style";
		return -1;
	}
	$self->{referenced_by} = \@styles;
	# XXX check for dupes by sha256
	# XXX validate against xsd ? xsd is only in geoserver source..
	# only validates well-formedness, exits if non well-formed
	my $parser = XML::Twig->new();
	unless ($parser->safe_parsefile($self->{file})) {
		say "SLD '$self->{id}' is incorrect XML, parsing failed";
		return -1;
	}
	return 0;
}
1;
