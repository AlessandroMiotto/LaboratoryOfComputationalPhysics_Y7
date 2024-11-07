#!/bin/bash

dir_name="students"
file_name="LCP_22-23_students.csv"


cd $HOME

if [ ! -d "$HOME/$dir_name" ]
then
	echo "Creating $dir_name"
	mkdir $dir_name
fi

cd $dir_name

if [ ! -f "$HOME/$dir_name/$file_name" ]
then
	echo "Downloading $file_name"
	wget https://www.dropbox.com/s/867rtx3az6e9gm8/$file_name
fi


echo "Separating Physics of Data students from Physics"

touch PoD.csv
grep "PoD" $file_name > PoD.csv

touch Physics.csv
grep "Physics" $file_name > Physics.csv


max_letter="A"
max_number=0

for i in {A..Z}
do
	#echo -n "$i -> "
	number=$( grep "^$i" $file_name | grep -v -c "Family" )
	#echo $number

	if [ $number -gt $max_number ]
	then
		max_number=$number
		max_letter=$i
	fi
done

echo "The most common starting letter surname is $max_letter with $max_number occurrences"

echo "Subdividing students in 18 groups"

rm group*
for i in {0..17}
do
	touch "group_$i.csv"
done

group=0
while IFS=, read -r line
do
	group=$(((group+1)%18))
	if [[ $line =~ "Family" ]]
	then
		continue
	fi
	echo $line >> "group_$group.csv"
done < $file_name
