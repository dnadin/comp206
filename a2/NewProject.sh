#!/bin/bash

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
	cd ~
else
	mkdir $project_name
	cd $project_name
	mkdir docs 'source' backup archive
	cd ~
fi
		
#2) CREATE COMPILER

if [ $path ]
then
	cd $path/$project_name
	`touch compile`
	cd ~
	y="./$path/$project_name/compile"
else
	cd $project_name
	`touch compile`
	cd ~
	y="./$project_name/compile"
fi

echo '#!/bin/bash

#Check command line syntax and set variables
if [ $1 = '-o' ]
then
	if [ $# -lt 3 ]
	then
		echo 'You are missing file names. Type in: compile -o executable_name file_name/s'
		exit 1
elif [ -f $3 ]
	then
		executable_name="$2"
		filename="$3"
		args=`echo $@ | cut -d' ' -f3-` #String containing only file names
	else
		echo 'You are missing file names. Type in: compile -o executable_name file_name/s'
		exit 1
	fi
else
	if [ -f $1 ]
	then
		filename="$1"
		args=`echo $@ | cut -d' ' -f1-`
	else
		echo 'You are missing file names. Type in: compile -o executable_name file_name/s'
		exit 1
	fi
fi

#Copy files to backup
for file in $args
do
	`cp $file ./backup`	
done

#Compile
for file in $args
do
	if [ $1 = '-o' ]
	then
		`gcc -o $executable_name $file 2> errors`
	else
		`gcc $file 2> errors`
	fi
done

#Display errors
more errors' >> $y

chmod +x $y
