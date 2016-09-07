#!/bin/bash

DOWNLOAD_TIMEOUT=${DOWNLOAD_TIMEOUT:-60}

PACKAGE_PATH=${PACKAGE_PATH:-$HOME/dashboard_packages}

PAUSE_VERSION=${PAUSE_VERSION:-2.0}
ETCD_AMD64_VERSION=${ETCD_AMD64_VERSION:-2.2.1}
KUBE2SKY_VERSION=${KUBE2SKY_VERSION:-1.14}
SKYDNS_VERSION=${SKYDNS_VERSION:-2015-10-13-8c72f8c}
EXECHEALTHZ_VERSION=${EXECHEALTHZ_VERSION:-1.0}

DASHBOARD_VERSION=${DASHBOARD_VERSION:-1.0.0}

function get_kubernetes_deps_tar() {

  echo "Package path: ${PACKAGE_PATH}"

  echo "get easy-rsa.tar.gz"
  if [ ! -f ${PACKAGE_PATH}/easy-rsa.tar.gz ]; then
    pushd `pwd`
    cd ${PACKAGE_PATH}
    curl -L -O https://sstorage.googleapis.com/kubernetes-release/easy-rsa/easy-rsa.tar.gz -m ${DOWNLOAD_TIMEOUT} >& /dev/null
    if [ $? -ne 0 ]; then
      echo && echo "easy-rsa download failed"
      popd
      exit 110
    fi
    popd
  fi

  echo "TODO: get etcd, flannel & kubernetes packages here"
}

## 导入dns插件镜像, 导入顺序根据skydns-rc.yaml中的镜像下载顺序决定
function import_addons_images_dns() {
  cat ${PACKAGE_PATH}/kubernetes/images/pause-${PAUSE_VERSION}.tar             | sudo docker import - pause:${PAUSE_VERSION}
  cat ${PACKAGE_PATH}/kubernetes/images/etcd-amd64-${ETCD_AMD64_VERSION}.tar   | sudo docker import - etcd-amd64:${ETCD_AMD64_VERSION}
  cat ${PACKAGE_PATH}/kubernetes/images/kube2sky-${KUBE2SKY_VERSION}.tar       | sudo docker import - kube2sky:${KUBE2SKY_VERSION}
  cat ${PACKAGE_PATH}/kubernetes/images/skydns-${SKYDNS_VERSION}.tar           | sudo docker import - skydns:${SKYDNS_VERSION}
  cat ${PACKAGE_PATH}/kubernetes/images/exechealthz-${EXECHEALTHZ_VERSION}.tar | sudo docker import - exechealthz:${EXECHEALTHZ_VERSION}
} 

## 导入dashboard插件镜像
function import_addons_images_dashboard() {
  cat ${PACKAGE_PATH}/kubernetes/images/kubernetes-dashboard-amd64-v${DASHBOARD_VERSION}.tar | sudo docker import - kubernetes-dashboard-amd64:v${EXECHEALTHZ_VERSION}
}
