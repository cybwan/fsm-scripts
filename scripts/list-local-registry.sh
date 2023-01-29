#!/bin/bash

set -uo pipefail

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

curl http://${LOCAL_REGISTRY}/v2/_catalog | jq

echo
IMG="flomesh/pipy"; echo "${IMG}";curl -I -s -XGET --header "Accept: application/vnd.docker.distribution.manifest.v2+json" http://${LOCAL_REGISTRY}/v2/"${IMG}"/manifests/latest  | awk '/Docker-Content-Digest/{print $NF}'
echo
IMG="flomesh/pipy-nightly"; echo "${IMG}"; curl  -I -s -XGET --header "Accept: application/vnd.docker.distribution.manifest.v2+json" http://${LOCAL_REGISTRY}/v2/"${IMG}"/manifests/latest  | awk '/Docker-Content-Digest/{print $NF}'
echo
IMG="flomesh/pipy-repo"; echo "${IMG}"; curl  -I -s -XGET --header "Accept: application/vnd.docker.distribution.manifest.v2+json" http://${LOCAL_REGISTRY}/v2/"${IMG}"/manifests/latest  | awk '/Docker-Content-Digest/{print $NF}'
echo
IMG="flomesh/pipy-repo-nightly"; echo "${IMG}"; curl  -I -s -XGET --header "Accept: application/vnd.docker.distribution.manifest.v2+json" http://${LOCAL_REGISTRY}/v2/"${IMG}"/manifests/latest  | awk '/Docker-Content-Digest/{print $NF}'

