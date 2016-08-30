#!/bin/bash

TIMEOUT=60

if [ $# -lt 1 ]; then
  echo "Usage:   $0 <DOWNLOAD_PATH>"
  echo "Example: $0 $HOME/Downloads"
  exit 
else
  PARSE=`ls $1 >& /dev/null`
  if [ $? != 0 ]; then
    echo "Usage:   $0 <DOWNLOAD_PATH>"
    echo "Example: $0 $HOME/Downloads"
    exit 
  fi

  OUTPUT_PATH=$1
  echo "Download path: $OUTPUT_PATH"

  echo "get easy-rsa.tar.gz"
  if [ ! -f ${OUTPUT_PATH}/easy-rsa.tar.gz ]; then
    pushd `pwd`
    cd ${OUTPUT_PATH}
    curl -L -O https://sstorage.googleapis.com/kubernetes-release/easy-rsa/easy-rsa.tar.gz -m ${TIMEOUT}
    if [ $? -ne 0 ]; then
      echo && echo "easy-rsa download failed"
      popd
      exit
    fi
    popd
  fi

  echo "TODO: get etcd, flannel & kubernetes packages"

fi
