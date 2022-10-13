#To be used on FTP.BUYERSEDGEPLATFORM.COM
#Creates a new operations user with access to the /home/users/ directory.
#user will have no login shell, random password, home directory, and be member of sftpusers group
#run script with sudo followed by username
#example: sudo ./create_ops_user.sh testuser

#run script with username in first place holder variable
USER=$1
if [ -z "$1" ]; then
    echo "No username given"
    exit 1
fi

#set random password
PASSWORD=$(pwgen -Bcn 10 1)

#user is created with the following parameters: no shell, member of sftpusers group, home directory in /home/users/
useradd -m -d /home/users/$USER  -G sftpusers --shell=/bin/false $USER

#make a FILES directory and set appropriate ownership, this is will the ops user will view all distributor files
mkdir /home/users/$USER/files
chown root:$USER /home/users/$USER/
chown $USER:$USER /home/users/$USER/files

#bindfs the users FILES directory to /home/files with appropriate permissions in FSTAB
#mount and then immediately comment it out to prevent errors 
FSTAB="bindfs#/home/files /home/$USER/files fuse force-user=$USER,force-group=$USER,create-for-user=$USER,create-for-group=sftpusers,create-with-perms=0750,chgrp-ignore,chown-ignore,chmod-ignore 1 2" 
echo $FSTAB | sudo tee -a /etc/fstab  1>/dev/null && mount  -a;;
sed -i -e '2s/^/# /' /etc/fstab

#update users password and print out information 
echo "$USER:$PASSWORD" | chpasswd
echo "Account created"
echo "Username: $USER"
echo "Password: $PASSWORD"
