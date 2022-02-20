#!/bin/bash

SERVICE="fail2ban"
KEY="$(cat /root/id_rsa.pub)"

#update and install fail2ban
sudo apt update > /dev/null 2>&1
sudo apt install $SERVICE -y  > /dev/null 2>&1

#check fail2ban is running and output yes/no to terminal
systemctl is-active $SERVICE > /dev/null
if [ $? -eq 0 ]
then
   echo "$SERVICE is running!!!"
else 
   echo "$SERVICE is NOT running!!!"
fi

#check if jail.local already exists
#needs template to be loaded to  home directory first
ls /etc/fail2ban | grep -w 'jail.local' > /dev/null 2>&1
if [ $? -eq 0 ]
then
   echo "jail.local already exists, skipping"
else
   echo "jail.local does not exist, copying now" 
   cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local  > /dev/null
#   mv ~/jail.local /etc/fail2ban/jail.local > /dev/null
fi

#create user and password
groupadd ssh_users
useradd andy -m -s /bin/bash -G sudo,ssh_users
if [ $(id -u) -eq 0 ]
    then 
    read -sp "password for andy: " password
    echo andy:$password | chpasswd 
else
	echo "Only root may add a user to the system."
	exit 2
fi

#add pub key to authorized_keys for andy
mkdir /home/andy/.ssh
chmod 700 /home/andy/.ssh
touch /home/andy/.ssh/authorized_keys
chmod 644 /home/andy/.ssh/authorized_keys
chown -R andy: /home/andy

#add public key to andy authorized_keys
#might be easier to just copy autorized_keys from root user since public key is already there
cp /root/id_rsa.pub /home/andy/.ssh/id_rsa.pub
KEY="$(cat /root/id_rsa.pub)"
echo $KEY >> /home/andy/.ssh/authorized_keys

#update sshd_config to disable root login, disable password login, restrict group to "sshd_users" group 
#create a copy of sshd_config first
cp -a /etc/ssh/sshd_config{,"-$(date +"%m-%d-%y-%r")"}
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
echo "AllowGroups ssh_users" >> /etc/ssh/sshd_config
