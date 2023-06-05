#!/bin/bash

set -uo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

FSM_HOME=$1

cd "${FSM_HOME}" || exit 1

kubectl cluster-info >> /dev/null
if [[ $? == 1 ]]
then
  make kind-up
fi
source .env

allCases=(
"CertManagerSimpleClientServer"
"Test traffic flowing from client to a server with a podIP bind"
"Test traffic flowing from client to server with a Kubernetes Service for the Source: HTTP"
"Test traffic flowing from client to server without a Kubernetes Service for the Source: HTTP"
"SimpleClientServer traffic test involving fsm-controller restart: HTTP"
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
"When FSM is Installed"
"Test IP range exclusion"
"HTTP request rate limiting"
"Multiple service ports"
"Multiple services matching same pod"
"Test reinstalling FSM in the same namespace with the same mesh name"
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
#"SimpleClientServer TCP in permissive mode"
#"SimpleClientServer TCP with SMI policies"
"SimpleClientServer egress TCP"
#"TCP server-first traffic"
"HTTP recursive traffic splitting with SMI"
"TCP recursive traffic splitting with SMI"
"ClientServerTrafficSplitSameSA"
"HTTP traffic splitting with Permissive mode"
"HTTP traffic splitting with SMI"
"TCP traffic splitting with SMI"
"With SMI Traffic Target validation enabled"
"With SMI validation disabled"
#"HTTP ingress with IngressBackend"
#"Upgrade from latest"
)

CNT=${#allCases[*]}
No=1
# shellcheck disable=SC2068
for item in "${allCases[@]}"; do
  echo -e "$(date '+%Y-%m-%d %H:%M:%S') Testing[${No}/${CNT}] [$item] ..."
  E2E_FLAGS="-ginkgo.focus='$item'" make test-e2e 2>/dev/null | grep 'Passed.*Failed.*Skipped'
  ((No=No+1))
done
