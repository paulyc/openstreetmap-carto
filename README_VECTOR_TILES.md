# OpenStreetMap Carto - Vector Tiles

Beta version ![Beta release](https://img.shields.io/badge/release-beta-orange.svg)

## Quick start

 * Import the data as per the [normal install process](INSTALL.md#openstreetmap-data)
 * Run this, which will compile the style and install and launch [tessera](https://github.com/mojodna/tessera):

        make tessera

 * Browse to [http://localhost:8080/tiles/](http://localhost:8080/tiles/) to view the raster generated vector tiles
 * Vector tiles are available from [http://localhost:8080/pbfs/live/](http://localhost:8080/pbfs/live/). TileJSON spec: [http://localhost:8080/pbfs/live/index.json](http://localhost:8080/pbfs/live/index.json). *(NB: This is generated live each time and can be very slow)*.

### Viewing with Kosmtik

    make kosmtik

Then serve the `osm-carto.tm2/project.yml` file with kosmtik:

    ./index.js serve /home/user/openstreetmap-carto/osm-carto.tm2/project.yml

## Project Goals

### Branching

Best effort attempts will be made to keep this project up-to-date with [upstream](https://github.com/gravitystorm/openstreetmap-carto). The `upstream-master` branch will be kept up to date with `upstream/master`, and the `master` branch will have the vector tile specific change.

### Copyright

This is under the same [copyright as upstream openstreetmap-carto](https://github.com/gravitystorm/openstreetmap-carto/blob/master/LICENSE.txt), namely [CC0](LICENSE.txt).

## Troubleshooting

### Very slow start up

When using node-mapnik, it can sometimes try to scan & sort the entire table. cf [osm2pgsql issue #573](https://github.com/openstreetmap/osm2pgsql/issues/573). This can take a few minutes on a small country extract, and days on a planet import. This is because `planet_osm_polygon.way` has a `GeometryCollection` type, not a `MultiPolgyon` (or `Polygon`). You can try [my fork of osm2pgsql](https://github.com/rory/osm2pgsql/tree/polygon-table-has-polygon-col-type) which will import data as a `MultiPolygon`. Or you can execute this command to alter the data:

    make postgresql-fix-geometry

You will not be able to do data updates after doing this command with a standard osm2pgsql command.

### More questions?

Contact Rory McCann <rory@technomancy.org>
