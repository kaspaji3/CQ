/*
 * primes_serial.c
 *  Circular queue tester
 * @author Jiri Kaspar, CVUT FIT
 *
 * verze 0.9.7  9.12.2017
 *
 *
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <math.h>

#define SHARED volatile
#define ALIGNED __attribute__ ((aligned (64)))

#include "CQ.h"

unsigned short int *primes;
unsigned int max_prime;
unsigned int max_prime_sqrt;
unsigned int last_prime;
//unsigned int known_primes = 1;
unsigned int required_primes = 1;
unsigned int local_max=4;
unsigned int num=1;
unsigned int p=3;
FILE *f;

void appl_help () {
  printf("prime MAX \n");
}

void appl_init(int argc, char **argv) {
int a=1;
// double d;
  if ( (argc > 1) && (sscanf (argv[1], "%u", &max_prime) != 1) ) argc = 1;
  if (argc < 2) {
    appl_help();
    exit(1);
  }
//  primes = malloc( max_prime * sizeof(unsigned short int) );
//  d = max_prime;
//  d = sqrt( d );
//  max_prime_sqrt = d;
//  primes = malloc( max_prime_sqrt * sizeof(unsigned short int) );
  primes = malloc( 65536 * sizeof(unsigned short int) );
  primes[0]=2;
  f = fopen("primes.txt","w");
  fprintf (f,"%d\n", 2);
}

void appl_run (int thread, int stage, int index, CQhandle *input, CQhandle *output) {
int i;

  if (thread != 0) return;
  while (p < max_prime) {
    while ( (p < local_max) && (p < max_prime) ) {
      for (i=1; i<required_primes; i++) {
	if (p % ((unsigned int) primes[i]) == 0) break;
      }
      if (i >= required_primes) {
	if (p < 65536) {
	  primes[num++]= (unsigned short int) p;
	}
//	known_primes++;
	last_prime = p;
        fprintf (f,"%u\n", p);
      }
      p+=2;
    }
    local_max = ((unsigned int) primes[required_primes]) *
		  ((unsigned int) primes[required_primes]);
    required_primes++;
  }
  printf("prime: %u\n", last_prime);
  fclose(f);
  free(primes);
}

void appl_stat () {
}

//int main(int argc, char **argv) {
//  appl_init(argc, argv);
//}
