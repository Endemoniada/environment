#!/bin/bash

source_dir=$(dirname $0)
kernel=$(uname)
mail=$1

# Install regular dotfiles with custom handling where required
for file in $(ls -A ${source_dir} | egrep '^\.[^.]+' | egrep -v '^\.git$'); do
    if [ "${file}" == ".slate" ] || [ "${file}" == ".Brewfile" ]; then
        if [ "${kernel}" != "Darwin" ]; then
            continue
        fi
    fi

    if [ "${file}" == ".gitignore" ]; then
      continue
    fi

    if [ "${file}" == ".gitconfig" ]; then

        if [ ! ${mail} ]; then
            echo "Enter git commit mail, followed by [ENTER];"
            read mail
        fi

        sed "s/%%PLACEHOLDER%%/${mail}/" ${source_dir}/${file} > ~/${file}
        continue
    fi

    if [ -r ~/${file} ]; then
      echo -n "File exists, creating backup:  "
      cp -va ~/${file} ~/.orig${file}
    fi
    echo -n "Installing file:               "
    cp -v ${source_dir}/${file} ~/

done

# Install some system files
echo "Do you want to install backup script to /user/local/bin and"
echo "enable systemd units to run it automatically (invokes sudo)? [Y/n]"
read -n 1 -p "> " answer
case $answer in
  y|Y|"" )
    echo
    sudo cp -v $source_dir/bin/backup.sh /usr/local/bin/
    sudo cp -v $source_dir/systemd/backup.sh.* /etc/systemd/system/
    sudo systemctl daemon-reload && sudo systemctl start backup.sh.timer && sudo systemctl enable backup.sh.timer
  ;;
esac

echo -e "\nDotfiles installed, enjoy."
