//Pre-processor commands
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

//Prototype
void encrypt(char *og, FILE *x, int y);

//Main
int main(int argc, char *argv[]){
	FILE *filename = fopen(argv[1],"r");
	char *original = argv[1];
	int key = atoi(argv[2]);
	encrypt(original,filename,key);
	return 0;
}

void encrypt(char *og, FILE *x, int y){
	int letter = fgetc(x); //get first char in file
	char buffer[15000]; //will store encrypted characters
	int k = 0; //will count through buffer
	while(!feof(x)){ //repeat until EOF
		if(isalpha(letter)){ //if char is a letter
			int j = letter - 1; //shift left by 1
			for (int i = 0; i < y; i++){
				if(!isalpha(j)){
					if(90<j<97){ //if char is beyond range a to z, reset to z
						j = 122;
					}
					else if(0<j<65){ //if char is beyond range A to Z, reset to Z
						j = 90;
					}
				}
				if(i==(y-1)){ //if have shifted by y, print char
					buffer[k]=j;
					k++; //only move forward in buffer array when a char gets printed
				}
				j--;
			} 
		}
		else{ //if char is not a letter (white space, carriage return or line feed), do not change
			buffer[k]=letter;
			k++;
		}
		letter = fgetc(x); //get next char in file
	}
	fclose(x);
	FILE *output = fopen(og,"wt"); //reopen the file in write mode (erases contents)
	for (int i = 0; i < k; i++){
		fprintf(output,"%c",buffer[i]); //print encrypted text to file
	}
	fclose(output);
}
