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

sed -i 's# devilbox/mysql:mysql-8.0# localhost:5000/devilbox/mysql:mysql-8.0#g' "${OSM_HOME}"/demo/deploy-mysql.sh
sed -i 's#image: curlimages/curl#image: localhost:5000/curlimages/curl#g' "${OSM_HOME}"/demo/multicluster-fault-injection.sh
