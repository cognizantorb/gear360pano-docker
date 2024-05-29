#!/bin/bash

# Check the first argument
case "$1" in
    pano)
        # Shift the arguments to remove the first one
        shift
        # Execute the gear360pano.sh script with the remaining arguments
        ./gear360pano.sh "$@"
        ;;
    video)
        # Shift the arguments to remove the first one
        shift
        # Execute the gear360video.sh script with the remaining arguments
        ./gear360video.sh "$@"
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