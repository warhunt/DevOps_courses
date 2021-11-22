#!/bin/bash

if [ `id -u` == 0 ]; then
  echo "It's root"
else
  echo "It's not root"
fi

exit 0