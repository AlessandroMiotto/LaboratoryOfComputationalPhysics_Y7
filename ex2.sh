#!/bin/bash

echo "Removing metadata and commas from data.csv - saving to data.txt"
(grep -v "^#" data.csv | sed -e "s/,/ /g") > data.txt

echo -n "The number of even values are "
grep -c "[0,2,4,6,8] " data.txt

x=($(ps -u miotto | awk '{print $1}' data.txt))
y=($(ps -u miotto | awk '{print $2}' data.txt))
z=($(ps -u miotto | awk '{print $3}' data.txt))

counter=0
compar=7500
for i in "${!x[@]}"
do
	val=$((${x[i]}**2+${y[i]}**2+${z[i]}**2))
	#echo $val
	if [ $val -gt $compar ]
	then
		counter=$(($counter+1))
	fi
done

echo "sqrt(X^2+Y^2+Z^2) > 100*sqrt(3)/4 in $counter case"

n=0
read -p "Enter number of files with n-th division: " n

for (( i=1; i<=$n; i++ ))
do
	awk -v c=$i '{ for (i = 1; i <= NF; ++i) $i /= c; print }' data.txt > data_$i.txt
done
