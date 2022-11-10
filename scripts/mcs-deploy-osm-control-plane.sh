#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

CTR_REGISTRY="${CTR_REGISTRY:-localhost:5000/flomesh}"
CTR_TAG="${CTR_TAG:-latest}"
BIZNESS_PLANE_CLUSTER="${BIZNESS_PLANE_CLUSTER:-cluster1}"

kubecm switch kind-${BIZNESS_PLANE_CLUSTER}
sleep 1
export osm_namespace=osm-system
export osm_mesh_name=osm
dns_svc_ip="$(kubectl get svc -n kube-system -l k8s-app=kube-dns -o jsonpath='{.items[0].spec.clusterIP}')"
osm install \
    --mesh-name "$osm_mesh_name" \
    --osm-namespace "$osm_namespace" \
    --set=osm.certificateProvider.kind=tresor \
    --set=osm.image.registry=${CTR_REGISTRY} \
    --set=osm.image.tag=${CTR_TAG} \
    --set=osm.image.pullPolicy=Always \
    --set=osm.sidecarLogLevel=error \
    --set=osm.controllerLogLevel=warn \
    --timeout=900s \
    --set=osm.localDNSProxy.enable=true \
    --set=osm.localDNSProxy.primaryUpstreamDNSServerIPAddr="${dns_svc_ip}"