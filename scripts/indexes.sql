-- These are optional but suggested indexes for rendering OpenStreetMap Carto
-- with a full planet database.
-- This file is generated with ./indexes.py --concurrent

CREATE INDEX CONCURRENTLY planet_osm_line_ferry
  ON planet_osm_line USING GIST (way)
  WHERE route = 'ferry' AND osm_id > 0;
CREATE INDEX CONCURRENTLY planet_osm_line_name
  ON planet_osm_line USING GIST (way)
  WHERE name IS NOT NULL;
CREATE INDEX CONCURRENTLY planet_osm_line_river
  ON planet_osm_line USING GIST (way)
  WHERE waterway = 'river';
CREATE INDEX CONCURRENTLY planet_osm_point_place
  ON planet_osm_point USING GIST (way)
  WHERE place IS NOT NULL AND name IS NOT NULL;
CREATE INDEX CONCURRENTLY planet_osm_polygon_military
  ON planet_osm_polygon USING GIST (way)
  WHERE (landuse = 'military' OR military = 'danger_area') AND building IS NULL;
CREATE INDEX CONCURRENTLY planet_osm_polygon_name
  ON planet_osm_polygon USING GIST (way)
  WHERE name IS NOT NULL;
CREATE INDEX CONCURRENTLY planet_osm_polygon_nobuilding
  ON planet_osm_polygon USING GIST (way)
  WHERE building IS NULL;
CREATE INDEX CONCURRENTLY planet_osm_polygon_water
  ON planet_osm_polygon USING GIST (way)
  WHERE waterway IN ('dock', 'riverbank', 'canal')
    OR landuse IN ('reservoir', 'basin')
    OR "natural" IN ('water', 'glacier');
-- unsure about this way_area
CREATE INDEX CONCURRENTLY planet_osm_polygon_way_area_z10
  ON planet_osm_polygon USING GIST (way)
  WHERE way_area > 23300;
-- unsure about this way_area but pretty sure it needs to be this
-- rather than the 5980000 it was
CREATE INDEX CONCURRENTLY planet_osm_polygon_way_area_z6
  ON planet_osm_polygon USING GIST (way)
  WHERE way_area > 598000;
CREATE INDEX CONCURRENTLY planet_osm_roads_admin
  ON planet_osm_roads USING GIST (way)
  WHERE boundary = 'administrative';
CREATE INDEX CONCURRENTLY planet_osm_roads_admin_low
  ON planet_osm_roads USING GIST (way)
  WHERE boundary = 'administrative' AND admin_level IN ('0', '1', '2', '3', '4');
CREATE INDEX CONCURRENTLY planet_osm_roads_roads_ref
  ON planet_osm_roads USING GIST (way)
  WHERE highway IS NOT NULL AND ref IS NOT NULL;

