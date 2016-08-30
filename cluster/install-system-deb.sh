#!/bin/bash

PACKAGE_PATH=$1
PACKAGE_PATH=${PACKAGE_PATH:-$HOME}

# Install openssh-client package
echo "Install openssh-client package"
sudo dpkg -i ${PACKAGE_PATH}/openssh-client_6.6p1-2ubuntu2.8_amd64.deb

# Install curl & libcurl3 packages
echo "Install curl & libcurl3 packages"
sudo dpkg -i ${PACKAGE_PATH}/{curl_7.35.0-1ubuntu2.8_amd64.deb,libcurl3_7.35.0-1ubuntu2.8_amd64.deb}

# Install bridge-utils
echo "Install bridge-utils"
sudo dpkg -i ${PACKAGE_PATH}/bridge-utils_1.5-6ubuntu2_amd64.deb
