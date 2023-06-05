#!/bin/bash

set -euo pipefail

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

FSM_HOME=$1

sed -i "s# ${LOCAL_REGISTRY}/devilbox/mysql:mysql-8.0# devilbox/mysql:mysql-8.0#g" "${FSM_HOME}"/demo/deploy-mysql.sh
