#!/bin/bash
# Generate Password for user
PASSWORD=$(openssl rand -base64 16 | tr -d '+=' | head -c 16)
INVOICE=false
WEEKLY=false


# Parse opts.  Searching specifically for -i
while getopts ":ih:" opt; do
  case $opt in
  i) INVOICE=true;;
  w) WEEKLY=true;;
  h) printf "Usage: %s username [-i] [-w]\n" $0
     exit 2;;
  w) WEEKLY=true;;
  esac
done
shift $((OPTIND -1))

# Check if user exists.
if [ getent passwd $1 >  /dev/null 2>&1 ]; then
  echo "User exists.  Exiting"
  exit 2
fi

# Add the user and change password to generated password.
adduser --disabled-login --quiet --home /home/users/$1 $1 || exit
echo $1:$PASSWORD | chpasswd

# prevent ssh login & assign SFTP group
usermod -g vsftp $1
usermod -s /bin/false $1

# chroot user (so they only see their directory after login)
chown root:$1 /home/users/$1
chmod 755 /home/users/$1


# if -i is passed to the script then create invoices folder.
if [ "$INVOICE" = true ]; then
  mkdir /home/users/$1/Invoices
  chown $1:vsftp /home/users/$1/Invoices
  chmod 774 /home/users/$1/Invoices
fi

# if -w is passed to the script then create Weekly File folder.
if [ "$WEEKLY" = true ]; then
  mkdir /home/users/$1/WeeklyFiles
  chown $1:vsftp /home/users/$1/WeeklyFiles
  chmod 774 /home/users/$1/WeeklyFiles
fi


# Setup contracts folder for user
mkdir /home/users/$1/Contracts
chown root:vsftp /home/users/$1/Contracts
chmod 774 /home/users/$1/Contracts

# Remove files created by standard profile.
rm /home/users/$1/.bash_logout
rm /home/users/$1/.bashrc
rm /home/users/$1/.profile

# Print pasword to stdout
printf "\n\nGenerated User password: $PASSWORD\n\n"


ubuntu@CUS-ftp-mymvip:~$ ^C
ubuntu@CUS-ftp-mymvip:~$ cat new_user_script.sh 
#!/bin/bash

# Generate Password for user
PASSWORD=$(openssl rand -base64 16 | tr -d '+=' | head -c 16)
INVOICE=false

# Parse opts.  Searching specifically for -i
while getopts ":ih:" opt; do
  case $opt in
  i) INVOICE=true;;
  h) printf "Usage: %s username [-i]\n" $0
     exit 2;;
  esac
done
shift $((OPTIND -1))

# Check if user exists.
if [ getent passwd $1 >  /dev/null 2>&1 ]; then
  echo "User exists.  Exiting"
  exit 2
fi

# Add the user and change password to generated password.
adduser --disabled-login --quiet --home /home/users/$1 $1 || exit
echo $1:$PASSWORD | chpasswd

# prevent ssh login & assign SFTP group
usermod -g vsftp $1
usermod -s /bin/false $1

# chroot user (so they only see their directory after login)
chown root:$1 /home/users/$1
chmod 755 /home/users/$1


# if -i is passed to the script then create invoices folder.
if [ "$INVOICE" = true ]; then
  mkdir /home/users/$1/Invoices
  chown $1:vsftp /home/users/$1/Invoices
  chmod 774 /home/users/$1/Invoices
fi

# Setup contracts folder for user
mkdir /home/users/$1/Contracts
chown root:vsftp /home/users/$1/Contracts
chmod 774 /home/users/$1/Contracts

# Remove files created by standard profile.
rm /home/users/$1/.bash_logout
rm /home/users/$1/.bashrc
rm /home/users/$1/.profile

# Print pasword to stdout
printf "\n\nGenerated User password: $PASSWORD\n\n"

echo $1 >> /etc/vsftpd.userlist
