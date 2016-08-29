#!/bin/bash

# Update package information, ensure that APT works with the https method, and that CA certificates are installed.
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates

# For Ubuntu Trusty, Wily, and Xenial, it’s recommended to install the linux-image-extra-* kernel packages. The linux-image-extra-* packages allows you use the aufs storage driver.
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual

# Add the new GPG key.
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Add docker entry
echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' | sudo tee /etc/apt/sources.list.d/docker.list

# Update the APT package index.
sudo apt-get update

# Purge the old repo if it exists.
sudo apt-get purge lxc-docker

# Verify that APT is pulling from the right repository.
sudo apt-cache policy docker-engine

# docker dependencies
#The following extra packages will be installed:
#  aufs-tools cgroup-lite libltdl7 libsystemd-journal0
#The following NEW packages will be installed:
#  aufs-tools cgroup-lite docker-engine libltdl7 libsystemd-journal0

# Install Docker.
sudo apt-get install docker-engine
