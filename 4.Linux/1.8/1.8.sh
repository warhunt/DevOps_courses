#!/bin/bash
count=1

while [ "$count" -le 300 ]
do
    number=$((RANDOM%6+1))
    case "$number" in
        1 ) let "ones += 1";;
        2 ) let "twos += 1";;
        3 ) let "threes += 1";;
        4 ) let "fours += 1";;
        5 ) let "fives += 1";;
        6 ) let "sixes += 1";;
    esac
    let "count += 1"
done

echo "единиц = $ones"
echo "двоек = $twos"
echo "троек = $threes"
echo "четверок = $fours"
echo "пятерок = $fives"
echo "шестерок = $sixes"
exit 0