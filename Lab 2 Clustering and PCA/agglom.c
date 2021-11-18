/*******************************************************/
/*                                                     */
/*                     agglom.c                        */
/*                     ========                        */
/*                                                     */
/*     C programme to demonstrate agglomerative        */
/*                clustering on 2D data                */
/*                                                     */
/*        Version 2: Martin Russell                    */
/*                                                     */
/* School Electronic, Electrical & Computer Eng.       */
/*            University of Birmingham                 */
/*                                                     */
/*    To compile under linux:                          */
/*                 gcc -lm agglom.c                    */
/*                 mv a.out agglom                     */
/*                                                     */
/*    To run:                                          */
/*                 agglom ipFile Name opFileName       */
/*                                                     */
/*******************************************************/

#define MAX_STR_LEN 512
#define MAX_LIN_LEN 30
#define BIGNUM 1.0e12;
#define PRTINC 10;

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <math.h>
#include <ctype.h>


int main(int argc, char *argv[])
{
  FILE *ipFile;
  FILE *opFile;
  int i;
  int j;
  int k;
  float **x;
  float **dist;
  int numClus;
  int p;
  int c;
  int numRows;
  int numCols;
  char **label;


  /* Check correct number of input parameters */
  if (argc!=4)
    {
      printf("format: agglom ipFileName opFileName numClus\n");
      exit(1);
    }
  printf("input file open\n");

  /* set pointer to input data file */
  argv++;
  if ((ipFile=fopen(*argv,"r"))==NULL)
    {
      printf("Error: can't open input file %s\n",*argv);
      exit(1);
    }
  printf("output file open\n");

  /* set pointer to output data file */
  argv++;
  if ((opFile=fopen(*argv,"w"))==NULL)
    {
      printf("Error: can't open output file %s\n",*argv);
      exit(1);
    }

  /* set pointer to number of clusters */
  argv++;
  numClus=atoi(*argv);
  printf("Number of clusters = %d\n",numClus);

  /* read number of data points */
  if(fscanf(ipFile,"# num rows=%d num columns=%d\n",&numRows,&numCols)!=2)
    {
      printf("Format error in first line\n");
      exit(1);
    }

  printf("numRows=%d numCols=%d\n",numRows,numCols);

  /* allocate memory */
  x=(float **)calloc(numRows,sizeof(float *));
  dist=(float **)calloc(numRows,sizeof(float *));
  label=(char **)calloc(numRows,sizeof(char *));
  for (j=0; j<numRows; j++)
    {
      dist[j]=(float *)calloc(numRows,sizeof(float));
      x[j]=(float *)calloc(numCols,sizeof(float));
      label[j]=(char *)calloc(MAX_STR_LEN,sizeof(char));
    }
  i=numRows;

  /* read in labels and data points */
  for (j=0; j<numRows; j++)
    {
      int k;
      /* first read in label */
      /* fscanf(ipFile,"%s ",label[j]); */
      for (k=0; k<numCols; k++) 
	{
	  fscanf(ipFile,"%f ",&(x[j][k]));
	  /* printf("%f ", x[j][k]); */
	}
      fscanf(ipFile,"\n");
      /* printf("\n"); */
      
    }

  p=1;

  while (i > numClus)
    {
      /* calculate distance matrix and minimum */
      int e;
      float min;
      int ind[2];
      printf("numClus=%d\n",i);
      min=BIGNUM;
      for (j=0; j<i; j++)
	for (k=j+1; k<i; k++)
	  {
	    dist[j][k]=0;
	    for (e=0; e<numCols; e++) dist[j][k]+=(x[j][e]-x[k][e])*(x[j][e]-x[k][e]);

	    if (dist[j][k] < min)
	      {
		ind[0]=j;
		ind[1]=k;
		min=dist[j][k];
	      }
	  }
      /* combine */
      /* printf("combine\n"); */
      for (e=0; e<numCols; e++) x[ind[0]][e]=(x[ind[0]][e]+x[ind[1]][e])/2;

      /* decrement numClus */
      i--;

      for (k=ind[1]; k<numRows-1; k++)
	{
	  for (e=0; e<numCols;e++) x[k][e]=x[k+1][e];
	}
    }
  /* write centroids to file */
  fprintf(opFile,"# num rows=%d num columns=%d\n",numClus,numCols);
  for (c=0; c<numClus; c++)
    {
      int e;
      /* fprintf(opFile,"c%d ",c);*/
      for (e=0; e<numCols;e++) fprintf(opFile,"%f ",x[c][e]);
      fprintf(opFile,"\n");
    }

  return(0);
}

