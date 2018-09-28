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

date=$(date +'%d.%m.%y-%H:%M')
hostname=$(hostname -s)
backup_conf=/etc/backup.sh.conf

# What to backup.
if [[ -r $backup_conf ]]; then
  source $backup_conf
else
  echo "Could not find /etc/backup.sh.conf. Using default settings..."
  backup_files="/home /etc /root /opt"
  exclude_files="*/.cache"
fi

# Where to backup to.
dest="/tmp/backups"
if [[ ! -d $dest ]]; then
        mkdir -p $dest
fi

# Create list of installed packages
pac_list="installed_packages-${hostname}-${date}.list"
pacman -Q > $dest/$pac_list

# Create archive filename.
archive_file="${hostname}-${date}.tar.gz"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
tar czf $dest/$archive_file --exclude=$exclude_files --exclude-caches-all $backup_files -C $dest $pac_list
chmod 600 $dest/$archive_file

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest
