#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include "lib.h"

void main(int argc, char *argv[]){
	printf("Main Process Started\n");
	int x = atoi(argv[1]);
	int y = atoi(argv[2]);
	printf("Number of Random Numbers = %d\n",x);
	printf("Fibonacci Input = %d\n",y);
	printf("Bubble Sort Process Created\n");
	int child_1 = fork();
	if (child_1==0){
		//First child process: sort
		printf("Bubble Sort Process Started\n");
		int array[x];
		srand(time(NULL));
		printf("Random Numbers Generated:\n");
		for (int i = 0; i < x; i++){
			array[i] = rand()%100;
			printf("%4d",array[i]);
		}
		sort(array,x);
		printf("\nSorted Sequence:\n");
		for (int j = 0; j < x; j++){
			printf("%4d",array[j]);
		}
		printf("\nBubble Sort Process Exits\n");
	}
	else {
		printf("Fibonacci Process Created\n");
		int child_2 = fork();
		if (child_2==0){
			//Second child process: fibonacci
			printf("Fibonacci Process Started\n");
			printf("Input Number: %d\n",y);
			long result = fib(y);
			printf("Fibonacci Number f(%d) is %ld\n",y,result);
			printf("Fibonacci Process Exits\n");
		}
		else {
			//Parent process
			printf("Main Process Waits\n");
			wait(child_1);
			wait(child_2);
			printf("Main Process Exits\n");
		}
	}
} 
