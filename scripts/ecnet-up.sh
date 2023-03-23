#!/bin/bash

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

export ecnet_namespace=ecnet-system
export ecnet_mesh_name=ecnet
export dns_svc_ip="$(kubectl get svc -n kube-system -l k8s-app=kube-dns -o jsonpath='{.items[0].spec.clusterIP}')"
ecnet install \
    --mesh-name "$ecnet_mesh_name" \
    --ecnet-namespace "$ecnet_namespace" \
    --set=ecnet.image.registry=${LOCAL_REGISTRY}/flomesh \
    --set=ecnet.image.tag=latest \
    --set=ecnet.image.pullPolicy=Always \
    --set=ecnet.sidecarLogLevel=error \
    --set=ecnet.controllerLogLevel=warn \
    --set=ecnet.localDNSProxy.enable=true \
    --set=ecnet.localDNSProxy.primaryUpstreamDNSServerIPAddr="${dns_svc_ip}" \
    --timeout=900s