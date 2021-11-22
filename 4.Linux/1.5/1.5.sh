#!/bin/bash
let count=$#
for (( i = 0; i < $count; i++ ));
do
  echo $1
  shift
done

exit 0