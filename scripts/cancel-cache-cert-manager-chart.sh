#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

FSM_HOME=$1

rm -rf "${FSM_HOME}"/tests/e2e/cert-manager-v1.3.1.tgz

sed -i '/\tchartPath = \".\/cert-manager-v1.3.1.tgz\"/d' "${FSM_HOME}"/tests/framework/common.go