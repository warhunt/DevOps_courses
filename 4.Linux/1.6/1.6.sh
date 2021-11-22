#!/bin/bash
read -p "Enter symbol: " str
length=$(expr length "$str")

if [ $length -gt 1 ]; then
  echo "It's not a symbol"
  exit 1
else
  echo -n "You entered: "
  case "$str" in
    [a-z] ) echo "Lowercase letter";;
    [A-Z] ) echo "Uppercase letter";;
    [0-9] ) echo "Number";;
    *     ) echo "Punctuation mark, space, or something else";;
  esac
fi

exit 0
