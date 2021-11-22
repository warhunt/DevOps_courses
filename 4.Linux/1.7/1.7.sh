#!/bin/bash
read -p "Enter number of meters: " meters
 
echo "In miles it is: `echo "$meters*0.000621371"|bc`"

exit 0