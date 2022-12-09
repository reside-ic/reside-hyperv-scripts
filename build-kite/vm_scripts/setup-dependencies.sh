#!/usr/bin/env bash
set -ex

## Any additional system deps required by all/any builds
apt-get update
apt-get install -y libpq-dev
