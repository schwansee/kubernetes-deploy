#!/bin/bash

INSTALL_ROOT=$(dirname "${BASH_SOURCE}")

SCRIPT_DIRECTORY=deploy
SCRIPT_PATH=$INSTALL_ROOT/$SCRIPT_DIRECTORY
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
  sed -i "/set \-e/a PACKAGE_PATH=\${PACKAGE_PATH:-\$HOME/dashboard_packages}" $INSTALL_ROOT/ubuntu/download-release.sh

  sed -i "/curl.*coreos\/flannel.*/d " $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "/tar xzf flannel.*/a if [ ! -d flannel-\${FLANNEL_VERSION} ]; then\n if [ ! -f \${PACKAGE_PATH}/kubernetes/flannel-\${FLANNEL_VERSION}-linux-amd64.tar.gz ]; then\n curl -L  https://github.com/coreos/flannel/releases/download/v\${FLANNEL_VERSION}/flannel-\${FLANNEL_VERSION}-linux-amd64.tar.gz -o flannel.tar.gz\n else\n cp \${PACKAGE_PATH}/kubernetes/flannel-\${FLANNEL_VERSION}-linux-amd64.tar.gz flannel.tar.gz\n fi\n tar xzf flannel.tar.gz\n fi\n" $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "$!N;/\n.*if.*-d flannel-\${FLANNEL_VERSION}/!P;D" $INSTALL_ROOT/ubuntu/download-release.sh

  sed -i "/curl.*coreos\/etcd*/d " $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "/tar xzf etcd.*/a if [ ! -d \${ETCD} ]; then\n if [ ! -f \${PACKAGE_PATH}/kubernetes/\${ETCD}.tar.gz ]; then curl -L https://github.com/coreos/etcd/releases/download/v\${ETCD_VERSION}/\${ETCD}.tar.gz -o etcd.tar.gz\n else\n cp \${PACKAGE_PATH}/kubernetes/\${ETCD}.tar.gz etcd.tar.gz\n fi\n tar xzf etcd.tar.gz\n fi\n" $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "$!N;/\n.*if.*-d \${ETCD}/!P;D" $INSTALL_ROOT/ubuntu/download-release.sh

  sed -i "/curl.*download\/v\${KUBE_VERSION}.*/d " $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "/tar xzf kubernetes.tar.gz/a if [ ! -d kubernetes ]; then\n if [ ! -f \${PACKAGE_PATH}/kubernetes/kubernetes-v\${KUBE_VERSION}.tar.gz ]; then\n curl -L https://github.com/kubernetes/kubernetes/releases/download/v\${KUBE_VERSION}/kubernetes.tar.gz -o kubernetes.tar.gz\n else\n cp \${PACKAGE_PATH}/kubernetes/kubernetes-v\${KUBE_VERSION}.tar.gz kubernetes.tar.gz\n fi\n tar xzf kubernetes.tar.gz\n fi\n" $INSTALL_ROOT/ubuntu/download-release.sh
  sed -i "$!N;/\n.*if.*-d kubernetes/!P;D" $INSTALL_ROOT/ubuntu/download-release.sh

  sed -i "s/rm -rf flannel* kubernetes* etcd*\n/#rm -rf flannel* kubernetes* etcd*\n/g" $INSTALL_ROOT/ubuntu/download-release.sh
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

