#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

FSM_HOME=$1

WITH_CLOUD="${WITH_CLOUD:-yes}"
WITH_EBPF="${WITH_EBPF:-no}"

cd "${FSM_HOME}"
source .env
make docker-build-min
if [ "${WITH_CLOUD}" = "yes" ]; then
  make docker-build-fsm-connector
fi
if [ "${WITH_EBPF}" = "yes" ]; then
  make docker-build-fsm-interceptor
fi