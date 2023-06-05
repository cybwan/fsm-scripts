#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

CTR_REGISTRY="${CTR_REGISTRY:-localhost:5000/flomesh}"
CTR_TAG="${CTR_TAG:-latest}"
BIZNESS_PLANE_CLUSTER="${BIZNESS_PLANE_CLUSTER:-cluster1}"

kubecm switch kind-${BIZNESS_PLANE_CLUSTER}
sleep 1
export fsm_namespace=fsm-system
export fsm_mesh_name=fsm
dns_svc_ip="$(kubectl get svc -n kube-system -l k8s-app=kube-dns -o jsonpath='{.items[0].spec.clusterIP}')"
fsm install \
    --mesh-name "$fsm_mesh_name" \
    --fsm-namespace "$fsm_namespace" \
    --set=fsm.certificateProvider.kind=tresor \
    --set=fsm.image.registry=${CTR_REGISTRY} \
    --set=fsm.image.tag=${CTR_TAG} \
    --set=fsm.image.pullPolicy=Always \
    --set=fsm.sidecarLogLevel=error \
    --set=fsm.controllerLogLevel=warn \
    --set=fsm.repoServer.image=${CTR_REGISTRY}/pipy-repo:${CTR_TAG} \
    --timeout=900s \
    --set=fsm.localDNSProxy.enable=true \
    --set=fsm.localDNSProxy.primaryUpstreamDNSServerIPAddr="${dns_svc_ip}"