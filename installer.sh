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
            read -p "> " mail
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

# Install backup script and necessary files
echo
echo "Do you want to install backup script to /user/local/bin and"
echo "enable systemd units to run it automatically (invokes sudo)? [Y/n]"
read -n 1 -p "> " answer
case $answer in
  y|Y|"" )
    echo
    sudo cp -v $source_dir/backup.sh/backup.sh /usr/local/bin/
    if [[ ! -r /etc/backup.sh.conf ]]; then
      sudo cp -v $source_dir/backup.sh/backup.sh.conf /etc/
    fi
    # Install custom scripts to /usr/local/bin/
    for file in $(find $source_dir/systemd/bin -maxdepth 1 -type f |grep -v -i readme); do
      sudo cp -v $file /usr/local/bin/
    done
    # Install service unit files and enable them
    for file in $(find $source_dir/systemd -maxdepth 1 -type f -iname '*.service'); do
      sudo cp -v $file /etc/systemd/system/ && sudo systemctl daemon-reload
      grep -q -i 'oneshot' $file || sudo systemctl enable $(basename $file)
    done
    # Install timer unit files and enable them
    for file in $(find $source_dir/systemd -maxdepth 1 -type f -iname '*.timer'); do
      sudo cp -v $file /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable $(basename $file)
    done
  ;;
esac

echo
echo "Dotfiles installed, enjoy."
