#!/bin/bash

#1) CREATE DIRECTORY STRUCTURE

#Check command line syntax and set variables

if [ -d $1 ]
then
	file_list=`echo $@ | cut -d' ' -f3-` #String containing file names
	project_name="$2"
	path="$1"
else
	file_list=`echo $@ | cut -d' ' -f2-`
	project_name="$1"
fi
		
if [ $project_name = "" ]
then
	echo 'Project name is missing. Type in: NewProject2 path project_name file_list'
	exit
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

touch makefile

declare -a file_list_o #list of all .o files
declare -a file_list_h #will contain list of .h files that have .o files

#Count number of file names on command line
length=0
for file in $file_list
do
	length=$(($length + 1))
done

#Fill file_list_o with .o files
counter=0
for x in $file_list
do
	for ((i=$counter; i<$length; i++))
	do
		file_list_o[$i]=$(echo $x | cut -f1 -d'.') #removes .c extension
		file_list_o[$i]=$(echo ${file_list_o[$i]}.o) #replaces with .o extension
		break
	done
	counter=$(($counter + 1))
done

#Fille file_list_h with .h files
counter2=0
for y in $file_list
do
	for ((j=$counter2; j<$length; j++))
	do
		file_list_h[$j]=$(echo $y | cut -f1 -d'.')
		file_list_h[$j]=$(echo ${file_list_h[$j]}.h)
		break
	done
	counter2=$(($counter2 + 1))
done

#First line of makefile
echo "a.out: ${file_list_o[@]}
	gcc -o a.out ${file_list_o[@]}" >> makefile

#Subsequent lines of makefile
counter3=0
for z in $file_list
do
	for ((k=$counter3; k<$length; k++))
	do
		z=$(echo $z | cut -f1 -d'.') #remove extension
		echo "$z.o: $z.c ${file_list_h[@]}
	gcc -c $z.c" >> makefile
		file_list_h[$k]=$null #removes file from list of .h files
		break
	done
	counter3=$(($counter3 + 1))
done
