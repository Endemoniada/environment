#!/bin/bash

source_dir=$(dirname $0)
kernel=$(uname)
mail=$1

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

echo -e "\nDotfiles installed, enjoy."
