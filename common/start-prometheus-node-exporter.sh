#!/usr/bin/env bash
set -ex

wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xvfz node_exporter-*.*-amd64.tar.gz
cd node_exporter-*.*-amd64
# Exposes metrics on port 9100 by default
nohup ./node_exporter > node_exporter.log 2>&1 &
