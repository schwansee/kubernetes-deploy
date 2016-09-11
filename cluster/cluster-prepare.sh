#!/bin/bash

INSTALL_ROOT=$(dirname "${BASH_SOURCE}")

SCRIPT_PATH=$INSTALL_ROOT/deploy
ENV_FILE_NAME=deploy_env
source $SCRIPT_PATH/$ENV_FILE_NAME

##scp packages to remote servers
for i in $nodes; do
  nodeIP=${i#*@}
  #scp -r $SCRIPT_PATH $PACKAGE_PATH $nodeIP:$PACKAGE_PATH >& /dev/null
  scp -r $SCRIPT_PATH $nodeIP:$PACKAGE_PATH >& /dev/null
#  ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_PATH && source $ENV_FILE_NAME && \
#                source deploy-system-hosts.sh && \
#                install_system_hosts"
#
#  ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_PATH && source $ENV_FILE_NAME && \
#                source deploy-system-deps.sh && \
#                install_system_deps_dpkg"
#
#  ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_PATH && source $ENV_FILE_NAME && \
#                source deploy-docker-deps.sh && \
#                install_docker_deps_dpkg"
#
  ssh $nodeIP "cd $PACKAGE_PATH/$SCRIPT_PATH && source $ENV_FILE_NAME && \
                source deploy-docker-images.sh && \
                load_images_separately"
done
