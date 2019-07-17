#!/bin/bash
set -e

format=yaml
if [[ $# -gt 0 && "$1" == "json" ]]; then
    format=json
fi

debug_flag=0
if [[ $# -gt 1 ]]; then
    debug_flag=$2
fi

function debug() {
    debug_flag=$1
    message=$2

    if [ $debug_flag == 1 ]; then
        echo $message
    fi
}

function include() {
    debug_flag=$1
    file=$2
    format=$3

    src_dir=${file%"/package.$format"}/src

    rm -rf $src_dir
    debug $debug_flag "removed $src_dir"

    if [ "`jq -r '.include' $file`" != "null" ]; then
        for entry in $(jq -r '.include[] | .' $file); do
            if [ ! -d "$src_dir" ]; then
                mkdir $src_dir
                debug $debug_flag "created $src_dir"
            fi
            cp ./src/$entry $src_dir/$entry
            debug $debug_flag "copied $entry files to $src_dir"
        done
    fi
}

function package() {
    debug_flag=$1
    file=$2
    format=$3

    base_dir=${file%"/package.$format"}

    rm -f $base_dir/requirements.txt && touch $base_dir/requirements.txt

    debug $debug_flag "removed and created $base_dir/requirements.txt"

    if [ "`jq -r '.package' $file`" != "null" ]; then
        for entry in $(jq -r '.package[] | .' $file); do
            echo $entry >> $base_dir/requirements.txt
            debug debug_flag "appended $entry to requirements.txt"
        done
    fi
}

debug $debug_flag "packager start"

#   Manage folders with a package.json file only
find . -name "package.$format" | while read package_file; do

    debug $debug_flag "processing $package_file"

    include $debug_flag $package_file $format

    package $debug_flag $package_file $format

    rm $package_file
    debug $debug_flag "removed $package_file"
done

debug $debug_flag "packager end"

exit 0