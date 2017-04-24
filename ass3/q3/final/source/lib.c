void sort(int x[], int n){
	//sort n random ints between 0 and 99  using bubble sort
	for (int i = 0; i < n; i++){
		for (int j = 0; j < (n-1); j++){
			if(x[j]>x[j+1]){
				int temp = x[j+1];
				x[j+1] = x[j];
				x[j] = temp;
			}
		}
	}
}

long fib(int y){
	//Compute yth fibonacci number using recursion algorithm 1
	if(y<=2)
		return 1;
	else
		return fib(y-1)+fib(y-2);
}
