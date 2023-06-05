#!/bin/bash

set -euo pipefail

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

FSM_HOME=$1

cd "${FSM_HOME}"
make kind-up
kubectl get namespace fsm-system || kubectl create namespace fsm-system
kubectl get secret acr-creds --namespace=fsm-system || kubectl --namespace=fsm-system \
create secret docker-registry acr-creds \
--docker-server=${LOCAL_REGISTRY} \
--docker-username=flomesh \
--docker-password=flomesh
sed -i '/^export CTR_REGISTRY_USERNAME=/d' "${FSM_HOME}"/.env
sed -i '/export CTR_REGISTRY_PASSWORD=/i\export CTR_REGISTRY_USERNAME=flomesh' "${FSM_HOME}"/.env
sed -i 's/^export CTR_REGISTRY_PASSWORD=.*/export CTR_REGISTRY_PASSWORD=flomesh/' "${FSM_HOME}"/.env
make kind-reset
