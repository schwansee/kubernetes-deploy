#!/bin/bash

PACKAGE_PATH=${PACKAGE_PATH:-/home/sieg/Downloads/dashboard/docker}
DOCKER_VERSION=${DOCKER_VERSION:-"1.9.1"}

echo "ensure that APT works with the https method, and that CA certificates are installed."
sudo dpkg -i ${PACKAGE_PATH}/apt-transport-https_1.0.1ubuntu2.14_amd64.deb
sudo dpkg -i ${PACKAGE_PATH}/ca-certificates_20160104ubuntu0.14.04.1_all.deb

echo "The linux-image-extra-* packages allows you use the aufs storage driver."
#TODO: specify a version or supply all versions
#sudo dpkg -i ${PACKAGE_PATH}/linux-image-extra-$(uname -r).deb
#sudo dpkg -i ${PACKAGE_PATH}/linux-image-extra-virtual_3.13.0.93.100_amd64.deb

echo "Purge the old repo if it exists."
sudo apt-get purge lxc-docker

echo "install extra packages:  aufs-tools cgroup-lite libltdl7 libsystemd-journal0"
#echo "install extra packages:  aufs-tools cgroup-lite libltdl7 libsystemd-journal0"
sudo dpkg -i ${PACKAGE_PATH}/aufs-tools_3.2+20130722-1.1_amd64.deb 
sudo dpkg -i ${PACKAGE_PATH}/cgroup-lite_1.9_all.deb
sudo dpkg -i ${PACKAGE_PATH}/libltdl7_2.4.2-1.7ubuntu1_amd64.deb
sudo dpkg -i ${PACKAGE_PATH}/libsystemd-journal0_204-5ubuntu20.19_amd64.deb
sudo dpkg -i ${PACKAGE_PATH}/docker-engine_1.9.1-0~trusty_amd64.deb

# Install Docker.
sudo dpkg -i ${PACKAGE_PATH}/docker-engine_${DOCKER_VERSION}-0~trusty_amd64.deb
