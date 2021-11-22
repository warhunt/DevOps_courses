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

function mode_1 {
    name=`date '+%y%m%d_%H%S'`
    `tar -c $1 | gzip > $2/$name.gz`
}

function mode_2 {

    local n_files=$3
    for i in $(ls $2 | tail -n+$n_files)
    do
        if [ -f "$2/${i}" ]; then
            rm "$2/${i}"
        fi
    done

    declare -a local files=(`find $2 -type f -name '*.gz'`)
    local n_file=${#files[@]}
    let "n_file -= 1"

    for (( i=$n_file; i >= 0; i-- ))
    do
        local new_name=$i
        let "new_name += 1"
        `mv $2/$i.gz $2/$new_name.gz`
    done

    `tar -c $1 | gzip > $2/0.gz`

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
        read -p "Do you want to continue? (C | Y - continue, N | A - exit): " answer

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

echo "Available formats:"
echo "  1 - YYMMDD_HHSS.gz"
echo "  2 - 0.gz, 1.gz, 2.gz"

read -p "Choose a save format: " answer

case "$answer" in
    1 ) 
        main mode_1 $S_DIR $D_DIR
        ;;
    2 ) 
        
        read -p "Enter the maximum number of copies: " n_copy
        main mode_2 $S_DIR $D_DIR $n_copy
        ;;
    * )
        echo "Enter a wrong value!"
        exit 1
        ;;
esac

exit 0