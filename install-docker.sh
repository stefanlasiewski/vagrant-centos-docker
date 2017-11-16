#!/usr/bin/env bash

# Install Docker on CentOS 7 per
# https://docs.docker.com/engine/installation/linux/docker-ce/centos/

set -e # Exit if any subcommand fails
set -x # Print commands for troubleshooting

# 1. Install required packages.

sudo yum install --assumeyes --quiet yum-utils \
  device-mapper-persistent-data \
  lvm2

# 2. Use the following command to set up the stable repository. You always need the stable repository, even if you want to install builds from the edge or test repositories as well.

sudo yum-config-manager --quiet \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# 3. Optional: Enable the edge and test repositories.

# yum-config-manager --enable docker-ce-edge
# yum-config-manager --enable docker-ce-test

# INSTALL DOCKER CE

# 1. Install the latest version of Docker CE

sudo yum install --assumeyes --quiet docker-ce

# 3. Start Docker. Report if it failed.

sudo systemctl start docker || sudo systemctl status docker.service

# 4. Verify that docker is installed correctly by running the hello-world image.

sudo docker run hello-world
