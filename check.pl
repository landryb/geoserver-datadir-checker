#!/usr/bin/perl

use strict;
use warnings;
use 5.010;
use GSDatadir::WorkspaceCollection;
use GSDatadir::NamespaceCollection;
use GSDatadir::DatastoreCollection;
use GSDatadir::StyleCollection;

my $path = "/srv/data/geoserver-prod";
my $wc = GSDatadir::WorkspaceCollection->new($path);
my $nc = GSDatadir::NamespaceCollection->new($path);
my $dc = GSDatadir::DatastoreCollection->new($path);
my $sc = GSDatadir::StyleCollection->new($path);

$wc->list;
$nc->list;
$dc->list;
$sc->list;
$wc->dump;
$nc->dump;
$sc->dump;
$dc->dump;

1;
