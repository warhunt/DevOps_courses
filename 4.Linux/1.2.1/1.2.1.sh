#!/bin/bash

function random_range {
    echo `shuf -i $1-$2 -n 1`
}

function generate_name {
    local lenght=$(random_range 2 9)
    echo `head -3 /dev/urandom | tr -dc 'a-zA-Z0-9' | cut -c -$lenght`
}

function create_one_file {
    local name=$(generate_name)
    local size=$(random_range 1 $2)
    declare -a data=( $(for i in $(seq 1 $size); do echo 0; done) )
    printf "%s" "${data[@]}" > "$1/$name"
}

function create_one_dir {
    local name=$(generate_name)
    local new_dir="$1/$name"
    mkdir $new_dir
    echo $new_dir
}

function calc_number_of_file {
    let local n_elements_in_dir=`find $2 -maxdepth 1 | wc -l`
    let "n_elements_in_dir -= 1"
    let local max_n_file=$1-$n_elements_in_dir+1
    local n_file=$(random_range 1 $max_n_file)
    echo $n_file
}

function create_all_elems {
    local count=$(random_range 1 $1)

    local depth=$3
    let "depth -= 1"

    for i in $(seq $count)
    do 
        if [ $3 -gt 0 ]; then
            new_dir=$(create_one_dir $2)
            create_all_elems $1 $new_dir $depth $4
        fi  
    done

    n_file=$(calc_number_of_file $1 $2)

    for i in $(seq $n_file)
    do
        create_one_file $2 $4
    done
}

options=$(getopt -l "dir:,depth:,max_iter:,max_file_size:" -o "D:d:i:s:" -a -- "$@")
[ $? -eq 0 ] || { 
    echo "Incorrect options provided"
    exit 1
}
eval set -- "$options"
while true; do
    case "$1" in
        -D|--dir) 
            shift;
            DIR=$1
            ;;
        -d|--depth)
            shift;
            DEPTH=$1
            ;;
        -i|--max_iter)
            shift;
            MAX_ITER=$1
            ;;
        -s|--max_file_size)
            shift;
            MAX_FILE_SIZE=$1
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

create_all_elems $MAX_ITER $DIR $DEPTH $MAX_FILE_SIZE

exit 0
