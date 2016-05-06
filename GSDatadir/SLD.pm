use warnings;
use strict;
use 5.010;
use XML::XPath;
use Digest::SHA;

package GSDatadir::SLD;
use File::Basename;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	my $file = shift;
	$self->{file} = $file;
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

1;
