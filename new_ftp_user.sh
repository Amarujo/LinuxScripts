#!/bin/bash
  

#creates new distributor for ftp.buyersedgepurchasing.com 
#if the user is also an operation users, answer Y to "Is this user a BEP empoyee? (y/n)"

#set variables
PASSWORD=$(pwgen -Bcn 10 1)
USER=$1
if [ -z "$1" ]; then
    echo "No username given"
    exit 1
fi

#Add user name and password  to  /etc/vsftpd/virtual-users-be.txt (lines in this file alternate between username and password)
echo "$USER" >> /etc/vsftpd/virtual-users-be.txt
echo "$PASSWORD" >> /etc/vsftpd/virtual-users-be.txt

#run make against make file in /etc/vsftpd to move these credentials to the database that VSFTP loads from
make -C /etc/vsftpd

#Make users home directory and set ownership to vds
mkdir /home/ftp/$USER
chown vds.vds /home/ftp/$USER
service vsftpd restart

#if the user is a operations user, bind mount them to the /home/ftp directory.
FSTAB="/home/ftp /home/ftp/$USER  none   bind   0 0"
read -p "Is this user a BEP empoyee? (y/n)" yn
    case $yn in
      [yY] ) echo $FSTAB | sudo tee -a /etc/fstab  1>/dev/null && mount  -a;;
      [nN] ) echo  "User has been created, see details below";;
    esac

#Print out user details 
echo "Username: $USER"
echo "Password: $PASSWORD"
