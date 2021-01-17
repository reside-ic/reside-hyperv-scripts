sudo cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: false
      dhcp6: false
      addresses: [$IP/24]
      gateway4: $GW
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
EOF

sudo netplan apply
