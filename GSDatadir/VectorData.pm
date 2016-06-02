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
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;

	my $file = shift;
	$self->{file} = $file;
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
	say "VectorData: file=$self->{file}, size=$self->{size}, featurecount=$self->{featurecount}, sha1=$self->{sha256}";
#	say Dumper($self);
}

sub check {
	my $self = shift;
	my $dir = dirname($self->{file});
	my @datastores = $self->{gc}->{ds}->look_for_connurl("file:$dir/");
	unless (@datastores) {
		say "VectorData '$self->{file}' isnt referenced by any datastore";
		return -1;
	}
	$self->{referenced_by} = \@datastores;
	return 0;
}
1;
