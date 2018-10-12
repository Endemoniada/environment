#!/bin/bash

source_dir=$(dirname $0)
kernel=$(uname)
mail=$1

ask () {
  default=$(echo ${1:0:1} | awk '{print toupper($0)}')
  if [[ "$default" == "Y" ]]; then
    choices="[Y/n]"
  else
    choices="[y/N]"
  fi
  read -p "${choices}> " answer
  if [[ "$answer" == "" ]]; then
    answer=$default
  fi
  echo $(echo ${answer:0:1} | awk '{print toupper($0)}')
}

echo
echo "Do you want to install user dotfiles?"
if [[ "$(ask Y)" == "Y" ]]; then
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
fi

# Install backup script and necessary files
dist=$(sed -n "s/^ID=\(.*\)$/\1/p" /etc/*-release)
if [[ "$dist" == "arch" || "$dist" == "archarm" ]]; then
  echo
  echo "Do you want to install system binaries, system config files"
  echo "and install and enable systemd units/timers? (will invoke sudo)"
  if [[ "$(ask N)" == "Y" ]]; then
    echo
    # Install custom scripts to /usr/local/bin/
    for file in $(find $source_dir/system/bin -maxdepth 1 -type f | grep -v -i readme); do
      sudo cp -v $file /usr/local/bin/
    done
    # Install config files to /etc/ (does not overwrite existing files)
    for file in $(find $source_dir/system/etc -maxdepth 1 -type f | grep -v -i readme); do
      if [ -r /etc/${file} ]; then
        echo "File /etc/${file} already exists, will not overwrite"
      else
        sudo cp -n -v $file /etc/
      fi
    done
    # Install service unit files and enable them
    for file in $(find $source_dir/system/systemd -maxdepth 1 -type f -iname '*.service' | grep -v -i readme); do
      sudo cp -v $file /etc/systemd/system/ && sudo systemctl daemon-reload
      grep -q -i 'oneshot' $file || sudo systemctl enable $(basename $file)
    done
    if [[ -d $source_dir/system/systemd/$(hostname) ]]; then
      for file in $(find $source_dir/system/systemd/$(hostname) -maxdepth 1 -type f -iname '*.service' | grep -v -i readme); do
        sudo cp -v $file /etc/systemd/system/ && sudo systemctl daemon-reload
        grep -q -i 'oneshot' $file || sudo systemctl enable $(basename $file)
      done
    fi
    # Install timer unit files and enable them
    for file in $(find $source_dir/system/systemd -maxdepth 1 -type f -iname '*.timer' | grep -v -i readme); do
      sudo cp -v $file /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable $(basename $file)
    done
    if [[ -d $source_dir/system/systemd/$(hostname) ]]; then
      for file in $(find $source_dir/system/systemd/$(hostname) -maxdepth 1 -type f -iname '*.timer' | grep -v -i readme); do
        sudo cp -v $file /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable $(basename $file)
      done
    fi
  fi
fi

echo
echo "Dotfiles installed, enjoy."
