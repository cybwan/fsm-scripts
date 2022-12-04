## 1. OSM Edge Helm 部署

### 1.1 远程仓库部署

```bash
helm repo add osm-edge-ubi https://cybwan.github.io/osm-edge
helm repo update
export osm_namespace=osm-system 
export osm_mesh_name=osm
helm install --namespace "${osm_namespace}" "${osm_mesh_name}" osm-edge-ubi/osm-edge \
  --create-namespace --version=1.2.1-ubi8\
  --set=osm.certificateProvider.kind=tresor \
  --set=osm.image.pullPolicy=Always \
  --set=osm.sidecarLogLevel=error \
  --set=osm.controllerLogLevel=warn \
  --timeout=900s

helm test --namespace "${osm_namespace}" "${osm_mesh_name}"
helm uninstall --namespace "${osm_namespace}" "${osm_mesh_name}"
kubectl delete ns "${osm_namespace}"
```

### 1.2 本地仓库部署

```bash
helm install osm osm-edge/osm charts/osm

export osm_namespace=osm-system 
export osm_mesh_name=osm 
helm install --namespace "${osm_namespace}" "${osm_mesh_name}" charts/osm \
  --create-namespace \
  --set=osm.certificateProvider.kind=tresor \
  --set=osm.image.registry=quay.io/flomesh \
  --set=osm.image.tag=1.2.1 \
  --set=osm.image.pullPolicy=Always \
  --set=osm.sidecarLogLevel=error \
  --set=osm.controllerLogLevel=warn \
  --timeout=900s

helm test --namespace "${osm_namespace}" "${osm_mesh_name}"
helm uninstall --namespace "${osm_namespace}" "${osm_mesh_name}"
kubectl delete ns "${osm_namespace}"
```

### 1.3 Openshift-preflight

```bash
git clone https://github.com/redhat-openshift-ecosystem/openshift-preflight.git
cd openshift-preflight
make build
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-sidecar-init-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-controller-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-injector-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-crds-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-bootstrap-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-preinstall-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-healthcheck-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-demo-bookbuyer-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-demo-bookthief-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-demo-bookstore-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-demo-bookwarehouse-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-demo-tcp-echo-server-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
rm -rf artifacts;./preflight check container quay.io/flomesh/osm-edge-demo-tcp-client-ubi8:1.2.1 --certification-project-id=63875c63b841574ebfee2c4a --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
```

### 1.4 chart-verifier

```bash
docker run --rm                               \
-e KUBECONFIG=/.kube/config                   \
-v "${HOME}/.kube":/.kube                     \
-v $(pwd):/charts                             \
"quay.io/redhat-certification/chart-verifier" \
verify                                        \
/charts/osm
```

### 1.5 Refs

```
https://quay.io/user/flomesh
https://connect.redhat.com/projects/63875c63b841574ebfee2c4a/settings
```

