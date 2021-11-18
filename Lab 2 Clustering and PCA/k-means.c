/*********************************************************/
/*                                                       */
/*                     k-means.c                         */
/*                     =========                         */
/*                                                       */
/*        C programme to demonstrate k-means             */
/*              clustering on vector data                */
/*                                                       */
/*        Version 2: Martin Russell                      */
/*                                                       */
/* School of Electronic, Electrical & Computer Eng.      */
/*            University of Birmingham                   */
/*                                                       */
/*    To compile under linux:                            */
/*                 gcc -lm k-means.c                     */
/*                 mv a.out k-means                      */
/*                                                       */
/*    To run:                                            */
/*                 k-means ipFile centroids opFile numIt */
/*                                                       */
/*********************************************************/

#define MAX_STR_LEN 512
#define MAX_LIN_LEN 30
#define BIGNUM 1.0e12
#define PRTINC 10

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <math.h>
#include <ctype.h>


int main(int argc, char *argv[])
{
  FILE *ipFile;
  FILE *centFile;
  FILE *opFile;
  int i;
  int j;
  int k;
  float **x;
  float **cent;
  float *mean;
  float **dist;
  int *bestCent;
  char **label;
  char **cLabel;
  int it;
  int numRows;
  int numCols;
  int numCols2;
  int numCent;
  float *distortion;
  int NUMIT=100;

  /* Check correct number of input parameters */
  if ((argc!=5)&&(argc!=4))
    {
      printf("format: k-means ipFile centroids opFile <numIt>\n");
      exit(1);
    }
  if (argc==4) NUMIT=10;

  /* allocate space for distortion scores */
  distortion=(float *)calloc(NUMIT, sizeof(float));

  printf("open input data file\n");
  /* set pointer to input data file */
  argv++;
  if ((ipFile=fopen(*argv,"r"))==NULL)
    {
      printf("Error: can't open input data file %s\n",*argv);
      exit(1);
    }

  printf("open input centroid file\n");
  /* set pointer to centroid data file */
  argv++;
  if ((centFile=fopen(*argv,"r"))==NULL)
    {
      printf("Error: can't open input centroid file %s\n",*argv);
      exit(1);
    }

  printf("open output centroid file\n");
  /* set pointer to outnput data file */
  argv++;
  if ((opFile=fopen(*argv,"w"))==NULL)
    {
      printf("Error: can't open output centroid file %s\n",*argv);
      exit(1);
    }

  /* set pointer to number of iterations */
  argv++;
  NUMIT=atoi(*argv);
  printf("Number of iterations = %d\n",NUMIT);

  /* read number of data points */
  if(fscanf(ipFile,"# num rows=%d num columns=%d\n",&numRows,&numCols)!=2)
    {
      printf("Format error in first line\n");
      exit(1);
    }

  printf("Data file: numRows=%d numCols=%d\n",numRows,numCols);

  /* allocate memory */
  x=(float **)calloc(numRows,sizeof(float *));
  dist=(float **)calloc(numRows,sizeof(float *));
  /* label=(char **)calloc(numRows,sizeof(char *)); */
  mean=(float *)calloc(numCols,sizeof(float));
  for (j=0; j<numRows; j++)
    {
      x[j]=(float *)calloc(numCols,sizeof(float));
      /* label[j]=(char *)calloc(MAX_STR_LEN,sizeof(char));*/
    }
  i=numRows;

  /* read in data points */
  for (j=0; j<numRows; j++)
    {
      int k;
      /* first read in label */
      /* fscanf(ipFile,"%s ",label[j]); */
      for (k=0; k<numCols; k++) 
	{
	  fscanf(ipFile,"%f ",&(x[j][k]));
	  mean[k]+=x[j][k];
	}
      fscanf(ipFile,"\n");
    }

  printf("Info: number of data points = %d\n",numRows);
  for (k=0; k<numCols; k++) mean[k]/=numRows;

  /* get number of centroids */
  if(fscanf(centFile,"# num rows=%d num columns=%d\n",&numCent,&numCols2)!=2)
    {
      printf("Format error in first line of input centoid file\n");
      exit(1);
    }
  if (numCols!=numCols2)
    {
      printf("Incompatible - columns in centroid and data files different\n");
      exit(1);
    }

  printf("numCentroid=%d, numCols=%d\n",numCent,numCols2);

  /* allocate memory */
  cent=(float **)calloc(numCent,sizeof(float *));
  /* cLabel=(char **)calloc(numCent,sizeof(char *));*/
  bestCent=(int *)calloc(numRows,sizeof(int));
  for (j=0; j<numRows; j++) dist[j]=(float *)calloc(numCent,sizeof(float));
  for (j=0; j<numCent; j++)
    {
      cent[j]=(float *)calloc(numCols,sizeof(float));
      /* cLabel[j]=(char *)calloc(MAX_STR_LEN,sizeof(char));*/
    }
  i=numRows;

  /* read in centroid data points */
  for (j=0; j<numCent; j++)
    {
      int k;
      /* first read in label */
      /* fscanf(centFile,"%s ",cLabel[j]); */
      /* then read in data values */
      for (k=0; k<numCols; k++) 
	{
	  fscanf(centFile,"%f ",&(cent[j][k]));
	}
      fscanf(ipFile,"\n");
    }

  /* write centroids to file */
  fprintf(opFile,"original\n");
  for (j=0; j<numCent; j++)
    {
      int k;
      for (k=0; k<numCols; k++) fprintf(opFile,"%f ",x[j][k]);
      fprintf(opFile,"\n");
    }

  for (it=0; it<NUMIT; it++)
    {
      /* calculate distance matrix and minimum */
      float rMin;
      int count;

      distortion[it]=0;
      count=0;

      for (j=0; j<numRows; j++)
	{
	  rMin=BIGNUM;
	  for (k=0; k < numCent; k++)
	    {
	      int e;
	      dist[j][k]=0;
	      for (e=0; e<numCols; e++)
		{
		  dist[j][k]+=(x[j][e]-cent[k][e])*(x[j][e]-cent[k][e]);
		}
	      if (dist[j][k] < rMin)
		{
		  bestCent[j]=k;
		  rMin=dist[j][k];
		}
	    }
	  distortion[it]+=rMin;
	  count++;
	}

      /* distortion[it]=distortion[it]/count; */

      /* reestimate centroids */
      for (k=0; k<numCent; k++)
	{
	  float *cent_r;
	  int tot;
	  
	  cent_r=(float *)calloc(numCols,sizeof(float));
	  tot=0;
	  for (j=0; j<numRows; j++)
	    {
	      if (bestCent[j]==k)
		{
		  int e;
		  for (e=0; e<numCols; e++) cent_r[e]+=x[j][e];
		  tot++;
		}
	    }

	  if (tot > 0)
	    {
	      int e;
	      for (e=0; e<numCols; e++) cent[k][e]=cent_r[e]/tot;
	    }
	  else
	    {
	      int e;
	      for (e=0; e<numCols; e++) cent[k][e]=mean[e];
	    }
	}

      /* write centroids to file */
      fprintf(opFile,"\n\nit=%d, distortion=%f\n",it,distortion[it]);
      for (k=0; k<numCent; k++) 
	{
	  int e;
	  for (e=0; e<numCols; e++) fprintf(opFile,"%f ",cent[k][e]);
	  fprintf(opFile,"\n");
	}
      /*----------------------------------------------------------
      for (k=0; k<numCent; k++)
	{
	  fprintf(opFile,"Cluster %d\n",k);
	  for (j=0; j<numRows; j++)
	    {
	      if (bestCent[j]==k) fprintf(opFile,"%s\n",label[j]);
	    }
	}
      -----------------------------------------------------------*/
    }

  /* write clusters to screen */
  printf("\nResults\n=======\n");
  for (it=0; it<NUMIT; it++) printf("distortion[%d]=\t%f\n",it,distortion[it]);

  /*-------------------------------------------------
  for (k=0; k<numCent; k++)
    {
      printf("\nCluster %d\n=========\n",k);
      for (j=0; j<numRows; j++)
	{
	  if (bestCent[j]==k) printf("%s\n",label[j]);
	}
    }
  --------------------------------------------------*/
  printf("k-means complete\n");
  return(0);
}

