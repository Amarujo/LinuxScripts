#Backs up important config files and appends with date
#Backs up to local folder first
#then rsyncs to s3 bucket on Backblaze
#archives files older than 1 month locally and on cloud
#sends email with confirmation of most recent moves and deletions

#create pihole backup
pihole -a -t

#run pivpn backup
#/home/andy/scripts/script.exp

#set variables
FILESORIGINAL="/home/andy/.ssh/config /etc/samba/smb.conf /home/andy/scripts/pi-hole*"
SCRIPTS="/home/andy/scripts/"
S3FS="/home/andy/s3fs-mount/configs-backup-weekly/"


#make this week local backupfolder for config files and scripts
mkdir /home/andy/Local-Config-Backups/Week-of-$(date +"%d-%m-%Y")
client_loop: send disconnect: Broken pipe
for each files in file
  do
  cp $FILESORIGINAL /home/andy/Local-Config-Backups/Week-of-$(date +"%d-%m-%Y")/
  done

#back up scripts
cp -r $SCRIPTS /home/andy/Local-Config-Backups/Week-of-$(date +"%d-%m-%Y")/
####NEED TO RUN THROUGH ALL FILES IN THIS DIRECTORY AND APPEND DATE

#copy backed up files to the cloud
cp -r /home/andy/Local-Config-Backups/Week-of-$(date +"%d-%m-%Y") $S3FS
                                                                    
