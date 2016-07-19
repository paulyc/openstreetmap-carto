CREATE UNIQUE INDEX planet_osm_nodes_pkey ON planet_osm_nodes USING btree (id);
CREATE UNIQUE INDEX planet_osm_ways_pkey ON planet_osm_ways USING btree (id);
CREATE INDEX planet_osm_ways_idx ON planet_osm_ways USING btree (id) WHERE pending;
CREATE UNIQUE INDEX planet_osm_rels_pkey ON planet_osm_rels USING btree (id);
CREATE INDEX planet_osm_rels_idx ON planet_osm_rels USING btree (id) WHERE pending;
CREATE INDEX planet_osm_ways_nodes ON planet_osm_ways USING gin (nodes) WITH (fastupdate=off);
CREATE INDEX planet_osm_rels_parts ON planet_osm_rels USING gin (parts) WITH (fastupdate=off);
CREATE INDEX planet_osm_line_index ON planet_osm_line USING gist (way);
CREATE INDEX planet_osm_line_pkey ON planet_osm_line USING btree (osm_id);
CREATE INDEX planet_osm_polygon_pkey ON planet_osm_polygon USING btree (osm_id);
CREATE INDEX planet_osm_roads_index ON planet_osm_roads USING gist (way);
CREATE INDEX planet_osm_roads_pkey ON planet_osm_roads USING btree (osm_id);
CREATE INDEX planet_osm_point_index ON planet_osm_point USING gist (way);
CREATE INDEX planet_osm_point_pkey ON planet_osm_point USING btree (osm_id);
CREATE INDEX planet_osm_line__waterway__river ON planet_osm_line USING gist (way) WHERE (waterway = 'river'::text);
CREATE INDEX idx_rail_aero ON planet_osm_line USING gist (way) WHERE ((((tunnel = 'yes'::text) OR (tunnel = 'building_passage'::text)) OR (covered = 'yes'::text)) AND ((railway IS NOT NULL) OR (aeroway IS NOT NULL)));
CREATE INDEX idx_road_select ON planet_osm_line USING gist (way) WHERE ((((tunnel = 'yes'::text) OR (tunnel = 'building_passage'::text)) OR (covered = 'yes'::text)) AND (highway IS NOT NULL));
CREATE INDEX idx_city_town ON planet_osm_point USING gist (way) WHERE (place = ANY ('{city,town}'::text[]));
CREATE INDEX idx_populations ON planet_osm_point USING btree (((
CASE
    WHEN (population ~ '^[0-9]{1,8}$'::text) THEN (population)::integer
    WHEN (place = 'city'::text) THEN 100000
    WHEN (place = 'town'::text) THEN 1000
    ELSE 1
END *
CASE
    WHEN (capital = 'yes'::text) THEN 3
    WHEN (capital = '4'::text) THEN 2
    ELSE 1
END)));
CREATE INDEX idx_ferry ON planet_osm_line USING gist (way) WHERE (route = 'ferry'::text);
CREATE INDEX idx_road_casings1 ON planet_osm_line USING gist (way) WHERE ((((highway IS NOT NULL) AND ((tunnel IS NULL) OR (tunnel <> ALL ('{yes,building_passage}'::text[])))) AND ((covered IS NULL) OR (covered <> 'yes'::text))) AND ((bridge IS NULL) OR (bridge <> ALL ('{yes,boardwalk,cantilever,covered,low_water_crossing,movable,trestle,viaduct}'::text[]))));
CREATE INDEX idx_road_casings2 ON planet_osm_line USING gist (way) WHERE (((((railway IS NOT NULL) OR (aeroway IS NOT NULL)) AND ((tunnel IS NULL) OR (tunnel <> ALL ('{yes,building_passage}'::text[])))) AND ((covered IS NULL) OR (covered <> 'yes'::text))) AND ((bridge IS NULL) OR (bridge <> ALL ('{yes,boardwalk,cantilever,covered,low_water_crossing,movable,trestle,viaduct}'::text[]))));
CREATE INDEX id_land_cover_low_zoom_sort ON planet_osm_polygon USING btree ((
CASE
    WHEN ((layer ~ '^-?\d+$'::text) AND (length(layer) < 10)) THEN (layer)::integer
    ELSE 0
END), way_area);
CREATE INDEX idx_highway_area_casing ON planet_osm_polygon USING gist (way) WHERE ((highway = ANY ('{residential,unclassified,pedestrian,service,footway,track,path,platform}'::text[])) OR (railway = 'platform'::text));
CREATE INDEX idx_buildings_major ON planet_osm_polygon USING gist (way) WHERE ((((building IS NOT NULL) AND (building <> 'no'::text)) AND (way_area > (0)::double precision)) AND ((aeroway = 'terminal'::text) OR (amenity = 'place_of_worship'::text)));
CREATE INDEX idx_landcover_area_symbols ON planet_osm_polygon USING gist (way) WHERE (((building IS NULL) AND (way_area > (0)::double precision)) AND (("natural" = ANY ('{marsh,mud,wetland,wood,beach,shoal,reef}'::text[])) OR (landuse = 'forest'::text)));
CREATE INDEX idx_text_poly ON planet_osm_polygon USING gist (way) WHERE ((((((((((((((((aeroway = ANY (ARRAY['gate'::text, 'apron'::text, 'helipad'::text, 'aerodrome'::text])) OR (tourism = ANY (ARRAY['alpine_hut'::text, 'hotel'::text, 'motel'::text, 'hostel'::text, 'chalet'::text, 'guest_house'::text, 'camp_site'::text, 'caravan_site'::text, 'theme_park'::text, 'museum'::text, 'attraction'::text, 'zoo'::text, 'information'::text, 'picnic_site'::text]))) OR (amenity IS NOT NULL)) OR (shop IS NOT NULL)) OR (leisure IS NOT NULL)) OR (landuse IS NOT NULL)) OR (man_made = ANY (ARRAY['lighthouse'::text, 'windmill'::text, 'mast'::text, 'water_tower'::text, 'pier'::text, 'breakwater'::text, 'groyne'::text]))) OR ("natural" IS NOT NULL)) OR (place = ANY (ARRAY['island'::text, 'islet'::text]))) OR (military = 'danger_area'::text)) OR (historic = ANY (ARRAY['memorial'::text, 'monument'::text, 'archaeological_site'::text]))) OR (highway = ANY (ARRAY['services'::text, 'rest_area'::text, 'bus_stop'::text, 'elevator'::text, 'ford'::text]))) OR (power = ANY (ARRAY['plant'::text, 'station'::text, 'generator'::text, 'sub_station'::text, 'substation'::text]))) OR (boundary = 'national_park'::text)) OR (waterway = 'dam'::text)) AND (name IS NOT NULL));
CREATE INDEX idx_landcover_low_zoom ON planet_osm_polygon USING gist (way) WHERE (((landuse = ANY (ARRAY['forest'::text, 'military'::text])) OR ("natural" = ANY (ARRAY['wood'::text, 'wetland'::text, 'mud'::text, 'sand'::text, 'scree'::text, 'shingle'::text, 'bare_rock'::text]))) AND (building IS NULL));
CREATE INDEX idx_text_poly_low_zoom ON planet_osm_polygon USING gist (way) WHERE (((((((landuse = ANY (ARRAY['forest'::text, 'military'::text])) OR ("natural" = ANY (ARRAY['wood'::text, 'glacier'::text, 'sand'::text, 'scree'::text, 'shingle'::text, 'bare_rock'::text]))) OR (place = 'island'::text)) OR (boundary = 'national_park'::text)) OR (leisure = 'nature_reserve'::text)) AND (building IS NULL)) AND (name IS NOT NULL));
CREATE INDEX idx_admins ON planet_osm_polygon USING gist (way) WHERE (((boundary = 'administrative'::text) AND (admin_level = ANY (ARRAY['2'::text, '4'::text]))) AND (name IS NOT NULL));
CREATE INDEX idx_water_areas ON planet_osm_polygon USING gist (way) WHERE ((((waterway = ANY (ARRAY['dock'::text, 'riverbank'::text, 'canal'::text])) OR (landuse = ANY (ARRAY['reservoir'::text, 'basin'::text]))) OR ("natural" = ANY (ARRAY['water'::text, 'glacier'::text]))) AND (building IS NULL));
create index idx_admin_text on planet_osm_polygon using gist (st_boundary(way)) where ((name IS NOT NULL) AND (boundary = 'administrative'::text)  AND (admin_level = ANY ('{0,1,2,3,4,5,6,7,8,9,10}'::text[])));
create index idx_area_barriers on planet_osm_polygon using gist (way) where (barrier is null);
create index idx_area_barriers_not_null on planet_osm_polygon using gist (way) where (barrier is not null);
create index idx_housenames_polygon on planet_osm_polygon using gist (way) where (("addr:housename" IS NOT NULL) AND (building IS NOT NULL) ); create index idx_housenames_point on planet_osm_point using gist (way) where ("addr:housename" IS NOT NULL); create index idx_housenumber_polygon on planet_osm_polygon using gist (way) where (("addr:housenumber" IS NOT NULL) AND (building IS NOT NULL) ); create index idx_housenumber_point on planet_osm_point using gist (way) where ("addr:housenumber" IS NOT NULL);
create index idx_way_area on planet_osm_polygon (way_area);
create index idx_amenity_low_priority_poly on planet_osm_polygon using gist (way) where ((barrier = ANY ('{bollard,gate,lift_gate,swing_gate,block}'::text[])) OR (highway = 'mini_roundabout'::text) OR (railway = 'level_crossing'::text) OR (amenity = ANY ('{parking,bicycle_parking,motorcycle_parking}'::text[])));
create index idx_bridge on planet_osm_polygon using gist (way) where man_made = 'bridge';
create index idx_building_text on planet_osm_polygon using gist (way) where ((building IS NOT NULL) AND (name IS NOT NULL) AND (building <> 'no'::text));
create index idx_marinas_areas on planet_osm_polygon using gist (way) where (leisure = 'marina'::text);





-- After adding the indexes, analyze the tables
analyze planet_osm_point;
analyze planet_osm_line;
analyze planet_osm_polygon;
