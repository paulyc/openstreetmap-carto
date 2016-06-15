all: buildall

buildall: osm-carto.tm2source/data.yml osm-carto.tm2/project.yml

osm-carto.tm2source/data.yml: project.yaml
	python convert_ymls.py --input project.yaml --tm2source --output osm-carto.tm2source/data.yml
	
	ln -s ../data/ ./osm-carto.tm2source/ 2> /dev/null || true

osm-carto.tm2/project.yml: project.yaml
	python convert_ymls.py --input project.yaml --tm2 --output osm-carto.tm2/project.yml
	
	ln -s ../symbols/ ./osm-carto.tm2/ 2>/dev/null || true
	cd ./osm-carto.tm2/ && ln -s ../*mss ./ 2>/dev/null || true


tessera: buildall
	python convert_ymls.py --input project.yaml --tm2 --no-source --output osm-carto.tm2/project.yml
	MAPNIK_FONT_PATH=$$(find /usr/share/fonts/ -type f | sed 's|/[^/]*$$||' | uniq | paste -s -d: -) tessera -c tessera-serve-vector-tiles.json

mapbox-studio-classic: buildall
	#MAPNIK_FONT_PATH=$$(find /usr/share/fonts/ -type f | sed 's|/[^/]*$$||' | uniq | paste -s -d: -)
	python convert_ymls.py --input project.yaml --tm2 --source --output osm-carto.tm2/project.yml

kosmtik: buildall
	#MAPNIK_FONT_PATH=$$(find /usr/share/fonts/ -type f | sed 's|/[^/]*$$||' | uniq | paste -s -d: -)
	python convert_ymls.py --input project.yaml --tm2 --source --output osm-carto.tm2/project.yml