function install_k8s_cluster() {
  local ii=0
  for i in $nodes; do
    nodeIP=${i#*@}
    if [[ "${roles_array[${ii}]}" == "ai" || "${roles_array[${ii}]}" == "a" ]]; then
      echo "cp kubectl binary"
      scp $INSTALL_ROOT/ubuntu/kubectl $nodeIP:/usr/local/bin >& /dev/null
      break
    fi
    ((ii=ii+1))
  done

  bash -c "source $SCRIPT_PATH/$ENV_FILE_NAME && $INSTALL_ROOT/kube-up.sh"
echo
}

function install_k8s_dns_dashboard() {
  ADDONS_SCRIPT_DIRECTORY=cluster
  ADDONS_SCRIPT_PATH=$SCRIPT_PATH/$ADDONS_SCRIPT_DIRECTORY

  if [ ! -d $ADDONS_SCRIPT_PATH ]; then
    mkdir -p $ADDONS_SCRIPT_PATH/{addons,skeleton,ubuntu}
    ## copy all scripts under ./cluster directory with depth=1
    cp $INSTALL_ROOT/*.sh $ADDONS_SCRIPT_PATH
    ## copy dns & dashboard directories
    cp -r $INSTALL_ROOT/addons/{dns,dashboard} $ADDONS_SCRIPT_PATH/addons
    ## copy all scripts under ./cluster/skeleton directory
    cp $INSTALL_ROOT/skeleton/* $ADDONS_SCRIPT_PATH/skeleton
    
    ## select some useful stuff under ./cluster/ubuntu directory
    ## copy all scripts under ./cluster/ubuntu directory with depth=1
    cp $INSTALL_ROOT/ubuntu/*.sh $ADDONS_SCRIPT_PATH/ubuntu
    ## copy kubectl binary under ./cluster/ubuntu/binaries directory
    mkdir -p $ADDONS_SCRIPT_PATH/ubuntu/binaries
    cp $INSTALL_ROOT/ubuntu/binaries/kubectl $ADDONS_SCRIPT_PATH/ubuntu/binaries
    ## copy namespace.yaml
    cp $INSTALL_ROOT/ubuntu/namespace.yaml $ADDONS_SCRIPT_PATH/ubuntu
  fi  

  local ii=0
  for i in $nodes; do
    nodeIP=${i#*@}
    if [[ "${roles_array[${ii}]}" == "ai" || "${roles_array[${ii}]}" == "a" ]]; then
      echo ai or a $nodeIP
      scp -r $ADDONS_SCRIPT_PATH $nodeIP:$PACKAGE_PATH/$SCRIPT_DIRECTORY >& /dev/null
      ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_DIRECTORY && source $ENV_FILE_NAME && \
                    cd $ADDONS_SCRIPT_DIRECTORY/ubuntu && \
                    ./deployAddons.sh"
      break
    fi
    ((ii=ii+1))
  done
}

function install_k8s_heapster() {
  HEAPSTER_SCRIPT_DIRECTORY=heapster
  HEAPSTER_SCRIPT_PATH=$SCRIPT_PATH/$HEAPSTER_SCRIPT_DIRECTORY

  ## copy the origin files to script directory
  cp -r $INSTALL_ROOT/$HEAPSTER_SCRIPT_DIRECTORY $SCRIPT_PATH

  local ii=0
  for i in $nodes; do
    nodeIP=${i#*@}
    if [[ "${roles_array[${ii}]}" == "ai" || "${roles_array[${ii}]}" == "a" ]]; then
      echo ai or a $nodeIP

      ## sed heapster-controller.yaml
      sed -i "s/ imagePullPolicy/# imagePullPolicy/g" $HEAPSTER_SCRIPT_PATH/heapster-controller.yaml
      sed -i "s/kubernetes.default/$nodeIP:8080\?inClusterConfig=false\&useServiceAccount=false/g" $HEAPSTER_SCRIPT_PATH/heapster-controller.yaml
      sed -i "s/monitoring-influxdb/$nodeIP/g" $HEAPSTER_SCRIPT_PATH/heapster-controller.yaml

      ## sed influxdb-grafana-controller.yaml
      sed -i "/heapster_influxdb/a \ \ \ \ \ \ \ \ ports:\n        - containerPort: 8086\n          hostPort: 8086\n        - containerPort: 8083\n          hostPort: 8083" $HEAPSTER_SCRIPT_PATH/influxdb-grafana-controller.yaml
      sed -i "s/monitoring-influxdb/$nodeIP/g" $HEAPSTER_SCRIPT_PATH/influxdb-grafana-controller.yaml

      ## it may be wrong, we should expose host port 8086
      ## sed influxdb-service.yaml
      #sed -i "/targetPort: 8086/d " $HEAPSTER_SCRIPT_PATH/influxdb-service.yaml

      scp -r $HEAPSTER_SCRIPT_PATH $nodeIP:$PACKAGE_PATH/$SCRIPT_DIRECTORY >& /dev/null
      ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_DIRECTORY && source $ENV_FILE_NAME && \
                    kubectl create -f $HEAPSTER_SCRIPT_DIRECTORY"

      break
    fi
    ((ii=ii+1))
  done
}

#sed_config_default
#sed_download_release
#sed_util
#sed_reconfDocker

#install_k8s_cluster
#install_k8s_dns_dashboard
#install_k8s_heapster
