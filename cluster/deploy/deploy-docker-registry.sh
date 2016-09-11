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
  echo "run registry and expose 5000 port"
  sudo docker run -d -p 5000:5000 --restart=always --name registry registry:${DOCKER_REGISTRY_VERSION}
}

## 将镜像上传到docker私有库
function push_image_to_registry() {
  IMAGE_NAME=$1
  IMAGE_VERSION=$2

  echo "import specified image - ${IMAGE_NAME}-${IMAGE_VERSION}.tar"
  cat ${PACKAGE_PATH}/kubernetes/images/${IMAGE_NAME}-${IMAGE_VERSION} | sudo docker import - ${IMAGE_NAME}:${IMAGE_VERSION}

  echo "tag it and push to registry"
  docker tag ${IMAGE_NAME} localhost:5000/${IMAGE_NAME}
  docker push localhost:5000/${IMAGE_NAME}
}

## 删除registry
function uninstall_docker_registry() {
  ## 停止、删除registry容器
  echo "stop and remove registry container"
  sudo docker stop registry && docker rm -v registry

  ## 删除registry镜像
  echo "remove registry image"
  sudo docker rmi register:${DOCKER_REGISTRY_VERSION}
}
