#include <stdlib.h>
#include <stdio.h>
#include <string.h>

char *my_strncpy(char *s, char *t, int n);
char *my_strncat(char *s, char *t, int n);
int my_strncmp(char *s, char *t, int n);

int main(void){

	//Don't know what size input will be, so give an arbitrary size.
	int max_size = 100; 
	int current_size = max_size;

	//Read first string from user and create backup
	char *s1 = malloc(current_size);
	char *backup = malloc(current_size);
	printf("Enter the first string: ");
	int c = getc(stdin);
	int i = 0;
	while(c!='\n'){ //while user has not pressed enter
		s1[i] = c; //add char to string
		backup[i] = c;
		i++;
		if (i==current_size){ //if go over the arbitrary size, add more space
			current_size = i+max_size;
			s1 = realloc(s1, current_size);
			backup = realloc(backup, current_size);
		}
		c = getc(stdin);
	}
	if (c=='\n'){ //add null char at end of string
		s1[i]='\0';
		backup[i]='\0';
	}

	//Reinitialize variables
	current_size = max_size = 100;
	i = 0;

	//Read second string from user
	char *s2 = malloc(current_size);
	printf("Enter the second string: ");
	c = getc(stdin);
	while(c!='\n'){
		s2[i] = c;
		i++;
		if (i==current_size){
			current_size = i+max_size;
			s2 = realloc(s2, current_size);
		}
		c = getc(stdin);
	}
	if (c=='\n'){
		s2[i]='\0';
	}
	
	current_size = max_size = 100;
	i = 0;

	//Read number from user
	int num;
	printf("Enter the number: ");
	scanf("%d",&num);

	//Print strncpy, strncat and strncmp
	printf("strncpy is '%s'\n", my_strncpy(s1,s2,num));
	//reset s1 to its initial state so that strncat will operate on the original string
	for (int j = 0; j < strlen(backup); j++){
		s1[j] = backup[j];
	}
	printf("strncat is '%s'\n", my_strncat(s1,s2,num));
	int x = my_strncmp(backup,s2,num);
	if (x==-1)
		printf("strncmp is '%s' < '%s'\n",backup,s2);
	else if (x==1)
		printf("strncmp is '%s' > '%s'\n",backup,s2);
	else
		printf("strncmp is '%s' = '%s'\n",backup,s2);
}

char *my_strncpy(char *s, char *t, int n){
	int i;
	for ( i = 0; i < n; i++ )
		 *(s+i)=*(t+i); //copy char from t to s
	for ( ; i < n ; i++)
		*(s+i) = '\0'; //fill all unfilled space in s with null chars, as in the original strncpy
	for ( i = n; i < strlen(s); i++)
		*(s+i) = '\0';
	return s;
}

char *my_strncat(char *s, char *t, int n){
	int length = strlen(s); //stores original length of s
	int i;
	*(s+length) = (char)32; //add white space to end of original s
	for ( i = 1; i < n+1 ; i++)
		*(s+length+i) = *(t+i-1); //add char from t to s
	for ( ; i < n+1 ; i++)
		*(s+length+i) = '\0'; //fill final spot with null char
	return s;
}

int my_strncmp(char *s, char *t, int n){
	int result;
	//Loop through each character of both strings
	for (int i = 0; i < n && i < strlen(s) ; i++){
		for (int j = i; j < n && j < strlen(t) ; j++){
			//If do not match, return value. If match, go to next iteration of loop.
			if (*(s+i) < *(t+j)){
				result = -1;
				i = n;
			}
			else if (*(s+i) > *(t+j)){
				result = 1;
				i = n;
				
			}
			else if (j==(n-1)){
				result = 0;
				i = n;
			}
			break;
		}
	}
	return result;
}

