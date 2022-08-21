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

rm -rf "${OSM_HOME}"/tests/e2e/zookeeper-9.0.2.tgz

find "${OSM_HOME}"/tests -type f -exec sed -i 's#"./zookeeper-9.0.2.tgz"#"https://charts.bitnami.com/bitnami/zookeeper-9.0.2.tgz"#g' {} +