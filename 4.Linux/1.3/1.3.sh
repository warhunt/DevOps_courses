#!/bin/bash
read -t 5 -p "Enter string: " string

if [ -z $string ]; then
    echo "The waiting time has expired"
else
    echo "You entered: $string"
fi

exit 0