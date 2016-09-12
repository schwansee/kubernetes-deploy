#!/bin/bash

INSTALL_ROOT=$(dirname "${BASH_SOURCE}")

SCRIPT_DIRECTORY=deploy
SCRIPT_PATH=$INSTALL_ROOT/$SCRIPT_DIRECTORY
ENV_FILE_NAME=deploy_env 
source $SCRIPT_PATH/$ENV_FILE_NAME
roles_array=($roles)

function install_deps() {
##scp packages to remote servers
local ii=0
for i in $nodes; do
  nodeIP=${i#*@}
  echo $nodeIP
  echo $PACKAGE_PATH
  scp -r $INSTALL_ROOT/dashboard_packages $nodeIP:$PACKAGE_PATH/../ >& /dev/null
  scp -r $SCRIPT_PATH $nodeIP:$PACKAGE_PATH >& /dev/null
  ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_DIRECTORY && source $ENV_FILE_NAME && \
                source deploy-system-hosts.sh && \
                install_system_hosts"

  ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_DIRECTORY && source $ENV_FILE_NAME && \
                source deploy-system-deps.sh && \
                install_system_deps_dpkg"

  ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_DIRECTORY && source $ENV_FILE_NAME && \
                source deploy-docker-deps.sh && \
                install_docker_deps_dpkg"

  if [[ "${roles_array[${ii}]}" == "ai" || "${roles_array[${ii}]}" == "a" ]]; then
    echo ai or a
    ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_DIRECTORY && source $ENV_FILE_NAME && \
                  source deploy-docker-images.sh && \
                  load_images_basics && \
                  load_images_registry && \
                  load_images_heapster && \
                  load_images_dns && \
                  load_images_dashboard"
  else 
    echo i
    ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_DIRECTORY && source $ENV_FILE_NAME && \
                  source deploy-docker-images.sh && \
                  load_images_basics && \
                  load_images_registry && \
                  load_images_dns"

  fi

  ((ii=ii+1))
done
}

#install_deps
