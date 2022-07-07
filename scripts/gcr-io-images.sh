#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument OSM_HOME"
  exit 1
fi

OSM_HOME=$1

find "${OSM_HOME}"/dockerfiles -type f -exec sed -i 's# gcr.io/distroless/base# cybwan/gcr.io.distroless.base#g' {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i 's# gcr.io/distroless/static# cybwan/gcr.io.distroless.static#g' {} +

