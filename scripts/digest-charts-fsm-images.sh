#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

FSM_HOME=$1

OsmControllerDigest=$(docker buildx imagetools inspect "${CTR_REGISTRY}"/fsm-controller:"${CTR_TAG}" --raw | sha256sum | awk '{print $1}')
OsmInjectorDigest=$(docker buildx imagetools inspect "${CTR_REGISTRY}"/fsm-injector:"${CTR_TAG}" --raw | sha256sum | awk '{print $1}')
OsmInitDigest=$(docker buildx imagetools inspect "${CTR_REGISTRY}"/init:"${CTR_TAG}" --raw | sha256sum | awk '{print $1}')
OsmCrdsDigest=$(docker buildx imagetools inspect "${CTR_REGISTRY}"/fsm-crds:"${CTR_TAG}" --raw | sha256sum | awk '{print $1}')
OsmBootstrapDigest=$(docker buildx imagetools inspect "${CTR_REGISTRY}"/fsm-bootstrap:"${CTR_TAG}" --raw | sha256sum | awk '{print $1}')
OsmPreinstallDigest=$(docker buildx imagetools inspect "${CTR_REGISTRY}"/fsm-preinstall:"${CTR_TAG}" --raw | sha256sum | awk '{print $1}')
OsmHealthcheckDigest=$(docker buildx imagetools inspect "${CTR_REGISTRY}"/fsm-healthcheck:"${CTR_TAG}" --raw | sha256sum | awk '{print $1}')

sed -i "s#fsmController: \".*\"#fsmController: \"sha256:${OsmControllerDigest}\"#g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s/fsmInjector: \".*\"/fsmInjector: \"sha256:${OsmInjectorDigest}\"/g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s/fsmSidecarInit: \".*\"/fsmSidecarInit: \"sha256:${OsmInitDigest}\"/g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s/fsmCRDs: \".*\"/fsmCRDs: \"sha256:${OsmCrdsDigest}\"/g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s/fsmBootstrap: \".*\"/fsmBootstrap: \"sha256:${OsmBootstrapDigest}\"/g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s/fsmPreinstall: \".*\"/fsmPreinstall: \"sha256:${OsmPreinstallDigest}\"/g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s/fsmHealthcheck: \".*\"/fsmHealthcheck: \"sha256:${OsmHealthcheckDigest}\"/g" "${FSM_HOME}"/charts/fsm/values.yaml
