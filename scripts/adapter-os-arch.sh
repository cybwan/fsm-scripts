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
BUILD_ARCH=$2

if [[ "${BUILD_ARCH}" == "arm64" ]]; then
  find "${FSM_HOME}"/charts -type f -exec sed -i 's/amd64/arm64/g' {} +
  sed -i 's/kind create cluster --name/kind create cluster --image kindest\/node-arm64:v1.20.15 --name/g' "${FSM_HOME}"/scripts/kind-with-registry.sh

  find "${FSM_HOME}"/demo -type f -exec sed -i 's/amd64/arm64/g' {} +

  find "${FSM_HOME}"/tests -type f -exec sed -i 's#"simonkowallik/httpbin"#"flomesh/httpbin:latest"#g' {} +
  find "${FSM_HOME}"/tests -type f -exec sed -i 's#"kennethreitz/httpbin"#"flomesh/httpbin:ken"#g' {} +
  find "${FSM_HOME}"/tests -type f -exec sed -i 's#"songrgg/alpine-debug"#"flomesh/alpine-debug"#g' {} +
  find "${FSM_HOME}"/tests -type f -exec sed -i 's#"networld/grpcurl"#"flomesh/grpcurl"#g' {} +
  find "${FSM_HOME}"/tests -type f -exec sed -i 's#"moul/grpcbin"#"flomesh/grpcbin"#g' {} +
fi

sed -i 's/image: mysql:5.6/image: devilbox\/mysql:mysql-8.0/g' "${FSM_HOME}"/demo/deploy-mysql.sh