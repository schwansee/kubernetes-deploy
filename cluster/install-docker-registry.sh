#!/bin/bash

PACKAGE_PATH=$1
PACKAGE_PATH=${PACKAGE_PATH:-$HOME}

DOCKER_REGISTRY_VERSION=${DOCKER_REGISTRY_VERSION:-2}

## 安装registry
function install_docker_registry() {
  ## 先从本地导入registry镜像
  echo "import registry image"
  cat ${PACKAGE_PATH}/kubernetes/images/registry-${DOCKER_REGISTRY_VERSION}.tar | sudo docker import - registry:${DOCKER_REGISTRY_VERSION}
  
  ## 再运行registry容器
  sudo docker run -d -p 5000:5000 --restart=always --name registry registry:${DOCKER_REGISTRY_VERSION}
}

## 删除registry
function uninstall_docker_registry() {
  ## 停止、删除registry容器
  sudo docker stop registry && docker rm -v registry

  ## 删除registry镜像
  sudo docker rmi register:${DOCKER_REGISTRY_VERSION}
}
