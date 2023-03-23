#!/bin/bash

set -euo pipefail

kubectl get ns -A --no-headers \
| awk '{print $1}' \
| sed '/^default/d' \
| sed '/^kube/d' \
| sed '/^flomesh/d' \
| sed '/^local-path-storage/d' \
| xargs kubectl delete ns
