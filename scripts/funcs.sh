#!/bin/bash

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

function docker_io_images_to_local_registry() {
  typeset -a imgs=("$@")
  HUB="docker.io"

  for img in "${imgs[@]}"; do
    docker rmi "${img}" "${LOCAL_REGISTRY}/${img}"
  done

  docker container prune -f
  docker volume prune -f
  docker image prune -f

  REGPOD="$(docker ps --filter 'name=kind-registry' |tail -n 1| awk 'NR==1{print $1}')"
  docker exec $REGPOD  bin/registry garbage-collect /etc/docker/registry/config.yml >> /dev/null

  for img in "${imgs[@]}"; do
    docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories/${img}
  done
  docker restart $REGPOD

  for img in "${imgs[@]}"; do
    docker pull ${HUB}/${img}
  done

  for img in "${imgs[@]}"; do
    docker tag ${HUB}/${img} ${LOCAL_REGISTRY}/${img}
  done

  for img in "${imgs[@]}"; do
    docker push ${LOCAL_REGISTRY}/${img}
  done

  for img in "${imgs[@]}"; do
    docker rmi "${img}" "${LOCAL_REGISTRY}/${img}"
  done

  docker container prune -f
  docker volume prune -f
  docker image prune -f
}

function quay_io_images_to_local_registry() {
  typeset -a imgs=("$@")
  HUB="quay.io"

  for img in "${imgs[@]}"; do
    docker rmi "${img}" "${LOCAL_REGISTRY}/${img}"
  done

  docker container prune -f
  docker volume prune -f
  docker image prune -f

  REGPOD="$(docker ps --filter 'name=kind-registry' |tail -n 1| awk 'NR==1{print $1}')"
  docker exec $REGPOD  bin/registry garbage-collect /etc/docker/registry/config.yml >> /dev/null

  for img in "${imgs[@]}"; do
    docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories/${img}
  done
  docker restart $REGPOD

  for img in "${imgs[@]}"; do
    docker pull ${HUB}/${img}
  done

  for img in "${imgs[@]}"; do
    docker tag ${HUB}/${img} ${LOCAL_REGISTRY}/${img}
  done

  for img in "${imgs[@]}"; do
    docker push ${LOCAL_REGISTRY}/${img}
  done

  for img in "${imgs[@]}"; do
    docker rmi "${img}" "${LOCAL_REGISTRY}/${img}"
  done

  docker container prune -f
  docker volume prune -f
  docker image prune -f
}

function gcr_io_images_to_local_registry() {
  typeset -a imgs=("$@")
  HUB="gcr.io"

  for img in "${imgs[@]}"; do
    docker rmi "${img}" "${LOCAL_REGISTRY}/${img}"
  done

  docker container prune -f
  docker volume prune -f
  docker image prune -f

  REGPOD="$(docker ps --filter 'name=kind-registry' |tail -n 1| awk 'NR==1{print $1}')"
  docker exec $REGPOD  bin/registry garbage-collect /etc/docker/registry/config.yml >> /dev/null

  for img in "${imgs[@]}"; do
    docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories/${img}
  done
  docker restart $REGPOD

  for img in "${imgs[@]}"; do
    docker pull ${HUB}/${img}
  done

  for img in "${imgs[@]}"; do
    docker tag ${HUB}/${img} ${LOCAL_REGISTRY}/${img}
  done

  for img in "${imgs[@]}"; do
    docker push ${LOCAL_REGISTRY}/${img}
  done

  for img in "${imgs[@]}"; do
    docker rmi "${img}" "${LOCAL_REGISTRY}/${img}"
  done

  docker container prune -f
  docker volume prune -f
  docker image prune -f
}