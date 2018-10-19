#!/bin/bash

# Make sure we exit as soon as something goes wrong
set -e

source_dir=$(dirname "$0")
kernel=$(uname)
mail=$1

# Usage: `ask [Y|N]`
# Supplied parameter will decide the default answer
# Default is No`
ask () {
  default=$(echo "${1:0:1}" | awk '{print toupper($0)}')
  if [[ "$default" == "Y" ]]; then
    choices="[Y/n]"
  else
    choices="[y/N]"
  fi
  read -r -p "${choices}> " answer
  if [[ "$answer" == "" ]]; then
    answer=$default
  fi
  echo "${answer:0:1}" | awk '{print toupper($0)}'
}

install_system_files() {
  local source_dir=$1
  local sys_bin_dir=$source_dir/bin
  local sys_etc_dir=$source_dir/etc
  local sys_sysd_dir=$source_dir/systemd

  # Install custom scripts to /usr/local/bin/
  if [[ -d $sys_bin_dir ]]; then
    echo -e "\n# Installing binaries to /usr/local/bin/"
    for file in $(find "$sys_bin_dir" -maxdepth 1 -type f | grep -v -i readme); do
      sudo cp -v "$file" /usr/local/bin/
    done
  fi

  # Install config files to /etc/ (does not overwrite existing files)
  if [[ -d $sys_etc_dir ]]; then
    echo -e "\n# Installing config files to /etc/"
    for file in $(find "$sys_etc_dir" -maxdepth 1 -type f | grep -v -i readme); do
      if [[ -r /etc/$(basename "$file") ]]; then
        echo "File /etc/$(basename "$file") already exists, will not overwrite!"
      else
        sudo cp -n -v "$file" /etc/
      fi
    done
  fi

  # Install systemd unit files
  if [[ -d $sys_sysd_dir ]]; then
    echo -e "\n# Installing systemd unit files to /etc/systemd/system/"
    sudo rsync -r --out-format="%f" "${sys_sysd_dir}/" /etc/systemd/system/ --exclude 'README.md'
    sudo systemctl daemon-reload
    # Enable all service units except oneshot
    for file in $(find "$sys_sysd_dir" -maxdepth 1 -type f -iname '*.service' | grep -v -i readme); do
      grep -q -i 'oneshot' "$file" || sudo systemctl enable "$(basename "$file")"
    done
    # Enable all timer units
    for file in $(find "$sys_sysd_dir" -maxdepth 1 -type f -iname '*.timer' | grep -v -i readme); do
      sudo systemctl enable "$(basename "$file")"
    done
    # Enable all mount units
    for file in $(find "$sys_sysd_dir" -maxdepth 1 -type f -iname '*.mount' | grep -v -i readme); do
      sudo systemctl enable "$(basename "$file")"
    done
  fi
}

# Walk through and install user dotfiles in main directory
echo
echo "Do you want to install user dotfiles?"
if [[ "$(ask Y)" == "Y" ]]; then
  # Install regular dotfiles with custom handling where required
  for file in $(ls -A "${source_dir}" | grep -E '^\.[^.]+' | grep -E -v '^\.git$'); do
      if [ "${file}" == ".slate" ] || [ "${file}" == ".Brewfile" ]; then
          if [ "${kernel}" != "Darwin" ]; then
              continue
          fi
      fi

      if [ "${file}" == ".gitignore" ]; then
        continue
      fi

      if [ "${file}" == ".gitconfig" ]; then

          if [ ! "${mail}" ]; then
              echo "Enter git commit mail, followed by [ENTER];"
              read -p "> " mail
          fi

          sed "s/%%PLACEHOLDER%%/${mail}/" "${source_dir}/${file}" > "${HOME}/${file}"
          continue
      fi

      if [ -r "${HOME}/${file}" ]; then
        echo -n "File exists, creating backup:  "
        cp -va "${HOME}/${file}" "${HOME}/.orig${file}"
      fi
      echo -n "Installing file:               "
      cp -v "${source_dir}/${file}" "${HOME}/"

  done
fi

# Install system files in /system/ directory
if [[ "$(hostname)" == "archivist" || "$(hostname)" == "archon" ]]; then
  echo
  echo "Do you want to install system binaries, system config files"
  echo "and install and enable systemd units/timers? (will invoke sudo)"
  if [[ "$(ask N)" == "Y" ]]; then
    echo -e "\n### Installing generic system files"
    install_system_files "$source_dir/system"
    if [[ -d $source_dir/system/$(hostname) ]]; then
      echo -e "\n### Installing $(hostname) specific system files"
      install_system_files "$source_dir/system/$(hostname)"
    fi
  fi
fi

echo
echo "Dotfiles installed, enjoy."
