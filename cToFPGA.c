#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>

/** define input buffer for below **/
#define BUFFER 1000
#define TICKS_MOTOR_1 2871
#define TICKS_MOTOR_2 1651
#define TICKS_MOTOR_3 3068
#define TICKS_MOTOR_4 2286
#define TICKS_MOTOR_5 1431

//static const char* exFile = "ap.txt";
//static char inputBuffer[ BUFFER ];

int main(int argc, const char** argv){

	//set outfile to fifo name
	static const char* outFile = "c_to_java";
	static const char* inFile = "java_to_c";
	static const char* thetas = "thetas.txt";
	int fd;
	void *map_addr;
	int size = 4;

	fd = open("/dev/uio0", O_RDWR);

	if (fd < 0) {
		perror("Failed to open devfile");
		exit(1);
	}

	map_addr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (map_addr == MAP_FAILED) {
		perror("Failed to map");
		exit(1);
	}

	//open fifo for writing
	
	int16_t ard1[4] = {5637,5626,-2857,-2824};
	int16_t ard2[4] = {0,0,0,0};
	int16_t ard3[4] = {2774,2417,4637,4439};
	int16_t ard4[4] = {-81,243,-118,377};
	int16_t ard5[4] = {81,-243, 118,-377};

	int c = 0;

	while(1) {	
		FILE *theta_f = fopen(thetas, "r"); 
		char thetas_str[5][10];
		int i;
		for(i=0; i<5; i++) {
			fgets(thetas_str[i], 9, theta_f); 
		}
		fclose(theta_f);
		int16_t ticks[5];
	//	double thetas_deg[5];
		
		ticks[0] = ard1[c]; 
		ticks[1] = ard2[c];
		ticks[2] = ard3[c]; 
		ticks[3] = ard4[c];
		ticks[4] = ard5[c]; 
		//for(i=0; i<5; i++) {
		//	ticks[i] = atoi(thetas_str[i]);
			//thetas_deg[i] = thetas_rad[i] * 57.2957795;
		//}

	//	uint16_t ticks[5];
/*		ticks[0] = thetas_deg[0] * TICKS_MOTOR_1;
		ticks[1] = thetas_deg[1] * TICKS_MOTOR_2;
		ticks[2] = thetas_deg[2] * TICKS_MOTOR_3;
		ticks[3] = thetas_deg[3] * TICKS_MOTOR_4;
		ticks[4] = thetas_deg[4] * TICKS_MOTOR_5;*/

//	int fd_in = open(inFile, O_RDONLY);
	//int x = 0;
	//uint8_t inVal[BUFFER];
/*	while(1) {
		//x = fscanf(fp_in, "%d\n", &inVal);
		x = read(fd_in, inVal, sizeof(uint8_t)*BUFFER);
		if (x != 0) 
			 break;
	} 
//	printf("%d\n", x);
	printf("%d\n", inVal[0]);
	printf("%d\n", inVal[1]);
	//fprintf(fd_out,"%"PRIu64",%"PRIu64",%f\n",total,n,average);
  */ 

//	fclose(fd_out);
//	close(fd_in);


/*	FILE *fd_out = fopen(outFile,"w");
	fprintf(fd_out, "%d\n", inVal[0]);
	fprintf(fd_out, "%d\n", inVal[1]);
	fclose(fd_out);*/
	

		volatile unsigned int *pointer = map_addr;
		*pointer = ticks[4] | (ticks[3] << 16);
		printf("goal3: %d\n", ticks[3]);
		printf("goal4: %d\n", ticks[4]);
		printf("ticks: %d %d\n", (*pointer & 0xff), (*pointer >> 16) & 0xff);
		
		if (c != 3) {
			c = c+1;
		}
		else {
			c = 0;
		}
		sleep(10);
	}
	return (0);
}
