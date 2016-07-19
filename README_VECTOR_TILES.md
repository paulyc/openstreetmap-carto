# OpenStreetMap Carto - Vector Tiles

## Quick start

 * Import the data as per the [README.md](README.md).
 * Run this:

    make tessera

 * Browse to [http://localhost:8080/tiles/](http://localhost:8080/tiles/) to view the raster generated vector tiles

### Viewing with Kosmtik

    make kosmtik

Then serve the `osm-carto.tm2/project.yml` file with kosmtik:

    ./index.js serve /home/user/openstreetmap-carto/osm-carto.tm2/project.yml

## Possible problems

### Very slow start up

When using node-mapnik, it can sometimes try to scan & sort the entire table. cf [osm2pgsql issue #573](https://github.com/openstreetmap/osm2pgsql/issues/573). This can take a few minutes on a small country extract, and days on a planet import. This is because `planet_osm_polygon.way` has a `GeometryCollection` type, not a `MultiPolgyon` (or `Polygon`). You can try [my fork of osm2pgsql](https://github.com/rory/osm2pgsql/tree/polygon-table-has-polygon-col-type) which will import data as a `MultiPolygon`. Or you can execute this command to alter the data:

    make postgresql-fix-geometry

You will not be able to do data updates after doing this command with a standard osm2pgsql command.
