## 1. FSM Edge Helm 部署

### 1.1 远程仓库部署

```bash
helm repo add fsme-ubi https://flomesh-io.github.io/fsme
helm repo update
export fsm_namespace=fsm-system 
export fsm_mesh_name=fsm
helm install --namespace "${fsm_namespace}" "${fsm_mesh_name}" fsme-ubi/fsme \
  --create-namespace --version=1.2.1-ubi8\
  --set=fsm.certificateProvider.kind=tresor \
  --set=fsm.image.pullPolicy=Always \
  --set=fsm.sidecarLogLevel=error \
  --set=fsm.controllerLogLevel=warn \
  --timeout=900s

helm test --namespace "${fsm_namespace}" "${fsm_mesh_name}"
helm uninstall --namespace "${fsm_namespace}" "${fsm_mesh_name}"
kubectl delete ns "${fsm_namespace}"
helm repo remove fsme-ubi
```

### 1.2 本地仓库部署

```bash
helm install fsm fsme/fsm charts/fsm

export fsm_namespace=fsm-system 
export fsm_mesh_name=fsm 
helm install --namespace "${fsm_namespace}" "${fsm_mesh_name}" charts/fsm \
  --create-namespace \
  --set=fsm.certificateProvider.kind=tresor \
  --set=fsm.image.registry=quay.io/flomesh \
  --set=fsm.image.tag=1.2.1 \
  --set=fsm.image.pullPolicy=Always \
  --set=fsm.sidecarLogLevel=error \
  --set=fsm.controllerLogLevel=warn \
  --timeout=900s

helm test --namespace "${fsm_namespace}" "${fsm_mesh_name}"
helm uninstall --namespace "${fsm_namespace}" "${fsm_mesh_name}"
kubectl delete ns "${fsm_namespace}"
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
./preflight check container quay.io/flomesh/fsme-sidecar-init-ubi8:1.2.1 --submit \
--certification-project-id=638dbc670ca4f41ef03b275c --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/fsme-controller-ubi8:1.2.1 --submit \
--certification-project-id=638dbb74613b29b39049d036 --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/fsme-injector-ubi8:1.2.1 --submit \
--certification-project-id=638dbbf18f037f9aec4de824 --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/fsme-crds-ubi8:1.2.1 --submit \
--certification-project-id=638dbc2b0ca4f41ef03b275b --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/fsme-bootstrap-ubi8:1.2.1 --submit \
--certification-project-id=638dbbbbb2b8873fc397ec16 --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/fsme-preinstall-ubi8:1.2.1 --submit \
--certification-project-id=638dbb340ca4f41ef03b2758 --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3

rm -rf artifacts
./preflight check container quay.io/flomesh/fsme-healthcheck-ubi8:1.2.1 --submit \
--certification-project-id=638de318b2b8873fc397ec27 --pyxis-api-token=nkfal7e1eyl2l0dicol2r7uiobpipws3
```

### 1.4 chart-verifier

```bash
git clone https://github.com/redhat-certification/chart-verifier
cd chart-verifier
chart-verifier verify https://flomesh-io.github.io/fsme/fsme-1.2.1-ubi8.tgz
```

### 1.5 Refs

```
https://quay.io/user/flomesh
https://connect.redhat.com/projects/63876fbeb98278bdad5b0d66/overview
```

