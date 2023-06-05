#!/bin/bash

kubectl create namespace error
fsm namespace add error
kubectl apply -n error -f yamls/error.yaml