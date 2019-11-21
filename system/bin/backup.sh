#!/bin/bash
####################################
#
# Backup to NFS mount script.
#
####################################

if [[ $EUID -ne 0 ]]; then
  echo "Please rerun this script as root to ensure it can successfully copy all files"
  exit 1
fi

date=$(date +'%d.%m.%y-%H%M')
hostname=$(hostname -s)
# (Default) Where to backup to.
backup_destination="/tmp/backups"
backup_conf=/etc/backup.sh.conf

# What to backup.
if [[ -r $backup_conf ]]; then
  source $backup_conf
else
  echo "Could not find /etc/backup.sh.conf. Using default settings..."
  backup_files="/home /etc /root /opt"
  exclude_opts=""
fi

if [[ ! -d $backup_destination ]]; then
  mkdir -p $backup_destination
fi

#First, perform some cleanup
echo "Performing cleanup of backups > 8 weeks old"
find $backup_destination -maxdepth 1 -type f -mtime +56 \( -name '*.tar.gz' -o -name '*.list' \) -exec rm -v {} \;

# Create list of installed packages
pac_list="${hostname}-${date}-installed_packages.list"
pacman -Q > $backup_destination/$pac_list

# Create archive filename.
archive_file="${hostname}-${date}-filesystem_backup.tar.gz"

# Print start status message.
echo "Backing up $backup_files to $backup_destination/$archive_file"
date
echo

# Backup the files using tar.
tar czf $backup_destination/$archive_file $exclude_opts --exclude-caches $backup_files -C $backup_destination $pac_list
chmod 600 $backup_destination/$archive_file

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $backup_destination to check file sizes.
ls -lh $backup_destination
