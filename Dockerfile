##################################################################
# DOCKERFILE manualbuild for "vzlogger" 
# TARGET: RaspberryPI (ARMv8) with "Strech"
# see installation guide: https://wiki.volkszaehler.org/software/controller/vzlogger/installation_cpp-version
#
# since systemd is not working within docker, a patched install.sh is needed.
##################################################################

# base image
# FROM arm32v7/debian:stable
FROM resin/raspberry-pi-debian:latest

LABEL Description="rpi-vzlogger docker image" Maintainer="sir106@gmail.com" Version="0.1"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install sudo build-essential git-core cmake pkg-config subversion  \
    libcurl4-openssl-dev libgnutls28-dev libsasl2-dev uuid-dev \
    libtool libssl-dev libgcrypt20-dev libmicrohttpd-dev libltdl-dev \
    libjson-c-dev libleptonica-dev libunistring-dev dh-autoreconf

RUN mkdir /cfg && cd /tmp && \
    git clone https://github.com/treban/vzlogger.git && \
    cd vzlogger && \
    bash ./install.sh

####### volume #######
VOLUME ["/cfg"]

CMD /usr/local/bin/vzlogger --config /cfg/vzlogger.conf
