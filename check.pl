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
use GSDatadir::WMSLayerCollection;
use GSDatadir::MetadataCollection;
use XML::XPath;

my $path = $ARGV[0];
die "usage: perl check.pl /path/to/geoserver/datadir [/path/to/geonetwork/xml/dump]" unless $path;
die "$path is not a geoserver datadir" unless -f "$path/global.xml";
my $xp = XML::XPath->new(filename => "$path/global.xml");
my $getcapurl = $xp->getNodeText('/global/settings/proxyBaseUrl')."/ows?service=WMS&request=GetCapabilities";
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
$c{wm} = GSDatadir::WMSLayerCollection->new(\%c, $getcapurl);
$c{md} = GSDatadir::MetadataCollection->new(\%c, $ARGV[1]);

foreach (sort keys %c) {
	$c{$_}->list;
	$c{$_}->dump;
}

say "\nstarting checks\n";
$c{$_}->check foreach (sort keys %c);
1;
