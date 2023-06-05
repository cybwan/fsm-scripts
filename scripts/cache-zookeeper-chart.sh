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

#https://charts.bitnami.com/bitnami/zookeeper-9.0.2.tgz
#curl -L https://charts.bitnami.com/bitnami/zookeeper-9.0.2.tgz -o zookeeper-9.0.2.tgz
rm -rf "${FSM_HOME}"/tests/e2e/zookeeper-9.0.2.tgz
cp -rf scripts/zookeeper-9.0.2.tgz "${FSM_HOME}"/tests/e2e/zookeeper-9.0.2.tgz

find "${FSM_HOME}"/tests -type f -exec sed -i 's#"https://charts.bitnami.com/bitnami/zookeeper-9.0.2.tgz"#"./zookeeper-9.0.2.tgz"#g' {} +