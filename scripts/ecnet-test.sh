#!/bin/bash

sleep_client="$(kubectl get pod -n demo -l app=sleep -o jsonpath='{.items[0].metadata.name}')"
kubectl exec ${sleep_client} -n demo -- curl -sI pipy-ok.pipy:8080