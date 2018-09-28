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

# What to backup.
backup_files="/home /etc /root /opt"
exclude_files=""

# Where to backup to.
day=$(date +'%d.%m.%y-%H:%M')
hostname=$(hostname -s)
dest="/tmp/backups"
if [[ ! -d $dest ]]; then
        mkdir -p $dest
fi

# Create archive filename.
archive_file="${hostname}-${day}.tar.gz"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
tar czf $dest/$archive_file $backup_files --exclude-caches-all
# Comment the previous, and uncomment the following, if you want to exclude files
#tar czf $dest/$archive_file $backup_files --exclude=$exclude_files --exclude-caches-all
chmod 600 $dest/$archive_file

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest
