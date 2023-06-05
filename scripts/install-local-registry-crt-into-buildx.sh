#!/bin/bash

set -euo pipefail

echo -n | openssl s_client -showcerts -connect local.registry:443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > local.registry.crt
#sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain local.registry.crt

BUILDX=`docker ps | grep buildx_buildkit_ecnet0 | awk '{print $1}'`
if [ "${BUILDX}"z != ""z ]; then
  docker cp $BUILDX://etc/ssl/certs/ca-certificates.crt ca-certificates.crt
  cat local.registry.crt >> ca-certificates.crt
  docker cp ca-certificates.crt $BUILDX://etc/ssl/certs/ca-certificates.crt
  docker restart $BUILDX
fi

BUILDX=`docker ps | grep buildx_buildkit_fsm0 | awk '{print $1}'`
if [ "${BUILDX}"z != ""z ]; then
  docker cp $BUILDX://etc/ssl/certs/ca-certificates.crt ca-certificates.crt
  cat local.registry.crt >> ca-certificates.crt
  docker cp ca-certificates.crt $BUILDX://etc/ssl/certs/ca-certificates.crt
  docker restart $BUILDX
fi