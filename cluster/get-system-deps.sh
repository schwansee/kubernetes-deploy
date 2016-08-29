#!/bin/bash

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

  ##https://launchpad.net/ubuntu/trusty/+package/openssh-client
  wget http://launchpadlibrarian.net/278422678/openssh-client_6.6p1-2ubuntu2.8_amd64.deb -P ${OUTPUT_PATH}

fi
