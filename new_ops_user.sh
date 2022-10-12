#Creates a new operations user with access to the /home/files/ directory.
#user will have no login shell, random password, home directory, and be member of sftpusers group
#run script followed by username
#example: sudo ./create_ops_user.sh testuser


FSTAB="bindfs#/home/files /home/users/$USER/files fuse force-user=$USER,force-group=$USER,create-for-user=$USER,create-for-group=sftpusers,create-with-perms=0750,chgrp-ignore,chown-ignore,chmod-ignore 1 2"
USER=$1
PASSWORD=$(pwgen -Bcn 10 1)

if [ -z "$1" ]; then
    echo "No username given"
    exit 1
fi

#create user with no shell access, add them to sftpusers group, and make home directory
useradd -m -d /home/users/$USER  -G sftpusers --shell=/bin/false $USER

#make files and set correct permissions so they only see their directory after login
mkdir /home/users/$USER/files
chown root:$USER /home/users/$USER/
chown $USER:$USER /home/users/$USER/files
chmod 755 /home/users/$USER


#update FSTAB to bind the user to /home/files, mount the bind, and then comment out the most recent line
echo "$FSTAB" | sudo tee -a /etc/fstab  1>/dev/null
LINE=$(sudo cat /etc/fstab | wc -l)
mount -a
sudo sed -i  "$LINE s/^/#/" /etc/fstab

#output the folllowing details to terminal
echo "$USER:$PASSWORD" | chpasswd
echo "Account created"
echo "Username: $USER"
echo "Password: $PASSWORD"
