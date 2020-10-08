#!/usr/bin/env bash
set -e

## Setup as an agent
echo "deb https://apt.buildkite.com/buildkite-agent stable main" | sudo tee /etc/apt/sources.list.d/buildkite-agent.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 32A37959C2FA5C3C99EFBC32A79206696452D198
sudo apt-get update && sudo apt-get install -y buildkite-agent

# Enable passwordless login
echo 'buildkite-agent ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/buildkite-agent
