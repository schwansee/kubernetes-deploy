#!/bin/bash

PACKAGE_PATH=$1
PACKAGE_PATH=${PACKAGE_PATH:-$HOME}

# Install openssh-client package
echo "Install openssh-client package"
sudo dpkg -i ${PACKAGE_PATH}/openssh-client_6.6p1-2ubuntu2.8_amd64.deb
