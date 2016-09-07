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

  echo -n "get easy-rsa.tar.gz"
  if [ ! -f ${PACKAGE_PATH}/kubernetes/easy-rsa.tar.gz ]; then
    pushd `pwd` >& /dev/null
    cd ${PACKAGE_PATH}
    curl -L -O https://sstorage.googleapis.com/kubernetes-release/easy-rsa/easy-rsa.tar.gz -m ${DOWNLOAD_TIMEOUT} >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - easy-rsa.tar.gz"
      echo " download it and put it to the path: ${PACKAGE_PATH}/kubernetes"
      popd >& /dev/null
      exit 110
    else
      popd >& /dev/null
    fi
  fi
  echo " ... done"

  echo -n "get flannel"
  if [ ! -f ${PACKAGE_PATH}/kubernetes/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz ]; then
    wget https://github.com/coreos/flannel/releases/download/v${FLANNEL_VERSION}/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz -P ${PACKAGE_PATH}/kubernetes >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz"
      echo " download it and put it to the path: ${PACKAGE_PATH}/kubernetes"
      exit 110
    fi
  fi
  echo " ... done"

  echo -n "get etcd"
  if [ ! -f ${PACKAGE_PATH}/kubernetes/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz ]; then
    wget https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etc-v${ETCD_VERSION}-linux-amd64.tar.gz -P ${PACKAGE_PATH}/kubernetes >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - etcd-v${ETCD_VERSION}-linux-amd64.tar.gz"
      echo " download it and put it to the path: ${PACKAGE_PATH}/kubernetes"
      exit 110
    fi
  fi
  echo " ... done"

  echo -n "get kubernetes"
  if [ ! -f ${PACKAGE_PATH}/kubernetes/kubernetes-v${KUBE_VERSION}.tar.gz ]; then
    wget https://github.com/kubernetes/kubernetes/releases/download/v${KUBE_VERSION}/kubernetes.tar.gz -O kubernetes-v${KUBE_VERSION}.tar.gz -P ${PACKAGE_PATH}/kubernetes >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - kubernetes-v${KUBE_VERSION}.tar.gz"
      echo " download it and put it to the path: ${PACKAGE_PATH}/kubernetes"
      exit 110
    fi
  fi
  echo " ... done"
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
