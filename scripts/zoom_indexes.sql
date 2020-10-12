-- experimental -- not sure about these values
-- CREATE INDEX planet_osm_polygon_way_area_zx on planet_osm_polygon using gist (way) WHERE way_area > 14900;
-- this index maybe no use "planet_osm_polygon_landuse_index" gist (way, to_tsvector('english'::regconfig, landuse))

CREATE INDEX planet_osm_polygon_way_area_z1  on planet_osm_polygon using gist(way) where way_area::real > 58880000.0;
CREATE INDEX planet_osm_polygon_way_area_z2  on planet_osm_polygon using gist(way) where way_area::real > 14200000.0;
CREATE INDEX planet_osm_polygon_way_area_z3  on planet_osm_polygon using gist(way) where way_area::real > 3680000.0;
CREATE INDEX planet_osm_polygon_way_area_z4  on planet_osm_polygon using gist(way) where way_area::real > 920000.0;
CREATE INDEX planet_osm_polygon_way_area_z5_1  on planet_osm_polygon using gist(way) where way_area::real > 2200000.0;
CREATE INDEX planet_osm_polygon_way_area_z6  on planet_osm_polygon using gist(way) where way_area::real > 590000.0;
CREATE INDEX planet_osm_polygon_way_area_z7  on planet_osm_polygon using gist(way) WHERE way_area::real > 140000.0;
CREATE INDEX planet_osm_polygon_way_area_z8  on planet_osm_polygon using gist(way) WHERE way_area::real > 370000.0;
CREATE INDEX planet_osm_polygon_way_area_z9  on planet_osm_polygon using gist(way) WHERE way_area::real > 92000.0;
CREATE INDEX planet_osm_polygon_way_area_z10 on planet_osm_polygon using gist(way) WHERE way_area::real > 23300.0;

