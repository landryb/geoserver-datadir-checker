#!/usr/bin/perl

use strict;
use warnings;
use 5.010;
use GSDatadir::WorkspaceCollection;
use GSDatadir::NamespaceCollection;
use GSDatadir::DatastoreCollection;
use GSDatadir::StyleCollection;
use GSDatadir::SLDCollection;
use GSDatadir::VectorDataCollection;
use GSDatadir::FeaturetypeCollection;
use GSDatadir::LayerCollection;
use GSDatadir::LayergroupCollection;

my $path = "/srv/data/geoserver-prod";
my %c;
$c{ws} = GSDatadir::WorkspaceCollection->new(\%c, $path);
$c{ns} = GSDatadir::NamespaceCollection->new(\%c, $path);
$c{ds} = GSDatadir::DatastoreCollection->new(\%c, $path);
$c{s} = GSDatadir::StyleCollection->new(\%c, $path);
$c{sl} = GSDatadir::SLDCollection->new(\%c, $path);
$c{vd} = GSDatadir::VectorDataCollection->new(\%c, $path);
$c{ft} = GSDatadir::FeaturetypeCollection->new(\%c, $path);
$c{l} = GSDatadir::LayerCollection->new(\%c, $path);
$c{lg} = GSDatadir::LayergroupCollection->new(\%c, $path);

foreach (keys %c) {
	$c{$_}->list;
	$c{$_}->dump;
}

1;
