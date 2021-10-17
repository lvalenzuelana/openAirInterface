# Get latest official Ubuntu 18.04.4
FROM ubuntu:18.04
# Who made the Dockerfile
MAINTAINER Luis Enrique Valenzuela Navarro
# Defining the time zone
RUN /bin/bash -c 'DEBIAN_FRONTEND=noninteractive'
ENV TZ=Europe/France
# Requirements.
RUN /bin/bash -c 'echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections'
RUN /bin/bash -c 'apt-get update'
RUN /bin/bash -c 'apt-get install -y tzdata'
RUN /bin/bash -c 'apt-get upgrade && apt install -y sudo git dialog apt-utils build-essential cmake protobuf-compiler'

# User with sudo privileges.
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
# Ensure sudo group users are not asked for a password when using sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER docker

# Directory for Open Air Interface
RUN /bin/bash -c 'sudo mkdir gitlab'
WORKDIR gitlab

# Download Open Air Interface
RUN /bin/bash -c 'sudo git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git'
WORKDIR openairinterface5g
RUN /bin/bash -c 'sudo git checkout master'
RUN /bin/bash -c 'source oaienv'
RUN /bin/bash -c 'DEBIAN_FRONTEND=noninteractive sudo ./cmake_targets/build_oai -I'
#RUN /bin/bash -c 'DEBIAN_FRONTEND=noninteractive sudo ./cmake_targets/build_oai --eNB'
WORKDIR ran_build
WORKDIR build
#RUN /bin/bash -c 'sudo make rfsimulator'
RUN sudo ln -s librfsimulator.so liboai_device.so 
