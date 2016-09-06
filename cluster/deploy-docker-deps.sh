#!/bin/bash

PACKAGE_PATH=${PACKAGE_PATH:-$HOME/dashboard_packages}
DOCKER_VERSION=${DOCKER_VERSION:-"1.9.1"}
  
function get_docker_deps_deb() {
  echo "Package path: $PACKAGE_PATH"
  
  ##apt-transport-https 1.0.1ubuntu2.14
  ##https://launchpad.net/ubuntu/trusty/amd64/apt-transport-https/1.0.1ubuntu2.14
  echo -n "get apt-transport-https"
  wget http://launchpadlibrarian.net/260146303/apt-transport-https_1.0.1ubuntu2.14_amd64.deb -P ${PACKAGE_PATH}/docker >& /dev/null 
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another download source for the package - apt-transport-https_1.0.1ubuntu2.14_amd64.deb"
    exit 110
  else
    echo " ... done"
  fi
  
  ##aufs-tools 1:3.2+20130722-1.1
  ##https://launchpad.net/ubuntu/+source/aufs-tools/1:3.2+20130722-1.1/+build/5854773
  echo -n "get aufs-tools"
  wget https://launchpad.net/ubuntu/+source/aufs-tools/1:3.2+20130722-1.1/+build/5854773/+files/aufs-tools_3.2+20130722-1.1_amd64.deb -P ${PACKAGE_PATH}/docker >& /dev/null
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another download source for the package - aufs-tools_3.2+20130722-1.1_amd64.deb"
    exit 110
  else
    echo " ... done"
  fi
  
  ##ca-certificates 20160104ubuntu0.14.04.1
  ##https://launchpad.net/ubuntu/trusty/amd64/ca-certificates/20160104ubuntu0.14.04.1
  echo -n "get ca-certificates"
  wget http://launchpadlibrarian.net/236986509/ca-certificates_20160104ubuntu0.14.04.1_all.deb -P ${PACKAGE_PATH}/docker >& /dev/null
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another download source for the package - ca-certificates_20160104ubuntu0.14.04.1_all.deb"
    exit 110
  else
    echo " ... done"
  fi
  
  ##cgroup-lite 1.9
  ##https://launchpad.net/ubuntu/utopic/amd64/cgroup-lite/1.9
  echo -n "get cgroup-lite"
  wget http://launchpadlibrarian.net/171403674/cgroup-lite_1.9_all.deb -P ${PACKAGE_PATH}/docker >& /dev/null
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another download source for the package - cgroup-lite_1.9_all.deb"
    exit 110
  else
    echo " ... done"
  fi

  ##docker-engine 1.9.1
  ##https://apt.dockerproject.org/repo/pool/main/d/docker-engine
  echo -n "get docker-engine"
  wget https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_1.9.1-0~trusty_amd64.deb -P ${PACKAGE_PATH}/docker >& /dev/null
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another download source for the package - docker-engine_1.9.1-0~trusty_amd64.deb"
    exit 110
  else
    echo " ... done"
  fi
  
  ##libltdl7 2.4.2-1.7ubuntu1
  ##https://launchpad.net/ubuntu/trusty/amd64/libltdl7/2.4.2-1.7ubuntu1
  echo -n "get libltdl7"
  wget http://launchpadlibrarian.net/165627482/libltdl7_2.4.2-1.7ubuntu1_amd64.deb -P ${PACKAGE_PATH}/docker >& /dev/null
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another download source for the package - libltdl7_2.4.2-1.7ubuntu1_amd64.deb"
    exit 110
  else
    echo " ... done"
  fi
  
  ##libsystemd-journal0 204-5ubuntu20.19
  ##https://launchpad.net/ubuntu/trusty/amd64/libsystemd-journal0/204-5ubuntu20.19
  echo -n "get libsystemd-journal0"
  wget http://launchpadlibrarian.net/242858416/libsystemd-journal0_204-5ubuntu20.19_amd64.deb -P ${PACKAGE_PATH}/docker >& /dev/null
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another download source for the package - libsystemd-journal0_204-5ubuntu20.19_amd64.deb"
    exit 110
  else
    echo " ... done"
  fi
  
  ##linux-image-extra-virtual
  ##https://launchpad.net/ubuntu/trusty/+package/linux-image-extra-virtual
  echo -n "get linux-image-extra-virtual"
  wget http://launchpadlibrarian.net/273799511/linux-image-extra-virtual_3.13.0.93.100_amd64.deb -P ${PACKAGE_PATH}
  if [ $? -ne 0 ]; then
    echo " ... failed"
    echo " please find another download source for the package - linux-image-exists-virtual_3.13.0.93.100_amd64.deb"
    exit 110
  else
    echo " ... done"
  fi
}

