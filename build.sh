#!/bin/bash

# Run each build.sh script in underlying comp-* directories
for d in *; do
    if [[ -d $d ]] && [[ $d =~ comp-.* ]]
    then
        cd $d; ./build.sh $*; cd -
    fi
done
