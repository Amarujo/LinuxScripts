#!/bin/bash
#Creates a new distributor sftp user with no login shell, random password, home directory, and member of sftpusers grou>#run script followed by username
#example: ./create_user_user.sh testuser

USER=$1
if [ -z "$1" ]; then
    echo "No username given"
    exit 1
fi

PASSWORD=$(pwgen -Bcn 10 1)


useradd -m -d /home/users/$USER  -G sftpusers --shell=/bin/false $USER

mkdir /home/users/$USER/invoices
chown root:$USER /home/users/$USER/
chown root:sftpusers /home/users/$USER/invoices

echo "$USER:$PASSWORD" | chpasswd
echo "Account created"
echo "Username: $USER"
echo "Password: $PASSWORD"
