#!/bin/bash

PACKAGE_PATH=${PACKAGE_PATH:-$HOME/dashboard_packages}

function get_system_deps_deb() {
  echo "Package path: $PACKAGE_PATH"

  echo -n "get openssh-client"
  if [ ! -f ${PACKAGE_PATH}/system/openssh-client_6.6p1-2ubuntu2.8_amd64.deb ]; then
    ##https://launchpad.net/ubuntu/trusty/+package/openssh-client
    wget http://launchpadlibrarian.net/278422678/openssh-client_6.6p1-2ubuntu2.8_amd64.deb -P ${PACKAGE_PATH}/system >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - openssh-client_6.6p1-2ubuntu2.8_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/system"
      exit 110
    fi
  fi
  echo " ... done"

  echo -n "get curl"
  if [ ! -f ${PACKAGE_PATH}/system/curl_7.35.0-1ubuntu2.8_amd64.deb ]; then
    ##https://launchpad.net/ubuntu/trusty/amd64/curl/7.35.0-1ubuntu2.8
    wget http://launchpadlibrarian.net/277306802/curl_7.35.0-1ubuntu2.8_amd64.deb -P ${PACKAGE_PATH}/system >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - curl_7.35.0-1ubuntu2.8_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/system"
      exit 110
    fi
  fi
  echo " ... done"
 
  echo -n "get libcurl3"
  if [ ! -f ${PACKAGE_PATH}/system/libcurl3_7.35.0-1ubuntu2.8_amd64.deb ]; then
    ##https://launchpad.net/ubuntu/trusty/amd64/libcurl3/7.35.0-1ubuntu2.8
    wget http://launchpadlibrarian.net/277306804/libcurl3_7.35.0-1ubuntu2.8_amd64.deb -P ${PACKAGE_PATH}/system >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - libcurl3_7.35.0-1ubuntu2.8_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/system"
      exit 110
    fi
  fi
  echo " ... done"


  echo -n "get bridge-utils"
  if [ ! -f ${PACKAGE_PATH}/system/bridge-utils_1.5-6ubuntu2_amd64.deb ]; then
    ##https://launchpad.net/ubuntu/trusty/amd64/bridge-utils/1.5-6ubuntu2
    wget http://launchpadlibrarian.net/162125746/bridge-utils_1.5-6ubuntu2_amd64.deb -P ${PACKAGE_PATH}/system >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - bridge-utils_1.5-6ubuntu2_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/system"
      exit 110
    fi
  fi
  echo " ... done"
}

function install_system_deps_apt() {
  echo "Install openssh-client"
  sudo apt-get -y install openssh-client
  
  echo "Install curl & libcurl3"
  sudo apt-get -y install curl libcurl3
  
  echo "Install bridge-utils"
  sudo apt-get -y install bridge-utils
}

function install_system_deps_dpkg() {
  echo -n "Install openssh-client package"
  sudo dpkg -i ${PACKAGE_PATH}/system/openssh-client_6.6p1-2ubuntu2.8_amd64.deb >& /dev/null
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another resource for the package - openssh-client_6.6p1-2ubuntu2.8_amd64.deb"
    echo " download it and put it to the path: ${PACKAGE_PATH}/system"
    exit 125
  fi
  echo " ... done"
 
  echo -n "Install curl & libcurl3 packages"
  sudo dpkg -i ${PACKAGE_PATH}/system/{curl_7.35.0-1ubuntu2.8_amd64.deb,libcurl3_7.35.0-1ubuntu2.8_amd64.deb} >& /dev/null
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another resource for the package - curl_7.35.0-1ubuntu2.8_amd64.deb and libcurl3_7.35.0-1ubuntu2.8_amd64.deb"
    echo " download it and put it to the path: ${PACKAGE_PATH}/system"
    exit 125
  fi
  echo " ... done"
  
  echo -n "Install bridge-utils"
  sudo dpkg -i ${PACKAGE_PATH}/system/bridge-utils_1.5-6ubuntu2_amd64.deb >& /dev/null
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another resource for the package - bridge-utils_1.5-6ubuntu2_amd64.deb"
    echo " download it and put it to the path: ${PACKAGE_PATH}/system"
    exit 125
  fi
  echo " ... done"
}

function uninstall_system_deps() {
  ## Uninstall openssh-client is deprecated
  # sudo apt-get -y remove --purge openssh-client

  # Uninstall curl libcurl3 bridge-utils
  echo "Uninstall curl libcurl3 bridge-utils"
  sudo apt-get -y remove --purge curl libcurl3 bridge-utils
}
