# geoserver-datadir-checker

Tired of having unused files in your datadir ? Broken layers referencing non-existent data or styles ?
Then this script is made for you. Run it with the path to your Geoserver datadir, and it will report
you inconsistencies found in the xml files, and geographical data referenced by the datastores.

## Features

 * Parses workspaces, namespaces, datastores, styles, layers and featuretypes
 * Lists all geographical data available in data/, ShapeFile format only for now
 * Checks: (**TODO** for now)
   * *id* cross-references between xml files
   * unreferenced styles
   * unreferenced data directories **done**
   * styles referencing unexistent sld
   * datastores referencing unexistent directory **done**
   * featuretype referencing unexistent file
   * layers present in GetCapabilities document
   * duplicates in data directories, based on sha256 sum of the .shp file **done**
 * eventually look at fdupes on the datadir ?

## Why this script ?

I've grown tired of having broken layers/geoserver instances, and having to dive in the
maze of stacktraces in the log files.

## Why offline ?

Because you can run it from cron, on a copy of your datadir on a different box, etc..

## Why perl ?

Because ?
