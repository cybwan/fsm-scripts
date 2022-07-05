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

find "${OSM_HOME}"/tests -type f -exec sed -i 's#"flomesh/httpbin:latest"#"localhost:5000/flomesh/httpbin:latest"#g' {} +
find "${OSM_HOME}"/tests -type f -exec sed -i 's#"flomesh/httpbin:ken"#"localhost:5000/flomesh/httpbin:ken"#g' {} +
find "${OSM_HOME}"/tests -type f -exec sed -i 's#"busybox"#"localhost:5000/busybox"#g' {} +
find "${OSM_HOME}"/tests -type f -exec sed -i 's#"curlimages/curl"#"localhost:5000/curlimages/curl"#g' {} +
find "${OSM_HOME}"/tests -type f -exec sed -i 's#"flomesh/alpine-debug"#"localhost:5000/flomesh/alpine-debug"#g' {} +
find "${OSM_HOME}"/tests -type f -exec sed -i 's#"nginx:1.19-alpine"#"localhost:5000/nginx:1.19-alpine"#g' {} +
find "${OSM_HOME}"/tests -type f -exec sed -i 's#"flomesh/grpcurl"#"localhost:5000/flomesh/grpcurl"#g' {} +
find "${OSM_HOME}"/tests -type f -exec sed -i 's#"flomesh/grpcbin"#"localhost:5000/flomesh/grpcbin"#g' {} +
