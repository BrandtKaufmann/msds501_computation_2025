#!/bin/sh
# Brandt Mariela & Niki

if [ $# -ne 2 ]
	then echo "Please check the format.\nExample: \"sh ./hw1.sh git_url folder_path\""
	exit 1
fi

url=$1
dir=$2

if [ -d $dir ]
then
	cd $dir
	if git pull
	then
		echo "Success: Pulled from $url to $dir"
		ls -l
	else
		echo "Failed to pull from $url to $dir"
		exit 1
	fi
else
	if git clone $url $dir
	then
		echo "Success: Cloned from $url to $dir"
		cd $dir
		ls -l
	else
		echo "Failed to clone from $url to $dir"
		exit 1
	fi
fi