#!/usr/bin/env bash
set -ex

vault_version=1.3.4

if which -a vault > /dev/null; then
    echo "vault is already installed"
    vault_version_installed=$(vault version | awk '{print $2}' | sed 's/^v//')
    if [ $vault_version = $vault_version_installed ]; then
        echo "vault is up to date"
        exit 0
    fi
    echo "vault is out of date and will be upgraded"
fi

echo "installing vault"
sudo apt-get update
sudo apt-get install -y unzip
vault_zip=vault_${vault_version}_linux_amd64.zip
wget https://releases.hashicorp.com/vault/${vault_version}/$vault_zip
unzip $vault_zip
chmod 755 vault
sudo cp vault /usr/bin/vault
rm -f $vault_zip vault
