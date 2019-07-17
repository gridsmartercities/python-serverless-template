#!/bin/bash
set -e

debug_flag=0
if [[ $# -eq 1 ]]; then
    debug_flag=$1
fi

debug() {
    debug_flag=$1
    message=$2

    if [ $debug_flag == 1 ]; then
        echo $message
    fi
}

include() {
    debug_flag=$1
    file=$2

    src_dir=${file%"/package.json"}/src

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

package() {
    debug_flag=$1
    file=$2

    base_dir=${file%"/package.json"}

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
find . -name "package.json" | while read package_file; do

    debug $debug_flag "processing $package_file"

    include $debug_flag $package_file

    package $debug_flag $package_file

    rm $package_file
    debug $debug_flag "removed $package_file"
done

debug $debug_flag "packager end"

exit 0