sudo ip addr add $IP/24 dev eth0
sudo ip route add default via $GW dev eth0
sudo ip link set eth0 up
