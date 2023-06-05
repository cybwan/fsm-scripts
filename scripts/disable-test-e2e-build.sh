#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

FSM_HOME=$1

sed -i 's/^test-e2e: docker-build-fsm build-fsm docker-build-tcp-echo-server$/test-e2e:/g' "${FSM_HOME}"/Makefile
