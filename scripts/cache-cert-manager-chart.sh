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

rm -rf "${OSM_HOME}"/tests/e2e/cert-manager-v1.3.1.tgz
cp -rf scripts/cert-manager-v1.3.1.tgz "${OSM_HOME}"/tests/e2e/cert-manager-v1.3.1.tgz

sed -i '/chart, err := loader.Load(chartPath)/i\\tchartPath = \".\/cert-manager-v1.3.1.tgz\"' "${OSM_HOME}"/tests/framework/common.go