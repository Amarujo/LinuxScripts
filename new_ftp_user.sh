
ftp.buyersedgepurchsaing.com or diningalliance (public IP 34.206.245.49, AWS hostname be-ftp01.dm.buyersedge.org)

1) Edit the text file: /etc/vsftpd/virtual-users-be.txt (or virtual-users-da.txt for the DA server)
       Lines in these files alternate between username and password
2) run "sudo make" to move those credentials to a database that VSFTP loads from, 
    Also have to add the user folder and use "chown vds.vds (chown vds.vds /home/ftp/newdistributor)
3) run "service vsftpd restart" to make the service restart and load the new credentials
4) bind operations users to ftp directory 
​

how to bind mount ftp users to ops users (one off, must be done if server reboots)
----------------------------------------
mount --bind /home/ftp /home/ftp/[ops user directory]

how to permanently bind mount user (will persists across reboots)
----------------------------------------
echo '/home/ftp /home/ftp/[ops user directory] none    bind    0 0'  >>  sudo /etc/fstab

##SCRIPT STARTS HERE

USER=$1
if [ -z "$1" ]; then
    echo "No username given"
    exit 1
fi

PASSWORD=$(pwgen -Bcn 10 1)

echo "$USER" >> /etc/test.txt
echo "PASSWORD" >> /etc/test.txt

mkdir /home/ftp/$USER
chown vds.vds /home/ftp/$USER
service vsftpd restart

echo "Is this person an BEP Employee?"
read ANSWER
if [ $ANSWER eq y]; then
   