function install_docker_deps_apt() {
  ## Update package information, ensure that APT works with the https method, and that CA certificates are installed.
  sudo apt-get update
  sudo apt-get -y install apt-transport-https ca-certificates
  
  ## For Ubuntu Trusty, Wily, and Xenial, it’s recommended to install the linux-image-extra-* kernel packages. The linux-image-extra-* packages allows you use the aufs storage driver.
  sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
  
  ## Add the new GPG key.
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  
  ## Add docker entry
  echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' | sudo tee /etc/apt/sources.list.d/docker.list
  
  ## Update the APT package index.
  sudo apt-get update
  
  ## Purge the old repo if it exists.
  sudo apt-get purge lxc-docker
  
  ## Verify that APT is pulling from the right repository.
  sudo apt-cache policy docker-engine
  
  ## docker dependencies
  ##The following extra packages will be installed:
  ##  aufs-tools cgroup-lite libltdl7 libsystemd-journal0
  ##The following NEW packages will be installed:
  ##  aufs-tools cgroup-lite docker-engine libltdl7 libsystemd-journal0
  
  ## Install Docker.
  sudo apt-get -y install docker-engine
}

function install_docker_deps_dpkg() {
  echo "ensure that APT works with the https method, and that CA certificates are installed."
  sudo dpkg -i ${PACKAGE_PATH}/docker/apt-transport-https_1.0.1ubuntu2.14_amd64.deb
  sudo dpkg -i ${PACKAGE_PATH}/docker/ca-certificates_20160104ubuntu0.14.04.1_all.deb
  
  echo "The linux-image-extra-* packages allows you use the aufs storage driver."
  ##TODO: specify a version or supply all versions
  #sudo dpkg -i ${PACKAGE_PATH}/linux-image-extra-$(uname -r).deb
  #sudo dpkg -i ${PACKAGE_PATH}/linux-image-extra-virtual_3.13.0.93.100_amd64.deb
  
  echo "Purge the old repo if it exists."
  sudo apt-get purge lxc-docker
  
  echo "install extra packages:  aufs-tools cgroup-lite libltdl7 libsystemd-journal0"
  sudo dpkg -i ${PACKAGE_PATH}/docker/aufs-tools_3.2+20130722-1.1_amd64.deb 
  sudo dpkg -i ${PACKAGE_PATH}/docker/cgroup-lite_1.9_all.deb
  sudo dpkg -i ${PACKAGE_PATH}/docker/libltdl7_2.4.2-1.7ubuntu1_amd64.deb
  sudo dpkg -i ${PACKAGE_PATH}/docker/libsystemd-journal0_204-5ubuntu20.19_amd64.deb
  
  ## Install Docker.
  sudo dpkg -i ${PACKAGE_PATH}/docker/docker-engine_${DOCKER_VERSION}-0~trusty_amd64.deb
}

function uninstall_docker_deps() {
  ## Uninstall apt-transport-https ca-certificates are deprecated
  #echo "Uninstall apt-transport-https ca-certificates"
  #sudo apt-get -y remove --purge apt-transport-https ca-certificates

  ## Uninstall Docker and its extra packages
  echo "Uninstall aufs-tools cgroup-lite libltdl7 libsystemd-journal0 docker-engine"
  sudo apt-get remove --purge aufs-tools cgroup-lite docker-engine libltdl7 libsystemd-journal0
}
