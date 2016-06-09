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

## Usage

```
perl check.pl /path/to/geoserver/datadir [/path/to/geonetwork/xml/dump]
```

The last optional argument expects a directory with one file per geonetwork
metadata, named with the uuid of the metadata. If used, it will parse
ISO19139 metadata for references to `onlineResource` with `protocol` being
`OGC:WMS`, and make sure that those point to existing layers in the geoserver
`GetCapabilities`.

If not used, at some point in the **TODO** list i'll populate the
`MetadataCollection` with the records fetched via CSW..

Such directory can be generated with the following additional script
(`xml_grep` and `xml_split` come from the `xml-twig-tools` debian package - of
course adapt to match your geonetwork database connection):

```
cd /path/to/geonetwork/xml/dump
echo '<theroot>' > all.xml
psql -t --no-align -h localhost -U geonetwork -d geonetwork \
        -c "select data from metadata where data like '<gmd:MD_Metadata%';" >> all.xml \
        || exit
echo '</theroot>' >> all.xml

xml_split all.xml || exit
rm -f all.xml all-00.xml

for f in *.xml ; do
        mv $f $(xml_grep --text_only gmd:fileIdentifier/gco:CharacterString $f)
done

```

## Dependencies

On debian, install the following packages: `libgdal-perl libwww-perl libxml-xpath-perl libxml-twig-perl`

## Why this script ?

I've grown tired of having broken layers/geoserver instances, and having to dive in the
maze of stacktraces in the log files. It also allows me to get the list of
unused/unreferenced files/datastores/styles to prune the datadir from.

## Why offline ?

Because you can run it from cron, on a copy of your datadir on a different box, etc..
And most importantly, it can show you things that geoserver lost track of - unlinked files/sld, broken shp for example - this wouldnt be possible via GeoServer REST APIs..

## Why perl ?

Because ?
