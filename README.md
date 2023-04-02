# MIPS assignment
translate each c code to MIPS code
should follow the rules of MIPS (a, s, v, t, caller, callee)

### Q1
```c=
#include <stdlib.h>
#include <stdio.h> 

int calculateBMI(int height, int weight) {
	int bmi = (weight * 10000) / (height * height);
	return bmi; 
}

void printResult (int bmi) { 
	if (bmi < 18)
		printf("%s", "underweight\n"); 
	else if (bmi > 24)
		printf("%s", "overweight\n"); 
	else
		printf("%d\n", bmi); 
}

int main() {  
	int height, weight, bmi; 
	while (1) {
		scanf("%d", &height); 
		if (height == -1)
			break;  
		scanf("%d", &weight);  
		bmi = calculateBMI(height, weight); 
		printResult(bmi);
	}  
	return 0;
}
```
|input |output|
|-----|--------|
|180 <br>59<br>180<br>58<br>180<br>90<br>-1|18<br>underweight<br>overweight       |
|180 <br>80<br>180<br>81<br>180<br>50<br>-1|24<br>overweight<br>underweight       |
|178 <br>80<br>150<br>50<br>196<br>76<br>190<br>44<br>-1|overweight<br>22<br>19<br>underweight       |


### Q2
```c=
#include <stdlib.h>
#include <stdio.h>  

int fib(int n, int  dp[]) {
	if (dp[n]!= 0) { 
		printf("%d\n", dp[n]);
		return dp[n]; 
	}

	if (n == 1 || n == 2) { 
		dp[n] = 1;  
		return 1;
	}
	
	else {  
		dp[n] = fib(n-1, dp) + fib(n-2, dp);  
		if (dp[n] % 3 ==0) 
			printf("%d\n", dp[n]);
		return dp[n];
	} 
}  

int main() {
	int data[200];  
	int answer = 0, num = 0, i=0; 
	for (i=0; i<200; i++) 
		data[i]=0; 
	scanf("%d", &num);  
	answer = fib(num, data); 
	printf("%d\n ", answer);  
	return 0;
}
```

|input |output|
|-----|--------|
|8|1<br>3<br>2<br>3<br>5<br>8<br>21<br>21       |
|2|1      |
|13|1<br>3<br>2<br>3<br>5<br>8<br>21<br>13<br>21<br>34<br>55<br>144<br>89<br>233       |

### Q3

```c=
#include <stdlib.h>
#include <stdio.h>  

void insertionSort(int array[], int length) {
	for (int i = 1; i < length; i++) {  
		int current = array[i];  
		int j = i - 1;  
		while (j >= 0 && array[j] > current) {
			array[j + 1] = array[j];
			j--; 
		}
		
		printf("%d\n", j + 1);  
		array[j + 1] = current;
	}
}

int main() {
	int array[5];  
	for (int i = 0; i < 5; i++) {
		scanf("%d", &array[i]); 
	} 
	insertionSort(array, 5); 
	for (int i = 0; i < 5; i++)
		printf("%d\n",array[i]);
	}  
	return 0;
}
```

|input |output|
|-----|--------|
|5<br>5<br>5<br>5<br>5|1<br>2<br>3<br>4<br>5<br>5<br>5<br>5<br>5       |
|55<br>12<br>35<br>42<br>11|0<br>1<br>2<br>0<br>11<br>12<br>35<br>42<br>55      |
|6<br>3<br>2<br>5<br>1|0<br>0<br>2<br>0<br>1<br>2<br>3<br>5<br>6       |

### Q4
```c=
#include <stdlib.h>
#include <stdio.h> 

void inputMatrix(int A[3][3]) {
	for(int i=0;i<3;i++) { 
		for (int j = 0; j < 3; j++){
			scanf("%d", &A[i][j]); 
		}
	}
}  

void transposeMatrixA1(int A[3][3], int T[3][3], int size) {
	for (int i = 0; i < size; i++) { 
		for (int j = 0; j < size; j++){
			T[j][i]=A[i][j]; 
		}
	}
}

void transposeMatrixA2(int *B, int *T, int size) { 
	int *ptrB, *ptrT, i;
	
	for (ptrB=B, ptrT=T, i = 1; ptrB<(B + (size*size)); ptrB++) { 
		*ptrT = *ptrB;  
		if(i<size) {
			ptrT += size;  
			i++;
		}	
		else{  
			ptrT -= (size * (size - 1) - 1);
			i = 1; 
		}
	}
}

void outputMatrix(int A[3][3]) {
	for (int i = 0; i < 3; i++){
		for (int j = 0; j < 3; j++){
			printf("%d",A[i][j]);
		}
		printf("\n");
	}
}

int main() {  
	int A[3][3];  
	int transposeOfA1[3][3];  
	int transposeOfA2[3][3];  
	int *ptrA = &A[0][0];  
	int *ptrTA2 = &transposeOfA2[0][0]; 
	inputMatrix(A);  
	transposeMatrixA1(A, transposeOfA1, 3); 
	transposeMatrixA2(ptrA, ptrTA2, 3); 
	outputMatrix(transposeOfA1); 
	outputMatrix(transposeOfA2);
	return 0;
}
```

|input |output|
|-----|--------|
|1<br>2<br>3<br>4<br>5<br>6<br>7<br>8<br>9|1 4 7<br>2 5 8<br>3 6 9<br>1 4 7<br>2 5 8<br>3 6 9       |
|90<br>55<br>33<br>11<br>22<br>44<br>66<br>77<br>88|90 11 66<br>55 22 77<br>33 44 88<br>90 11 66<br>55 22 77<br>33 44 88       |
|12<br>34<br>79<br>56<br>22<br>35<br>11<br>23<br>32|12 56 11<br>34 22 23<br>79 35 32<br>12 56 11<br>34 22 23<br>79 35 32<br>       |
