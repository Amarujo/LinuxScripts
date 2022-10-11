
#Creates a new operations user with access to the /home/users/ directory.
#user will have no login shell, random password, home directory, and be member of sftpusers group
#run script followed by username
#example: sudo ./create_ops_user.sh testuser

USER=$1
if [ -z "$1" ]; then
    echo "No username given"
    exit 1
fi

PASSWORD=$(pwgen -Bcn 10 1)

useradd -m -d /home/users/$USER  -G sftpusers --shell=/bin/false $USER

mkdir /home/users/$USER/files
chown root:$USER /home/users/$USER/
chown $USER:$USER /home/users/$USER/files

echo "bindfs#/home/files /home/$USER/files fuse force-user=$USER,force-group=$USER,create-for-user=$USER,create-for-group=sftpusers,create-with-perms=0750,chgrp-ignore,chown-ignore,chmod-ignore 1 2" | sudo tee -a /etc/fstab
mount -a
sed -i -e '2s/^/# /' /etc/fstab

echo "$USER:$PASSWORD" | chpasswd
echo "Account created"
echo "Username: $USER"
echo "Password: $PASSWORD"
