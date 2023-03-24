#!/bin/bash

kubectl create namespace demo
kubectl apply -n demo -f demo/sleep.yaml
