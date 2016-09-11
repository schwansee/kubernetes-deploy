#!/bin/bash

# Copyright 2015 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Download the etcd, flannel, and K8s binaries automatically and stored in binaries directory
# Run as root only

# author @resouer @WIZARD-CXY
set -e

PACKAGE_PATH=${PACKAGE_PATH:-$HOME}

function cleanup {
  # cleanup work
  rm -rf flannel* kubernetes* etcd* binaries
}
trap cleanup SIGHUP SIGINT SIGTERM

pushd $(dirname $0)
mkdir -p binaries/master
mkdir -p binaries/minion

# flannel
FLANNEL_VERSION=${FLANNEL_VERSION:-"0.5.5"}
echo "Prepare flannel ${FLANNEL_VERSION} release ..."
grep -q "^${FLANNEL_VERSION}\$" binaries/.flannel 2>/dev/null || {
  if [ ! -d flannel-${FLANNEL_VERSION} ]; then
    if [ ! -f ${PACKAGE_PATH}/kubernetes/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz ]; then
      curl -L  https://github.com/coreos/flannel/releases/download/v${FLANNEL_VERSION}/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz -o flannel.tar.gz
    else
      cp ${PACKAGE_PATH}/kubernetes/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz flannel.tar.gz
    fi
    tar xzf flannel.tar.gz
  fi
  cp flannel-${FLANNEL_VERSION}/flanneld binaries/master
  cp flannel-${FLANNEL_VERSION}/flanneld binaries/minion
  echo ${FLANNEL_VERSION} > binaries/.flannel
}

# ectd
ETCD_VERSION=${ETCD_VERSION:-"2.2.1"}
ETCD="etcd-v${ETCD_VERSION}-linux-amd64"
echo "Prepare etcd ${ETCD_VERSION} release ..."
grep -q "^${ETCD_VERSION}\$" binaries/.etcd 2>/dev/null || {
  if [ ! -d ${ETCD} ]; then
    if [ ! -f ${PACKAGE_PATH}/kubernetes/${ETCD}.tar.gz ]; then
      curl -L https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/${ETCD}.tar.gz -o etcd.tar.gz
    else
      cp ${PACKAGE_PATH}/kubernetes/${ETCD}.tar.gz etcd.tar.gz
    fi
    tar xzf etcd.tar.gz
  fi
  cp ${ETCD}/etcd ${ETCD}/etcdctl binaries/master
  echo ${ETCD_VERSION} > binaries/.etcd
}

# k8s
KUBE_VERSION=${KUBE_VERSION:-"1.1.8"}
echo "Prepare kubernetes ${KUBE_VERSION} release ..."
grep -q "^${KUBE_VERSION}\$" binaries/.kubernetes 2>/dev/null || {
  if [ ! -d kubernetes ]; then
    if [ ! -f ${PACKAGE_PATH}/kubernetes/kubernetes-v${KUBE_VERSION}.tar.gz ]; then
      curl -L https://github.com/kubernetes/kubernetes/releases/download/v${KUBE_VERSION}/kubernetes.tar.gz -o kubernetes.tar.gz
    else
      cp ${PACKAGE_PATH}/kubernetes/kubernetes-v${KUBE_VERSION}.tar.gz kubernetes.tar.gz
    fi
    tar xzf kubernetes.tar.gz
  fi

  pushd kubernetes/server
  tar xzf kubernetes-server-linux-amd64.tar.gz
  popd
  cp kubernetes/server/kubernetes/server/bin/kube-apiserver \
     kubernetes/server/kubernetes/server/bin/kube-controller-manager \
     kubernetes/server/kubernetes/server/bin/kube-scheduler binaries/master
  cp kubernetes/server/kubernetes/server/bin/kubelet \
     kubernetes/server/kubernetes/server/bin/kube-proxy binaries/minion
  cp kubernetes/server/kubernetes/server/bin/kubectl binaries/
  echo ${KUBE_VERSION} > binaries/.kubernetes
}

## 注释该行: 不删除安装包，无须重复拷贝解压
#rm -rf flannel* kubernetes* etcd*

echo "Done! All your binaries locate in kubernetes/cluster/ubuntu/binaries directory"
popd
