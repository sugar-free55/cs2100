#include <stdio.h>

void display(int);

int main() {
	int ageArray[] = { 2, 15, 4, 23 };
	display(ageArray[0]);
    // print out size of the ageArray
    printf("Size of the array is %lu\n", sizeof(ageArray)/sizeof(int));
	return 0;
}

void display(int age) {
	printf("%d\n", age);
}
