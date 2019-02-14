#!/bin/bash

rm -f executable_file.bash
while :
do
    echo "Enter the Username : "
    read user_name

    if getent passwd $user_name >/dev/null 2>&1;
    then
        break
    else
        echo "Username does not exists. Please enter a valid username"
    fi
done

while :
do
    echo "Enter the Group name : "
    read group_name

    if getent group $group_name >/dev/null 2>&1;
    then
        break
    else
        echo "Group name does not exists. Please enter a valid group name"
    fi
done

while :
do
    echo "Enter the Absolute or relative path of the directory : "
    read dir
    dir_path=$(readlink -f $dir)

    if [[ -d $dir_path ]];
    then
        break
    else
        echo "This directory does not exists. Please enter a valid directory"
    fi
done

while read -r line;
do
	permi=$(echo "$line" | awk '{print $1}' | tr -d '[')
	us=$(echo "$line" | awk '{print $2}')
	gp=$(echo "$line" | awk '{print $3}')
	pth=$(echo "$line" | awk '{print $5}')
	
	echo "  " >> executable_files.txt
	echo -n "$pth $permi" >> executable_files.txt

	if [[ "$us" == "$user_name" ]]; then
		if echo $permi | grep ...x......>/dev/null 2>&1; then
			echo -n " Y U" >> executable_files.txt
		else
			echo -n " N N" >> executable_files.txt
		fi
	fi
		
	if [[ "$gp" == "$group_name" ]]; then
		if echo $permi | grep ......x...>/dev/null 2>&1; then
			echo -n " Y G" >> executable_files.txt
		else
			echo -n " N N" >> executable_files.txt
		fi
	fi
		
	if echo $permi | grep .........x >/dev/null 2>&1; then
			echo -n " Y O" >> executable_files.txt
	else
			echo -n " N N" >> executable_files.txt
	fi

done < <(tree -pufig "$dir_path" | grep -F \[)
exit		
	
	
