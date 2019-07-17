#!/bin/bash

#   Manage folders with a package.json file only
find . -name "package.json" | while read file; do

    base_dir=${file%"/package.json"}
    src_dir=${base_dir}/src

    #   "include" section: create src directory and copy all included files there
    if [ -d $src_dir ]; then
        rm -rf $src_dir
    fi

    if [ "`jq -r '.include' $file`" != "null" ]; then
        for entry in $(jq -r '.include[] | .' $file); do
            if [ ! -d "$src_dir" ]; then
                mkdir $src_dir
            fi
            cp ./src/${entry} ${src_dir}/${entry}
        done
    fi

    #   "package" section: add a requirements.txt file with all the external dependencies
    if [ -f ${base_dir}/requirements.txt ]; then
        rm ${base_dir}/requirements.txt
    fi

    touch ${base_dir}/requirements.txt
    if [ "`jq -r '.package' $file`" != "null" ]; then
        for entry in $(jq -r '.package[] | .' $file); do
            echo $entry >> ${base_dir}/requirements.txt
        done
    fi

    rm $file
done