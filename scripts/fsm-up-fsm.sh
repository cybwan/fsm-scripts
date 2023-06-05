#!/bin/bash

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

export fsm_namespace=fsm-system
export fsm_mesh_name=fsm

fsm install \
    --verbose \
    --mesh-name "$fsm_mesh_name" \
    --fsm-namespace "$fsm_namespace" \
    --set=fsm.certificateProvider.kind=tresor \
    --set=fsm.image.registry=${LOCAL_REGISTRY}/fsm \
    --set=fsm.image.tag=latest \
    --set=fsm.image.pullPolicy=Always \
    --set=fsm.enablePermissiveTrafficPolicy=true \
    --set=fsm.enableEgress=false \
    --set=fsm.enableReconciler=false \
    --set=fsm.controllerLogLevel=trace \
    --set=fsm.localProxyMode=Localhost \
    --timeout=90s