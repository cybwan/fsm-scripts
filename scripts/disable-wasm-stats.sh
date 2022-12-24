#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument OSM_HOME"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

OSM_HOME=$1

sed -i 's/^FROM \(.*\) AS wasm$/#FROM \1 AS wasm/g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-controller
sed -i 's/^WORKDIR \/wasm/#WORKDIR \/wasm/g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-controller
sed -i 's/^COPY \.\/wasm \./#COPY \.\/wasm \./g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-controller
sed -i 's/^RUN \/build_wasm\.sh/#RUN \/build_wasm\.sh/g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-controller
sed -i 's/^COPY --from=wasm/#COPY --from=wasm/g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-controller
