#!/usr/bin/perl

use strict;
use warnings;
use 5.010;
use GSDatadir::WorkspaceCollection;
use GSDatadir::NamespaceCollection;
use GSDatadir::DatastoreCollection;
use GSDatadir::StyleCollection;

my $path = "/srv/data/geoserver-prod";
my %c;
$c{ws} = GSDatadir::WorkspaceCollection->new($path);
$c{ns} = GSDatadir::NamespaceCollection->new($path);
$c{ds} = GSDatadir::DatastoreCollection->new($path);
$c{s} = GSDatadir::StyleCollection->new($path);

foreach (keys %c) {
	$c{$_}->list;
	$c{$_}->dump;
}

1;
