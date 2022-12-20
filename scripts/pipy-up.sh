#!/bin/bash

set -euo pipefail

#if [ -z "$1" ]; then
#  echo "Error: expected one argument PIPY_HOME"
#  exit 1
#fi
#
#PIPY_HOME=$1
#
#cd "${PIPY_HOME}"
#bin/pipy --admin-port=:6060
docker run --rm -p 6060:6060 -d --name pipy flomesh/pipy-repo-nightly:latest pipy --admin-port=:6060