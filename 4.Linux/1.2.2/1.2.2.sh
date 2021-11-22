#!/bin/bash
function get_parent_dir {
    echo "$(realpath -- "$1")"
}

function intersection {
    declare -a local list1=("${!1}")
    declare -a local list2=("${!2}")

    local l2=" ${list2[*]} "                 
    for item in ${list1[@]}; 
    do
        if [[ $l2 =~ " $item " ]] ; then 
            local result+=($item)
        fi
    done
    echo  ${result[@]}
}

function check_dirs {
    declare -a local spd=( `find $(get_parent_dir $1) -type d` )
    declare -a local dpd=( `find $(get_parent_dir $2) -type d` )

    if [[ $(intersection spd[@] dpd[@]) || ( "${spd[*]}" == "${dpd[*]}" ) ]]; then
        echo false
    else 
        echo true
    fi
}

function copy_dir {
    cp -aT $1 $2
}

function main {
    if ! $(check_dirs $2 $3); then
        echo "Source and destination directories should not be sibling"
        exit 1
    fi
    local s_dir_size=`du -s $2 | awk '{ print $1 }'`

    local d_dir_av=$(echo `df -k $3 | awk '{ print $4 }'` | awk '{ print $2 }')


    if [ $s_dir_size -le $d_dir_av ]; then
        "$@"
    else
        echo "Insufficient space in destination folder"
        read -r -p "Do you want to continue? (C | Y - continue, N | A - exit): " answer

        case "$answer" in
            C | Y ) 
                "$@"
                ;;
            N | A ) 
                exit 0
                ;;
            *)
                echo "Enter a wrong value!"
                exit 1
                ;;
        esac
    fi
}

options=$(getopt -l "destination_dir:,source_dir:" -o "d:s:" -a -- "$@")
[ $? -eq 0 ] || { 
    echo "Incorrect options provided"
    exit 1
}
eval set -- "$options"
while true; do
    case "$1" in
        -d|--destination_dir)
            shift;
            D_DIR=$1
            ;;
        -s|--source_dir)
            shift;
            S_DIR=$1
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

main copy_dir $S_DIR $D_DIR

exit 0