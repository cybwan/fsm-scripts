#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

FSM_HOME=$1

find "${FSM_HOME}"/dockerfiles -type f -exec sed -i 's# cybwan/gcr.io.distroless.base# gcr.io/distroless/base#g' {} +
find "${FSM_HOME}"/dockerfiles -type f -exec sed -i 's# cybwan/gcr.io.distroless.static# gcr.io/distroless/static#g' {} +

