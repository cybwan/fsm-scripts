#!/bin/bash

set -euo pipefail


git clone https://github.com/ahmetb/gen-crd-api-reference-docs.git
cd gen-crd-api-reference-docs
go build
/Users/baili/go/src/github.com/cybwan/gen-crd-api-reference-docs/gen-crd-api-reference-docs


gen-crd-api-reference-docs \
-config $FSM/docs/api_reference/config.json \
-template-dir /Users/baili/go/src/github.com/cybwan/gen-crd-api-reference-docs/template/ \
-api-dir "github.com/openservicemesh/fsm/pkg/apis/config/v1alpha1" \
-out-file $FSMDOCS/content/en/docs/api_reference/config/v1alpha1.md


gen-crd-api-reference-docs \
-config $FSM/docs/api_reference/config.json \
-template-dir /Users/baili/go/src/github.com/cybwan/gen-crd-api-reference-docs/template/ \
-api-dir "github.com/openservicemesh/fsm/pkg/apis/config/v1alpha2" \
-out-file $FSMDOCS/content/en/docs/api_reference/config/v1alpha2.md


gen-crd-api-reference-docs \
-config $FSM/docs/api_reference/config.json \
-template-dir /Users/baili/go/src/github.com/cybwan/gen-crd-api-reference-docs/template/ \
-api-dir "github.com/openservicemesh/fsm/pkg/apis/policy/v1alpha1" \
-out-file $FSMDOCS/content/en/docs/api_reference/policy/v1alpha1.md


gen-crd-api-reference-docs \
-config $FSM/docs/api_reference/config.json \
-template-dir /Users/baili/go/src/github.com/cybwan/gen-crd-api-reference-docs/template/ \
-api-dir "github.com/openservicemesh/fsm/pkg/apis/plugin/v1alpha1" \
-out-file $FSMDOCS/content/en/docs/api_reference/plugin/v1alpha1.md

gen-crd-api-reference-docs \
-config $FSM/docs/api_reference/config.json \
-template-dir /Users/baili/go/src/github.com/cybwan/gen-crd-api-reference-docs/template/ \
-api-dir "github.com/openservicemesh/fsm/pkg/apis/networking/v1" \
-out-file $FSMDOCS/content/en/docs/api_reference/networking/v1.md

gen-crd-api-reference-docs \
-config $FSM/docs/api_reference/config.json \
-template-dir /Users/baili/go/src/github.com/cybwan/gen-crd-api-reference-docs/template/ \
-api-dir "github.com/openservicemesh/fsm/pkg/apis/multicluster/v1alpha1" \
-out-file $FSMDOCS/content/en/docs/api_reference/multicluster/v1alpha1.md