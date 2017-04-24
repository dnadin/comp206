#include <stdio.h>
#include <stdlib.h>

double fib(int n);

int main (int argc, char *argv[]){
	
	//Sum of numbers in file
	int sum = 0;
	int temp;
	FILE *in = fopen(argv[1],"rt");
	fscanf(in,"%d",&temp);
	while(!feof(in)){
		sum=sum+temp;
		fscanf(in,"%d",&temp);	
	}
	fclose(in);
	printf("The sum of numbers is %d\n\n",sum);

	//Fibonacci sequence of numbers in file
	float fibonacci;
	int temp2;
	printf("The Fibonacci Sequence of each number is:\n\n");
	FILE *in2 = fopen(argv[1],"rt");
	fscanf(in2,"%d",&temp2);
	while(!feof(in2)){
		fibonacci=fib(temp2);
		printf("Fib(%d) is %.0f\n",temp2,fibonacci);
		fscanf(in2,"%d",&temp2);
	}
	fclose(in2);
}

//Calculate Fibonacci sequence
double fib(int n){
	double f[n+1];
	f[0]=0;
	if (n>0)
		f[1]=1;
	if (n>1)
		f[2]=1;
	for (int i = 3; i <= n; i++)
		f[i]=f[i-1]+f[i-2];
	return f[n];
}
