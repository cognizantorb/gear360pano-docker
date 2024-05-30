#!/bin/bash

mode=$1
# Shift the arguments to remove the first one
shift
# Save remaining arguments
args=("$@")

# Check the first argument
case "$mode" in
    pano)
        # Execute the gear360pano.sh script for each file in the /in directory, in parallel
        # find /in -iname '*.jpg' -type f | parallel --load 99% --noswap --memfree 500M ./gear360pano.sh "${args[@]}" {}
        for file in `find /in -iname "*.jpg" -type f`
        do
            ./gear360pano.sh "${args[@]}" "$file"
        done
        ;;
    video)
        # Execute the gear360video.sh script for each .mp4 file in the /in directory
        for file in `find /in -iname "*.mp4" -type f`
        do
            ./gear360video.sh "${args[@]}" "$file"
        done
        ;;
    test)
        ./testgear360pano.sh
        ./testgear360video.sh
        ;;
    *)
        echo "Invalid argument. Please use 'pano', 'video', or 'test' as the first argument."
        exit 1
        ;;
esac