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
  
  ##apt-transport-https 1.0.1ubuntu2.14
  ##https://launchpad.net/ubuntu/trusty/amd64/apt-transport-https/1.0.1ubuntu2.14
  wget http://launchpadlibrarian.net/260146303/apt-transport-https_1.0.1ubuntu2.14_amd64.deb -P ${OUTPUT_PATH}
  
  ##aufs-tools 1:3.2+20130722-1.1
  ##https://launchpad.net/ubuntu/+source/aufs-tools/1:3.2+20130722-1.1/+build/5854773
  wget https://launchpad.net/ubuntu/+source/aufs-tools/1:3.2+20130722-1.1/+build/5854773/+files/aufs-tools_3.2+20130722-1.1_amd64.deb
  
  ##ca-certificates 20160104ubuntu0.14.04.1
  ##https://launchpad.net/ubuntu/trusty/amd64/ca-certificates/20160104ubuntu0.14.04.1
  wget http://launchpadlibrarian.net/236986509/ca-certificates_20160104ubuntu0.14.04.1_all.deb -P ${OUTPUT_PATH}
  
  ##cgroup-lite 1.9
  ##https://launchpad.net/ubuntu/utopic/amd64/cgroup-lite/1.9
  wget http://launchpadlibrarian.net/171403674/cgroup-lite_1.9_all.deb -P ${OUTPUT_PATH}

  ##docker-engine 1.9.1
  ##https://apt.dockerproject.org/repo/pool/main/d/docker-engine
  wget https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_1.9.1-0~trusty_amd64.deb -P ${OUTPUT_PATH}
  
  ##libltdl7 2.4.2-1.7ubuntu1
  ##https://launchpad.net/ubuntu/trusty/amd64/libltdl7/2.4.2-1.7ubuntu1
  wget http://launchpadlibrarian.net/165627482/libltdl7_2.4.2-1.7ubuntu1_amd64.deb -P ${OUTPUT_PATH}
  
  ##libsystemd-journal0 204-5ubuntu20.19
  ##https://launchpad.net/ubuntu/trusty/amd64/libsystemd-journal0/204-5ubuntu20.19
  wget http://launchpadlibrarian.net/242858416/libsystemd-journal0_204-5ubuntu20.19_amd64.deb -P ${OUTPUT_PATH}
  
  ##linux-image-extra-virtual
  ##https://launchpad.net/ubuntu/trusty/+package/linux-image-extra-virtual
  wget http://launchpadlibrarian.net/273799511/linux-image-extra-virtual_3.13.0.93.100_amd64.deb -P ${OUTPUT_PATH}

fi
