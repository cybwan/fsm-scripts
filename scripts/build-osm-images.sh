#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument OSM_HOME"
  exit 1
fi

OSM_HOME=$1

cd "${OSM_HOME}"
source .env
if [ -z "$2" ]; then
  make docker-build-osm
else
  make docker-build-osm-edge-"$2"
fi