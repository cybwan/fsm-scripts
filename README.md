# osm-edge-scripts

Set of helper scripts and `Makefile` targets to make life of [osm-edge](https://github.com/flomesh-io/osm-edge) developer easier. Bundled with dozens of shell scripts and Makefile targets.

## Usage Guide

> Assume you already have [osm-edge](https://github.com/flomesh-io/osm-edge) repository cloned or downloaded

1. Clone or zip download this repository
2. Place this repo at same level with [osm-edge](https://github.com/flomesh-io/osm-edge) cloned repository or set `OSM_HOME` environment variable to point to the location of `osm-edge` folder.
3. Run `make .env` to create `dot env` file and configure the contents to your specific needs
4. Run required `make target` (refer to below guide for make `targets` and description)
5. Sit back and relax 

## Quick Start

```
make .env
make load-images
make dev
make build
make kind-up
make demo-up
```

## Makefile Targets

Below is a non-exhaustive list of Makefile targets which can be used to automate the workload

## OSM_HOME

Environment variable to represent the location of [osm-edge](https://github.com/flomesh-io/osm-edge). When unset, scripts will try to find the `osm-edge` at same folder level with this repository folder.

## make load-images

Target to automatic download of
* [osm-edge](https://github.com/flomesh-io/osm-edge)
* [osm-edge demos](https://github.com/flomesh-io/osm-edge-demo)
* Docker images used for runing **e2e** test suits

Build containers (when required) and load them to local **kind-registry** running/listenong on `http://localhost:5000`

## make reload-flomesh-images

Target to automatic download `flomesh/pipy` image from [https://hub.docker.com/u/flomesh](https://hub.docker.com/u/flomesh). Useful when there is a change in the `pipy` image.

## make cache/cache-reset

Target to replace/reset [osm-edge](https://github.com/flomesh-io/osm-edge)  dependency docker images to point to local **kind-registry** registry for quicker compilation and initialization.

## make goproxy/goproxy-reset

Target to use China proxy for **golang** to accelerate the download speed of go packages and avoid GFW blockage issues.
**Note::** Suitable for developers located in China. But useful for developers who have **golang** proxy available in their region and/or offices to change the golang proxy settings to their specific urls.

## make autobuild-disable/autobuild-reset

Target to disable automatic building of images prior to running test case(s). Once disabled, developers are required to build images before running individual test case or whole test suite.

## make dev

Compositse target and combines **cache**、**goproxy**、**disable-autobuild** tasks.

## make build

Target to build **osm-edge** CLI and required docker images.

## make install-docker

Target to install **docker** 

## make install-k8s-tools

Target to install **docker** and **Kubernetes** required tools like `kubectl` etc.

## make install-golang

Target to install **golang** version `1.17.9`

> Note: For more targets please refer to [Makefile](Makefile)