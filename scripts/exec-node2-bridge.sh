#!/bin/bash

POD="$(kubectl get pod -n ecnet-system -l app=ecnet-bridge --field-selector spec.nodeName=node2 -o jsonpath='{.items[0].metadata.name}')"
kubectl exec -it ${POD} -n ecnet-system -c test -- bash