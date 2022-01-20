#!/bin/bash
while getopts ":hn:" option; do
case $option in
    h) # display Help
        exit;;
    n) # Enter a name
        Name=$OPTARG;;
    \?) # Invalid option
        echo "Error: Invalid option"
        exit;;
    esac
done

echo $Name
