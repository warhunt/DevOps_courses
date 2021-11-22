#!/bin/bash
function main {
    local html=`curl -s 'https://myfin.by/currency/minsk'`
    local all=(`echo $html | grep -o '<td[^<]*</td>'`)

    case "$1" in
        USD ) 
            echo "Best USD->BYR rate: `echo ${all[0]} | grep -oP '(?<=(<td>)).*(?=(</td>))'`"
            exit 0
            ;;
        EUR ) 
            echo "Best EUR->BYR rate: `echo ${all[3]} | grep -oP '(?<=(<td>)).*(?=(</td>))'`"
            exit 0
            ;;
        * )
            echo "Enter a wrong value!"
            exit 1
            ;;
    esac
  
}

if [ $# -eq 0 ]; then
    echo "Available currency:"
    echo "  1 - USD"
    echo "  2 - EUR"

    read -p "Choose a currency: " answer

    case "$answer" in
        1 ) 
            main USD
            exit 0
            ;;
        2 ) 
            main EUR
            exit 0
            ;;
        * )
            echo "Enter a wrong value!"
            exit 1
            ;;
    esac
fi

main $1


