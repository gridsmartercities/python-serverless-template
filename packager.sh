#!/bin/bash
set -e

OPTIND=1         # Reset in case getopts has been used previously in the shell.

debug_flag=0

function show_help() {
    echo -e "\nUSAGE:\n\t./packager.sh -hd\n\nOPTIONS:\n\t-h\tShow usage\n\t-d\tShow debug messages\n"
}

while getopts "hd?:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        d)
            debug_flag=1
            ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift


function debug() {
    debug_flag=$1
    message=$2

    if [ $debug_flag == 1 ]; then
        echo "... $message"
    fi
}

function include() {
    debug_flag=$1
    file=$2
    parser=$3

    src_dir=${file%"/package.$format"}/src

    rm -rf $src_dir
    debug $debug_flag "removed $src_dir"

    if [ "`$parser -r '.include' $file`" != "null" ]; then
        for entry in $($parser -r '.include[] | .' $file); do
            name=$(basename $entry)
            dir=$src_dir
            if [[ $name != $entry ]]; then
                dir=$src_dir/$(dirname $entry)
            fi
            if [ ! -d "$dir" ]; then
                mkdir $dir
                debug $debug_flag "created $dir"
            fi
            cp ./src/$entry $dir/$name
            debug $debug_flag "copied $name files to $dir"
        done
    fi
}

function package() {
    debug_flag=$1
    file=$2
    parser=$3

    base_dir=${file%"/package.$format"}

    rm -f $base_dir/requirements.txt && touch $base_dir/requirements.txt

    debug $debug_flag "removed and created $base_dir/requirements.txt"

    if [ "`$parser -r '.package' $file`" != "null" ]; then
        for entry in $($parser -r '.package[] | .' $file); do
            echo $entry >> $base_dir/requirements.txt
            debug debug_flag "appended $entry to requirements.txt"
        done
    fi
}

function run_format() {
    debug_flag=$1
    format=$2

    debug $debug_flag "processing $format files"

    find ./build -name "package.$format" | while read package_file; do

        debug $debug_flag "processing $package_file"

        parser=yq
        if [ "$format" == "json" ]; then
            parser=jq
        fi

        include $debug_flag $package_file $parser

        package $debug_flag $package_file $parser

        rm $package_file
        debug $debug_flag "removed $package_file"
    done
}

debug $debug_flag "packager start"

debug $debug_flag "removing and creating build folder"
rm -rf ./build && cp -R ./src ./build

run_format $debug_flag "yaml"
run_format $debug_flag "yml"
run_format $debug_flag "json"

debug $debug_flag "packager end"

exit 0