all: buildall

buildall: reindexshapefiles osm-carto.tm2source/data.yml osm-carto.tm2/project.yml

osm-carto.tm2source/data.yml: project.yaml
	python convert_ymls.py --input project.yaml --tm2source --output osm-carto.tm2source/data.yml
	
	ln -s ../data/ ./osm-carto.tm2source/ 2> /dev/null || true

osm-carto.tm2/project.yml: project.yaml
	python convert_ymls.py --input project.yaml --tm2 --output osm-carto.tm2/project.yml
	
	ln -s ../symbols/ ./osm-carto.tm2/ 2>/dev/null || true
	cd ./osm-carto.tm2/ && ln -s ../*mss ./ 2>/dev/null || true


%.index: %.shp
	./node_modules/.bin/mapnik-shapeindex.js --shape_files $*.shp

reindexshapefiles: data/simplified-land-polygons-complete-3857/simplified_land_polygons.index data/land-polygons-split-3857/land_polygons.index data/antarctica-icesheet-polygons-3857/icesheet_polygons.index data/antarctica-icesheet-outlines-3857/icesheet_outlines.index data/ne_110m_admin_0_boundary_lines_land/ne_110m_admin_0_boundary_lines_land.index ./data/world_boundaries/builtup_area.index ./data/world_boundaries/places.index ./data/world_boundaries/world_bnd_m.index ./data/world_boundaries/world_boundaries_m.index


tessera: buildall
	python convert_ymls.py --input project.yaml --tm2 --no-source --output osm-carto.tm2/project.yml
	MAPNIK_FONT_PATH=$$(find /usr/share/fonts/ -type f | sed 's|/[^/]*$$||' | uniq | paste -s -d: -) tessera -c tessera-serve-vector-tiles.json

mapbox-studio-classic: buildall
	#MAPNIK_FONT_PATH=$$(find /usr/share/fonts/ -type f | sed 's|/[^/]*$$||' | uniq | paste -s -d: -)
	python convert_ymls.py --input project.yaml --tm2 --source --output osm-carto.tm2/project.yml

kosmtik: buildall
	#MAPNIK_FONT_PATH=$$(find /usr/share/fonts/ -type f | sed 's|/[^/]*$$||' | uniq | paste -s -d: -)
	python convert_ymls.py --input project.yaml --tm2 --source --output osm-carto.tm2/project.yml
