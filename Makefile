all: osm-carto.tm2source/data.yml osm-carto.tm2/project.yml

osm-carto.tm2source/data.yml: project.yaml
	cp project.yaml osm-carto.tm2source/data.yml
	sed -i "s/maxzoom: 22/maxzoom: 14/" osm-carto.tm2source/data.yml
	# No source in the source
	sed -i "/^source:/d" osm-carto.tm2source/data.yml
	
	# Remove all the styles argument
	# cf. http://www.grymoire.com/Unix/Sed.html#uh-35a
	sed -i '/^styles:/,/^[^ ]/ { /^styles:/ { d } ; /^[^ ]/ !{  d } }' osm-carto.tm2source/data.yml
	
	ln -s ../data/ ./osm-carto.tm2source/ 2> /dev/null || true

osm-carto.tm2/project.yml: project.yaml
	cp project.yaml osm-carto.tm2/project.yml
	# Remove the Layer options
	sed -i '/^Layer:/,/^[^ ]/ d' ./osm-carto.tm2/project.yml
	ln -s ../symbols/ ./osm-carto.tm2/ 2>/dev/null || true
	cd ./osm-carto.tm2/ && ln -s ../*mss ./ 2>/dev/null || true

tessera: osm-carto.tm2source/data.yml osm-carto.tm2/project.yml
	MAPNIK_FONT_PATH=$$(find /usr/share/fonts/ -type f | sed 's|/[^/]*$$||' | uniq | paste -s -d: -) tessera -c tessera-serve-vector-tiles.json
