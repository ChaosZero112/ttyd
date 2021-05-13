#!/bin/sh
clear
echo 'Installing python build tools. Please wait...' && \
apt-get update -qq && \
DEBIAN_FRONTEND=noninteractive apt-get -y -qq -o "Dpkg::Options::=--force-confdef" install \
make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev llvm libncursesw5-dev xz-utils tk-dev \
libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev && \
echo '' && \
echo 'Done.' && \
rm -f /root/py-build-tools.sh
exit 0