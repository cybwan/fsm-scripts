#!/bin/bash

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

export osm_namespace=osm-system
export osm_mesh_name=osm

osm install \
    --verbose \
    --mesh-name "$osm_mesh_name" \
    --osm-namespace "$osm_namespace" \
    --set=osm.certificateProvider.kind=tresor \
    --set=osm.image.registry=${LOCAL_REGISTRY}/flomesh \
    --set=osm.image.tag=latest \
    --set=osm.image.pullPolicy=Always \
    --set=osm.enablePermissiveTrafficPolicy=true \
    --set=osm.enableEgress=false \
    --set=osm.enableReconciler=false \
    --set=osm.envoyLogLevel=debug \
    --set=osm.controllerLogLevel=trace \
    --set=osm.localProxyMode=Localhost \
    --timeout=90s