#!/bin/bash

# loop through all src folders, finding all package.yaml files

find . -name "package.json" | while read file; do
#    dir_name=${file#"./src/"}
#    dir_name=${dir_name%"/package.json"}

    for entry in $(jq -r '.include[] | .' $file); do
        dir=${file%"/package.json"}/src
        if [ ! -d "$dir" ]; then
            mkdir $dir
        fi
        cp ./src/${entry} ${dir}/${entry}
    done

    for entry in $(jq -r '.package[] | .' $file); do
        dir=${file%"/package.json"}
        echo $entry >> ${dir}/requirements.txt
    done
done

# delete package.yaml files (optional)

