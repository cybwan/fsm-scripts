## 1. OSM Edge Helm 部署

### 1.1 远程仓库部署

```bash
helm repo add osm-edge-ubi https://flomesh-io.github.io/osm-edge
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
helm repo remove osm-edge-ubi
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
docker run --rm --name preflight dokken/centos-stream-8 sleep 3600
docker exec -it preflight bash

yum install git -y
yum install golang -y
go env -w GOPROXY=https://goproxy.cn

git clone https://github.com/redhat-openshift-ecosystem/openshift-preflight.git
cd openshift-preflight
make build

rm -rf artifacts
./preflight check container quay.io/flomesh/osm-edge-sidecar-init-ubi8:1.2.1 --submit \
--certification-project-id=638dbc670ca4f41ef03b275c --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/osm-edge-controller-ubi8:1.2.1 --submit \
--certification-project-id=638dbb74613b29b39049d036 --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/osm-edge-injector-ubi8:1.2.1 --submit \
--certification-project-id=638dbbf18f037f9aec4de824 --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/osm-edge-crds-ubi8:1.2.1 --submit \
--certification-project-id=638dbc2b0ca4f41ef03b275b --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/osm-edge-bootstrap-ubi8:1.2.1 --submit \
--certification-project-id=638dbbbbb2b8873fc397ec16 --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/osm-edge-preinstall-ubi8:1.2.1 --submit \
--certification-project-id=638dbb340ca4f41ef03b2758 --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/osm-edge-healthcheck-ubi8:1.2.1 --submit \
--certification-project-id=638de318b2b8873fc397ec27 --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
```

### 1.4 chart-verifier

```bash
git clone https://github.com/redhat-certification/chart-verifier
cd chart-verifier
chart-verifier verify https://flomesh-io.github.io/osm-edge/osm-edge-1.2.1-ubi8.tgz
```

### 1.5 Refs

```
https://quay.io/user/flomesh
https://connect.redhat.com/projects/63876fbeb98278bdad5b0d66/overview
```

