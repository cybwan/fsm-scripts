#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# desired cluster name; default is "kind"
CONTROL_PLANE_CLUSTER="${CONTROL_PLANE_CLUSTER:-control-plane}"
BIZNESS_PLANE_CLUSTER="${BIZNESS_PLANE_CLUSTER:-cluster1}"

kubecm switch kind-${CONTROL_PLANE_CLUSTER}
sleep 1

cat <<EOF | kubectl apply -f -
apiVersion: flomesh.io/v1alpha1
kind: Cluster
metadata:
  name: ${BIZNESS_PLANE_CLUSTER}
spec:
  gatewayHost: ${API_SERVER_ADDR}
  gatewayPort: 8091
  kubeconfig: |+
`kind get kubeconfig --name ${BIZNESS_PLANE_CLUSTER} | sed 's/^/    /g'`
EOF