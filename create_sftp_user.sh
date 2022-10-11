#Creates a new sftp user with no login shell, random password, home directory, and member of sftpusers group.
#run script followed by username you'd like to create

#!/bin/bash
USER=$1
if [ -z "$1" ]; then
    echo "No username given"
    exit 1
fi
PASSWORD=$(pwgen -Bcn 10 1)

useradd -m -d /home/users/$USER  -G sftpusers --shell=/bin/false $USER

echo "$USER:$PASSWORD" | chpasswd
echo "Account created"
echo "Username: $USER"
echo "Password: $PASSWORD"
