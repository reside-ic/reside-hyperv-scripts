#!/usr/bin/env bash
set -ex

if which -a pip3 > /dev/null; then
    echo "pip3 is already installed"
    exit 0
fi

echo "installing pip3"

sudo -y apt-get update & sudo apt-get -y install python3-pip
