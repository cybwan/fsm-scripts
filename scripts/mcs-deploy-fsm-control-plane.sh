#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# desired cluster name; default is "kind"
KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-osm}"
FSM_NAMESPACE="${FSM_NAMESPACE:-flomesh}"
FSM_VERSION="${FSM_VERSION:-latest}"
FSM_CHART="${FSM_CHART:-fsm/fsm}"

kubecm switch kind-${KIND_CLUSTER_NAME}
sleep 5

helm install --namespace ${FSM_NAMESPACE} --create-namespace \
--version=${FSM_VERSION} \
--set fsm.logLevel=5 \
--set fsm.serviceLB.enabled=true \
fsm ${FSM_CHART}
