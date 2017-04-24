#!/bin/bash

#FUNCTIONS

#Encrypts Data.pg
#Algorithm: Numbers 1-50, Caesar cipher with left shift of 5
#e.g. 40 gets shifted to 35, 1 gets shifted to 46
function encrypt {
	declare -a array
	array=(`cat Data.pg`) #store all numbers in array
	for (( i = 0 ; i < 10 ; i++ ))
	do
		j=`expr ${array[$i]} - 1` #shift item in array left by 1
		for (( k = 0 ; k < 5 ; k++ ))
		do
			if [ $j -lt 1 ] 
			then
				j="50" #if exit range 1-50, reset to 50
			fi
			if [ $k -eq "4" ]
			then
				`echo $j >> Buffer.pg` #after shifting left 5 times, print number to temporary file
			fi
			j=`expr $j - 1`
		done
	done
	`cp Buffer.pg Data.pg` #replace original Data.pg with encrypted values
	`rm Buffer.pg`
}

#Decrypts Data.pg
function decrypt {
	declare -a array
	array=(`cat Data.pg`)
	for (( i = 0 ; i < 10 ; i++ ))
	do
		j=`expr ${array[$i]} + 1`
		for (( k = 0 ; k < 5 ; k++ ))
		do
			if [ $j -gt 50 ] 
			then
				j="1"
			fi
			if [ $k -eq "4" ]
			then
				`echo $j >> Buffer.pg`
			fi
			j=`expr $j + 1`
		done
	done
	`cp Buffer.pg Data.pg`
	`rm Buffer.pg`
}

#Generate Data.pg (10 random numbers between 1 and 50)
function getData {
	if [ -f Data.pg ]
	then
		echo -n 'You have played before. '
	else
		count=10
		i=0
		while [ $i -lt $count ]
		do
			number="$RANDOM" #generates number from 0-32767
			if [ $number -gt "0" ] && [ $number -lt "51" ]
			then
				`echo $number >> Data.pg`
				i=`expr $i + 1`
			fi
		done
	fi
}

#Check if guess is within 10% of 2/3rds of the average
function check {
	decrypt
	declare -a data
	data=(`cat Data.pg`) #stores all numbers in Data.pg
	sum=0
	for (( i = 0 ; i < 10 ; i++ ))
	do
		sum=`expr ${data[$i]} + $sum`
	done
	average=`echo "(2/3)*($sum/10)"|bc -l` #2/3 of average
	range=`echo "0.1*$average"|bc -l` #10% of average
	upBound=`echo "$average + $range"|bc -l`
	lowBound=`echo "$average - $range"|bc -l`
	cond1=$(echo "$guess < $upBound" | bc) #using bc to evaluate conditions because they contain floats
	cond2=$(echo "$guess > $lowBound" | bc)
	if [ $cond1 -eq "1" ] && [ $cond2 -eq "1" ]
	then
		return 1 #if guess is within 10% of 2/3 of average, return true
	else
		return 0 #else, return false
	fi
}

#Generate 5 random numbers representing number of tries
#Only runs first time game is played
function otherPlayers {
	if [ -f Players.pg ]
	then
		echo "Welcome back!"
	else
		count=5
		i=0
		while [ $i -lt $count ]
		do
			number="$RANDOM"
			if [ $number -gt "0" ] && [ $number -lt "4" ]
			then
				`echo $number >> Players.pg`
				i=`expr $i + 1`
			fi
		done
	fi
}

#Calculates the average of numbers in Players.pg
function avGuesses {
	declare -a averageGuesses
	averageGuesses=(`cat Players.pg`)
	total=0
	for (( i = 0; i < 5 ; i++ ))
	do
		total=`expr ${averageGuesses[$i]} + $total`
	done
	av=`echo "$total/5" | bc` #not using -l because want whole number
	echo $av
}

#Updates Data.pg by replacing first number in file with user's guess
function upData {
	`echo $guess >> Data.pg`
	`tail Data.pg >> tempData.pg` #stores last 10 numbers, including the newly added guess
	`cp tempData.pg Data.pg` #replace Data.pg with this new set of 10 numbers
	`rm tempData.pg`
}

#Updates Players.pg by replacing first number in file with winning user's number of guesses
function upPlayers {
	`echo $tries >> Players.pg`
	`tail -n 5 Players.pg >> tempPlayers.pg` #stores last 5 numbers
	`cp tempPlayers.pg Players.pg`
	`rm tempPlayers.pg`	

}

#MAIN PROGRAM

getData #generate Data.pg (10 random # from 1-50)
encrypt 
otherPlayers #generate Players.pg (# of guesses for past 5 players)
tries="1"
while [ $tries -lt "4" ] #loop for 3 tries
do
	echo 'Please input your guess:'
	read guess
	check
	if [ $? -eq "1" ]
	then #if guess is correct
		upData #add guess to Data.pg
		encrypt
		echo "Congratulations, you won!"
		echo "It took you $tries guesse/s."
		echo -n "Average guesses for other players: "
		avGuesses
		upPlayers #add number of guesses to Players.pg
		exit
	else #if guess is incorrect
		upData
		encrypt
		echo -n "Incorrect guess. "
		tries=`expr $tries + 1`
	fi
done
echo "Sorry, game over!"
echo -n "Average guesses for winning players: "
avGuesses



