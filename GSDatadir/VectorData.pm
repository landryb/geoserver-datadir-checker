use warnings;
use strict;
use 5.010;
use XML::XPath;
use Digest::SHA;

package GSDatadir::VectorData;
use File::Basename;
use Data::Dumper;
#libgdal-perl debian package
use Geo::GDAL;

sub new {
	my $class = shift;
	my $file = shift;
	my $self = {};
	bless ($self, $class);
	$self->{file} = $file;
	say $file;
	$self->{filename} = fileparse("$file");
	$self->{size} = (stat("$file"))[7];
	my $sha = Digest::SHA->new(256);
	$sha->addfile($file);
	$self->{sha256} = $sha->hexdigest;
	$self->{layername} = basename($file,('.shp','.SHP'));
	my $datasource = Geo::OGR::Open("$file");
	my $layer = $datasource->Layer($self->{layername});
	$self->{featurecount} = $layer->GetFeatureCount();
	return $self;
}

sub dump {
	my $self = shift;
	say "VectorData: file=$self->{file}, featurecount=$self->{featurecount}, sha1=$self->{sha256}";
#	say Dumper($self);
}

1;
