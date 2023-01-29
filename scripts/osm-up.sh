#!/bin/bash

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

export osm_namespace=osm-system
export osm_mesh_name=osm

osm install \
    --mesh-name "$osm_mesh_name" \
    --osm-namespace "$osm_namespace" \
    --set=osm.certificateProvider.kind=tresor \
    --set=osm.image.registry=${LOCAL_REGISTRY}/flomesh \
    --set=osm.image.tag=latest \
    --set=osm.image.pullPolicy=Always \
    --set=osm.sidecarLogLevel=error \
    --set=osm.controllerLogLevel=warn \
    --set=osm.repoServer.standalone=true \
    --set=osm.repoServer.ipaddr=192.168.127.91 \
    --set=osm.repoServer.codebase=v1.3.0 \
    --timeout=900s