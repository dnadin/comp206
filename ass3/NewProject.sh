#!/bin/bash
# compile function created by Vasileios Airantzis and modified by Joseph Vibihal

#1) CREATE DIRECTORY STRUCTURE

#Check command line syntax and set variables

if [ $# -gt 2 ] #check project name is one word
then
	echo 'Project name must be one word. Type in: NewProject path project_name'
	exit
elif [ $# -eq 2 ]
then
	project_name="$2"
	if [ -d $1 ] #check path name is correctly formed
	then
		path="$1"
	else
		echo 'Your path name is malformed. Type in: NewProject path project_name'
		exit
	fi		
else
	if [ -d $1 ] #check project name is provided
	then
		echo 'Project name is missing. Type in: NewProject path project_name'
		exit
	else
		project_name="$1"

	fi
fi

#Create subdirectory and best practice directory structure

if [ $path ]
then
	mkdir $path/$project_name
	cd $path/$project_name
	mkdir docs 'source' backup archive
	cd source
else
	mkdir $project_name
	cd $project_name
	mkdir docs 'source' backup archive
	cd source
fi
		
#2) CREATE COMPILER

touch compile
chmod +x compile

echo "#!/bin/bash

#Check command line syntax and set variables
if [ "'"$1"'" = "'"-o"'" ]
then
	switch="'"$1"'"
	executable="'"$2"'"
	filenames="'"${@:3}"'"
else
	filenames="'"${@:1}"'"
fi		

if [ "'"$filenames"'" = "'"null"'" ];
then
	echo "'"You are missing file names. Type in: compile -o executable_name file_names"'"
	exit
fi

#Copy files to backup
cp -r * ../backup/

#Compile
touch errors
if [ "'"$1"'" = "'"-o"'" ]
then
	gcc -o "'"$executable"'" "'"$filenames"'" 2> errors
else
	gcc -o "'"$filenames"'" 2> errors
fi

#Display errors
more errors" > compile
