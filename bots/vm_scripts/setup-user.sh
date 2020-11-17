useradd -s /bin/bash -p $newuser $newuser
usermod -aG sudo $newuser
mkdir /home/$newuser
echo Do this: chown $newuser:$newuser /home/$newuser
chown $newuser:$newuser /home/$newuser
mkdir /home/$newuser/.ssh
chown $newuser:$newuser /home/$newuser/.ssh

cat <<EOF > /home/$newuser/.ssh/authorized_keys
ssh-rsa $pubkey $machine
EOF

chown $newuser:$newuser /home/$newuser/.ssh/authorized_keys
