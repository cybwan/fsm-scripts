#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

FSM_HOME=$1

make .env
sed -i 's/^make build-fsm/#make build-fsm/g' "${FSM_HOME}"/demo/run-fsm-demo.sh
sed -i 's/^kind-demo: .env kind-up clean-fsm/kind-demo: .env kind-up/g' "${FSM_HOME}"/Makefile
sed -i 's/#export PUBLISH_IMAGES=true/export PUBLISH_IMAGES=false/g' "${FSM_HOME}"/.env
