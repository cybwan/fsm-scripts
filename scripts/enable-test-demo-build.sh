#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument OSM_HOME"
  exit 1
fi

OSM_HOME=$1

sed -i 's/^#make build-osm/make build-osm/g' "${OSM_HOME}"/demo/run-osm-demo.sh
sed -i 's/^kind-demo: .env kind-up$/kind-demo: .env kind-up clean-osm/g' "${OSM_HOME}"/Makefile
sed -i 's/^export PUBLISH_IMAGES=true/#export PUBLISH_IMAGES=false/g' "${OSM_HOME}"/.env
