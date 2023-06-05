#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

FSM_HOME=$1
find "${FSM_HOME}"/scripts -type f -name "port-forward-*" -exec sed -i 's/port-forward "/port-forward --address 0.0.0.0 "/g' {} +