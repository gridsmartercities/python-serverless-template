#!/bin/bash

echo "packager start"

#   Manage folders with a package.json file only
find . -name "package.json" | while read file; do

    echo "starting with $file"

    base_dir=${file%"/package.json"}
    src_dir=$base_dir/src

    echo "Base Dir: $base_dir"
    echo "Src Dir: $src_dir"

    #   "include" section: create src directory and copy all included files there
    if [ -d $src_dir ]; then
        rm -rf $src_dir
        echo "$src_dir removed"
    fi

    if [ "`jq -r '.include' $file`" != "null" ]; then
        for entry in $(jq -r '.include[] | .' $file); do
            if [ ! -d "$src_dir" ]; then
                mkdir $src_dir
                echo "created $src_dir"
            fi
            cp ./src/$entry $src_dir/$entry
            echo "copied $entry files to $src_dir"
        done
    fi

    #   "package" section: add a requirements.txt file with all the external dependencies
    if [ -f $base_dir/requirements.txt ]; then
        rm $base_dir/requirements.txt
        echo "removed $base_dir/requirements.txt"
    fi

    touch ${base_dir}/requirements.txt
    if [ "`jq -r '.package' $file`" != "null" ]; then
        for entry in $(jq -r '.package[] | .' $file); do
            echo $entry >> $base_dir/requirements.txt
            echo "appended $entry to requirements.txt"
        done
    fi

    rm $file
    echo "removed $file"
done

echo "packager end"