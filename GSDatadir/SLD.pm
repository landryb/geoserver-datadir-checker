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
	return $self;
}

sub dump {
	my $self = shift;
	say "SLD: file=$self->{file}, size=$self->{size}, sha1=$self->{sha256}"
}

sub check {
	my $self = shift;
	if ($self->{size} == 0) {
		say "$self->{id} is empty";
		return -1;
	}
	# XXX check for dupes by sha256
	# XXX validate against xsd ? xsd is only in geoserver source..
	# only validates well-formedness, exits if non well-formed
	my $parser = XML::Twig->new();
	unless ($parser->safe_parsefile($self->{file})) {
		say "$self->{id} is incorrect XML, parsing failed";
		return -1;
	}
	return 0;
}
1;
