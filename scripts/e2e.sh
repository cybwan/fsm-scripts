#!/bin/bash

set -uo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument OSM_HOME"
  exit 1
fi

OSM_HOME=$1

cd "${OSM_HOME}" || exit 1

allCases=(
"CertManagerSimpleClientServer"
"Test traffic flowing from client to a server with a podIP bind"
"Test traffic flowing from client to server with a Kubernetes Service for the Source: HTTP"
"Test traffic flowing from client to server without a Kubernetes Service for the Source: HTTP"
"SimpleClientServer traffic test involving osm-controller restart: HTTP"
"DebugServer"
"DeploymentsClientServer"
"HTTP egress policy without route matches"
"HTTP egress policy with route match"
"HTTPS egress policy"
"TCP egress policy"
"Egress"
"Fluent Bit deployment"
"Fluent Bit output"
"Garbage Collection"
"gRPC insecure traffic origination over HTTP2 with SMI HTTP routes"
"gRPC secure traffic origination over HTTP2 with SMI TCP routes"
"HashivaultSimpleClientServer"
"Test health probes can succeed"
"Helm install using default values"
"Ignore Label"
"When OSM is Installed"
"Test IP range exclusion"
"HTTP request rate limiting"
"Multiple service ports"
"Multiple services matching same pod"
"Test reinstalling OSM in the same namespace with the same mesh name"
"PermissiveToSmiSwitching"
"Permissive mode HTTP test with a Kubernetes Service for the Source"
"Permissive mode HTTP test without a Kubernetes Service for the Source"
"Test global port exclusion"
"Test pod level port exclusion"
"proxy resources"
"Enable Reconciler"
"Retry policy disabled"
"Retry policy enabled"
"SMI Traffic Target is not in the same namespace as the destination"
"SMI TrafficTarget is set up properly"
"Statefulsets"
"SimpleClientServer TCP in permissive mode"
"SimpleClientServer TCP with SMI policies"
"SimpleClientServer egress TCP"
"TCP server-first traffic"
"HTTP recursive traffic splitting with SMI"
"TCP recursive traffic splitting with SMI"
"ClientServerTrafficSplitSameSA"
"HTTP traffic splitting with Permissive mode"
"HTTP traffic splitting with SMI"
"TCP traffic splitting with SMI"
"With SMI Traffic Target validation enabled"
"With SMI validation disabled"
#"Upgrade from latest"
#"HTTP ingress with IngressBackend"
#"Custom WASM metrics between one client pod and one server"
)

CNT=${#allCases[*]}
No=1
# shellcheck disable=SC2068
for item in "${allCases[@]}"; do
  echo -e "$(date '+%Y-%m-%d %H:%M:%S') Testing[${No}/${CNT}] $item ..."
  if [[ $item == Version* ]]
  then
    kind delete cluster --name osm-e2e
    CTR_REGISTRY=cybwan TIMEOUT=0 E2E_FLAGS="-installType=KindCluster -ginkgo.focus='$item'" make test-e2e 2>/dev/null | grep 'Passed.*Failed.*Skipped'
  else
    kubectl cluster-info >> /dev/null
    if [[ $? == 1 ]]
    then
      make kind-up
    fi
    E2E_FLAGS="-ginkgo.focus='$item'" make test-e2e 2>/dev/null | grep 'Passed.*Failed.*Skipped'
  fi

  ((No=No+1))
done
