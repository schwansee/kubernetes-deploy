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

  echo "get openssh-client"
  ##https://launchpad.net/ubuntu/trusty/+package/openssh-client
  wget http://launchpadlibrarian.net/278422678/openssh-client_6.6p1-2ubuntu2.8_amd64.deb -P ${OUTPUT_PATH}

  echo "get curl & libcurl3"
  ##https://launchpad.net/ubuntu/trusty/amd64/curl/7.35.0-1ubuntu2.8
  wget http://launchpadlibrarian.net/277306802/curl_7.35.0-1ubuntu2.8_amd64.deb -P ${OUTPUT_PATH}
  ##https://launchpad.net/ubuntu/trusty/amd64/libcurl3/7.35.0-1ubuntu2.8
  wget http://launchpadlibrarian.net/277306804/libcurl3_7.35.0-1ubuntu2.8_amd64.deb -P ${OUTPUT_PATH}

  echo "get bridge-utils"
  ##https://launchpad.net/ubuntu/trusty/amd64/bridge-utils/1.5-6ubuntu2
  wget http://launchpadlibrarian.net/162125746/bridge-utils_1.5-6ubuntu2_amd64.deb -P ${OUTPUT_PATH}

fi
