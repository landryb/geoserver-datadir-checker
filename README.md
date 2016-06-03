# geoserver-datadir-checker

Tired of having unused files in your datadir ? Broken layers referencing non-existent data or styles ?
Then this script is made for you. Run it with the path to your Geoserver datadir, and it will report
you inconsistencies found in the xml files, and geographical data referenced by the datastores.

## Features

 * Parses workspaces, namespaces, datastores, styles, layers and featuretypes
 * Lists all geographical data available in data/, ShapeFile format only for now
 * Lists sld files
 * Checks:
   * *id* cross-references between xml files
   * unreferenced styles
   * unreferenced data directories
   * styles referencing unexistent sld
   * empty/invalid sld
   * metadatalinks referencing existing MD urls
   * datastores referencing unexistent directory
   * featuretype referencing unexistent file
   * layers present in GetCapabilities document **TODO**
   * duplicates in data directories, based on sha256 sum of the .shp file
 * eventually look at fdupes on the datadir ?

## Dependencies

On debian, install the following packages: `libgdal-perl libwww-perl libxml-xpath-perl libxml-twig-perl`

## Why this script ?

I've grown tired of having broken layers/geoserver instances, and having to dive in the
maze of stacktraces in the log files. It also allows me to get the list of
unused/unreferenced files/datastores/styles to prune the datadir from.

## Why offline ?

Because you can run it from cron, on a copy of your datadir on a different box, etc..

## Why perl ?

Because ?
