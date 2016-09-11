#!/bin/bash

INSTALL_ROOT=$(dirname "${BASH_SOURCE}")

SCRIPT_PATH=$INSTALL_ROOT/deploy
ENV_FILE_NAME=deploy_env
source $SCRIPT_PATH/$ENV_FILE_NAME
roles_array=($roles)

function sed_config_default() {
  if [ ! -f $INSTALL_ROOT/ubuntu/config-default.sh.bak ]; then
    cp $INSTALL_ROOT/ubuntu/config-default.sh{,.bak}
  fi
  sed -i "s/nodes:\-.*/nodes:\-\"${nodes}\"}/g" $INSTALL_ROOT/ubuntu/config-default.sh
  sed -i "s/roles:\-.*/roles:\-\"${roles}\"}/g" $INSTALL_ROOT/ubuntu/config-default.sh
  sed -i "s/NUM_NODES:\-.*/NUM_NODES:\-\"${NUM_NODES}\"}/g" $INSTALL_ROOT/ubuntu/config-default.sh
}

function sed_download_release() {
  if [ ! -f $INSTALL_ROOT/ubuntu/download-release.sh.bak ]; then
    cp $INSTALL_ROOT/ubuntu/download-release.sh{,.bak}
  fi
  sed -i "/set \-e/a \$PACKAGE_PATH=\${PACKAGE_PATH:-\$HOME/dashboard_packages}" $INSTALL_ROOT/ubuntu/download-release.sh

  sed -i "/curl.*coreos\/flannel.*/d " $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "/tar xzf flannel.*/a if [ ! -d flannel-\${FLANNEL_VERSION} ]; then\n if [ ! -f \${PACKAGE_PATH}/kubernetes/flannel-\${FLANNEL_VERSION}-linux-amd64.tar.gz ]; then\n curl -L  https://github.com/coreos/flannel/releases/download/v\${FLANNEL_VERSION}/flannel-\${FLANNEL_VERSION}-linux-amd64.tar.gz -o flannel.tar.gz\n else\n cp \${PACKAGE_PATH}/kubernetes/flannel-\${FLANNEL_VERSION}-linux-amd64.tar.gz flannel.tar.gz\n fi\n tar xzf flannel.tar.gz\n fi\n" $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "$!N;/\n.*if.*flannel-\${FLANNEL_VERSION}/!P;D" $INSTALL_ROOT/ubuntu/download-release.sh

  sed -i "/curl.*coreos\/etcd*/d " $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "/tar xzf etcd.*/a if [ ! -d \${ETCD} ]; then\n if [ ! -f \${PACKAGE_PATH}/kubernetes/\${ETCD}.tar.gz ]; then curl -L https://github.com/coreos/etcd/releases/download/v\${ETCD_VERSION}/\${ETCD}.tar.gz -o etcd.tar.gz\n else\n cp \${PACKAGE_PATH}/kubernetes/\${ETCD}.tar.gz etcd.tar.gz\n fi\n tar xzf etcd.tar.gz\n fi\n" $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "$!N;/\n.*if.*-d \${ETCD}/!P;D" $INSTALL_ROOT/ubuntu/download-release.sh

  sed -i "/curl.*download\/v\${KUBE_VERSION}.*/d " $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "/tar xzf kubernetes.tar.gz/a if [ ! -d kubernetes ]; then\n if [ ! -f \${PACKAGE_PATH}/kubernetes/kubernetes-v\${KUBE_VERSION}.tar.gz ]; then\n curl -L https://github.com/kubernetes/kubernetes/releases/download/v\${KUBE_VERSION}/kubernetes.tar.gz -o kubernetes.tar.gz\n else\n cp \${PACKAGE_PATH}/kubernetes/kubernetes-v\${KUBE_VERSION}.tar.gz kubernetes.tar.gz\n fi\n tar xzf kubernetes.tar.gz\n fi\n" $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "$!N;/\n.*if.*-d kubernetes/!P;D" $INSTALL_ROOT/ubuntu/download-release.sh

  sed -i "s/rm -rf flannel.*/#rm -rf flannel* kubernetes* etcd*/g" $INSTALL_ROOT/ubuntu/download-release.sh
}

function sed_util() {
  if [ ! -f $INSTALL_ROOT/ubuntu/util.sh.bak ]; then
    cp $INSTALL_ROOT/ubuntu/util.sh{,.bak}
  fi

  sed -i "/curl.*easy-rsa/a PACKAGE_PATH=\${PACKAGE_PATH:-\$HOME/dashboard_packages}\n if [ ! -f easy-rsa.tar.gz ]; then\n if [ ! -f \${PACKAGE_PATH}/kubernetes/easy-rsa.tar.gz ]; then\n curl -L -O https://storage.googleapis.com/kubernetes-release/easy-rsa/easy-rsa.tar.gz > /dev/null 2>&1\n else\n cp \${PACKAGE_PATH}/kubernetes/easy-rsa.tar.gz .\n fi\n fi\n" $INSTALL_ROOT/ubuntu/util.sh
  sed -i "$!N;/.?*PACKAGE_PATH=.*/!P;D" $INSTALL_ROOT/ubuntu/util.sh
}

function sed_reconfDocker() {
  if [ ! -f $INSTALL_ROOT/ubuntu/reconfDocker.sh.bak ]; then
    cp $INSTALL_ROOT/ubuntu/reconfDocker.sh{,.bak}
  fi

  sed -i "/source \/etc\/default\/docker/d" $INSTALL_ROOT/ubuntu/reconfDocker.sh
}

function install_k8s() {
echo
}

#sed_config_default
#sed_download_release
#sed_util
#sed_reconfDocker
#install_k8s
