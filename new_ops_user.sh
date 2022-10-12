#!/bin/bash

#set variables
PASSWORD=$(pwgen -Bcn 10 1)
USER=$1
if [ -z "$1" ]; then
    echo "No username given"
    exit 1
fi

#Add user to  /etc/vsftpd/virtual-users-be.txt
echo "$USER" >> /etc/test.txt
echo "$PASSWORD" >> /etc/test.txt
#sudo /etc/vsftpd/make

#Make users home directory and set ownership to vds
mkdir /home/ftp/$USER
chown vds.vds /home/ftp/$USER
#service vsftpd restart

#if the user is a operations user, bind mount them to the home/ftp directory.
FSTAB="/home/ftp /home/ftp/$USER  none   bind   0 0"
#echo "Is this person an BEP Employee?"
#read ANSWER
#if [ "$ANSWER" == 'y' ]; then
#   echo $FSTAB  | sudo tee -a /etc/fstab
#fi

read -p "Is this user a BEP empoyee? (y/n) " yn
 case $yn in
     [yY] ) echo $FSTAB | sudo tee -a /etc/fstab  1>/dev/null && mount  -a;;
     [nN] ) echo  "User has been created, see details below";;
 esac
echo "Username: $USER"
echo "Password: $PASSWORD"
