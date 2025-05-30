/********************************************************
 * Kernels to be optimized for the CS:APP Performance Lab
 ********************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "defs.h"

/* 
 * Please fill in the following team struct 
 */
team_t team = {
    "Team Felch Price Rising",  /* Team name */

    "Scott Felch",     			/* First member full name */
    "felchs@students.wwu.edu",  /* First member email address */

    "Milo Price",               /* Second member full name (leave blank if none) */
    "pricem9@students.wwu.edu", /* Second member email addr (leave blank if	none) */
    
    "Eli Rising",               /* Third full name (leave blank if none) */
    "risinge@students.wwu.edu"  /* Third member email addr (leave blank if	none) */
};

/***************
 * ROTATE KERNEL
 ***************/

/******************************************************
 * Your different versions of the rotate kernel go here
 ******************************************************/

/* 
 * naive_rotate - The naive baseline version of rotate 
 */
char naive_rotate_descr[] = "naive_rotate: Naive baseline implementation";
void naive_rotate(int dim, pixel *src, pixel *dst) 
{
    int i, j;

    for (i = 0; i < dim; i++)
		for (j = 0; j < dim; j++)
		  	dst[RIDX(dim-1-j, i, dim)] = src[RIDX(i, j, dim)];
		  	
//		  	dst[(dim-1-j)*(dim)+(i)] = src[(i)*(dim)+(j)];
}

/* 
 * rotate - Your current working version of rotate
 * IMPORTANT: This is the version you will be graded on
 */
 
 

char rotate_descr[] = "rotate: Current working version";
void rotate(int dim, pixel *src, pixel *dst) 
{
	/* Vector containing 4 integers to be used for a single instruction. 
	Vector_size = 16 because it contains four 4-byte ints	*/
	typedef int v4si __attribute__ ((vector_size (16)));

	v4si vec = {0,1,2,3};

	int i, j;
	/* Process one row at a time, grab 32 columns in that row. */
	for (i = 0; i < dim; i+=32)
		for (j = 0; j < dim; j++)
		{
			/* Short for Dimension Macro, just a short hand to save typing 
			and extra computations. It would have been Dim_Mac, but Dim Mak
			is the name of a record label I like so I wanted to call it 
			that. */
			int dim_mak = (dim-1-j)*(dim)+(i);

			dst[dim_mak+vec]    = src[(i+ 0 + vec)*(dim)+(j)];
/*			dst[dim_mak+1]  = src[(i+ 1)*(dim)+(j)];
			dst[dim_mak+2]  = src[(i+ 2)*(dim)+(j)];
			dst[dim_mak+3]  = src[(i+ 3)*(dim)+(j)];*/
			dst[dim_mak+4+vec]  = src[(i+ 4 + vec)*(dim)+(j)];
/*			dst[dim_mak+5]  = src[(i+ 5)*(dim)+(j)];
			dst[dim_mak+6]  = src[(i+ 6)*(dim)+(j)];
			dst[dim_mak+7]  = src[(i+ 7)*(dim)+(j)];*/
			dst[dim_mak+8+vec]  = src[(i+ 8 + vec)*(dim)+(j)];
/*			dst[dim_mak+9]  = src[(i+ 9)*(dim)+(j)];
			dst[dim_mak+10] = src[(i+10)*(dim)+(j)];
			dst[dim_mak+11] = src[(i+11)*(dim)+(j)];*/
			dst[dim_mak+12+vec] = src[(i+12+vec)*(dim)+(j)];
/*			dst[dim_mak+13] = src[(i+13)*(dim)+(j)];
			dst[dim_mak+14] = src[(i+14)*(dim)+(j)];
			dst[dim_mak+15] = src[(i+15)*(dim)+(j)];*/
			dst[dim_mak+16+vec] = src[(i+16+vec)*(dim)+(j)];
/*			dst[dim_mak+17] = src[(i+17)*(dim)+(j)];
			dst[dim_mak+18] = src[(i+18)*(dim)+(j)];
			dst[dim_mak+19] = src[(i+19)*(dim)+(j)];*/
			dst[dim_mak+20+vec] = src[(i+20+vec)*(dim)+(j)];
/*			dst[dim_mak+21] = src[(i+21)*(dim)+(j)];
			dst[dim_mak+22] = src[(i+22)*(dim)+(j)];
			dst[dim_mak+23] = src[(i+23)*(dim)+(j)];*/
			dst[dim_mak+24+vec] = src[(i+24+vec)*(dim)+(j)];
/*			dst[dim_mak+25] = src[(i+25)*(dim)+(j)];
			dst[dim_mak+26] = src[(i+26)*(dim)+(j)];
			dst[dim_mak+27] = src[(i+27)*(dim)+(j)];*/
			dst[dim_mak+28+vec] = src[(i+28+vec)*(dim)+(j)];
/*			dst[dim_mak+29] = src[(i+29)*(dim)+(j)];
			dst[dim_mak+30] = src[(i+30)*(dim)+(j)];
			dst[dim_mak+31] = src[(i+31)*(dim)+(j)];*/
		  } 
}

/*********************************************************************
 * register_rotate_functions - Register all of your different versions
 *     of the rotate kernel with the driver by calling the
 *     add_rotate_function() for each test function. When you run the
 *     driver program, it will test and report the performance of each
 *     registered test function.  
 *********************************************************************/

void register_rotate_functions() 
{
    add_rotate_function(&naive_rotate, naive_rotate_descr);   
    add_rotate_function(&rotate, rotate_descr);   
    /* ... Register additional test functions here */
}


/***************
 * SMOOTH KERNEL
 **************/

/***************************************************************
 * Various typedefs and helper functions for the smooth function
 * You may modify these any way you like.
 **************************************************************/

/* A struct used to compute averaged pixel value */
typedef struct {
    int red;
    int green;
    int blue;
    int num;
} pixel_sum;

/* Compute min and max of two integers, respectively */
static int min(int a, int b) { return (a < b ? a : b); }
static int max(int a, int b) { return (a > b ? a : b); }

/* 
 * initialize_pixel_sum - Initializes all fields of sum to 0 
 */
static void initialize_pixel_sum(pixel_sum *sum) 
{
    sum->red = sum->green = sum->blue = 0;
    sum->num = 0;
    return;
}

/* 
 * accumulate_sum - Accumulates field values of p in corresponding 
 * fields of sum 
 */
static void accumulate_sum(pixel_sum *sum, pixel p) 
{
    sum->red += (int) p.red;
    sum->green += (int) p.green;
    sum->blue += (int) p.blue;
    sum->num++;
    return;
}

/* 
 * assign_sum_to_pixel - Computes averaged pixel value in current_pixel 
 */
static void assign_sum_to_pixel(pixel *current_pixel, pixel_sum sum) 
{
    current_pixel->red = (unsigned short) (sum.red/sum.num);
    current_pixel->green = (unsigned short) (sum.green/sum.num);
    current_pixel->blue = (unsigned short) (sum.blue/sum.num);
    return;
}

/* 
 * avg - Returns averaged pixel value at (i,j) 
 */
static pixel avg(int dim, int i, int j, pixel *src) 
{
    int ii, jj;
    pixel_sum sum;
    pixel current_pixel;

    initialize_pixel_sum(&sum);
    for(ii = max(i-1, 0); ii <= min(i+1, dim-1); ii++) 
	for(jj = max(j-1, 0); jj <= min(j+1, dim-1); jj++) 
	    accumulate_sum(&sum, src[RIDX(ii, jj, dim)]);

    assign_sum_to_pixel(&current_pixel, sum);
    return current_pixel;
}

/******************************************************
 * Your different versions of the smooth kernel go here
 ******************************************************/

/*
 * naive_smooth - The naive baseline version of smooth 
 */
char naive_smooth_descr[] = "naive_smooth: Naive baseline implementation";
void naive_smooth(int dim, pixel *src, pixel *dst) 
{
    int i, j;

    for (i = 0; i < dim; i++)
		for (j = 0; j < dim; j++)
		    dst[RIDX(i, j, dim)] = avg(dim, i, j, src);
}

/*
 * smooth - Your current working version of smooth. 
 * IMPORTANT: This is the version you will be graded on
 */
char smooth_descr[] = "smooth: Current working version";
void smooth(int dim, pixel *src, pixel *dst) 
{
	int i;	// Counter for row
	int j;	// Counter for columns

	// Top Left Corner. Dest is [0][0], Source is [0][0], [0][1], [1][0], [1][1]
	dst[RIDX(0, 0, dim)].red = (src[RIDX(0, 0, dim)].red + src[RIDX(0, 1, dim)].red + src[RIDX(1, 0, dim)].red + src[RIDX(1, 1, dim)].red) / 4;
	dst[RIDX(0, 0, dim)].green = (src[RIDX(0, 0, dim)].green + src[RIDX(0, 1, dim)].green + src[RIDX(1, 0, dim)].green + 
		src[RIDX(1, 1, dim)].green) / 4;
	dst[RIDX(0, 0, dim)].blue = (src[RIDX(0, 0, dim)].blue + src[RIDX(0, 1, dim)].blue + src[RIDX(1, 0, dim)].blue + 
		src[RIDX(1, 1, dim)].blue) / 4;
	// Top Right Corner. Dest is [0][Dim-1], Source is [0][Dim-2], [0][Dim-1], [1][Dim-2], [1][Dim-1]
	dst[RIDX(0, dim-1, dim)].red = (src[RIDX(0, dim-2, dim)].red + src[RIDX(0, dim-1, dim)].red + src[RIDX(1, dim-2, dim)].red + 
		src[RIDX(1, dim-1, dim)].red) / 4;
	dst[RIDX(0, dim-1, dim)].green = (src[RIDX(0, dim-2, dim)].green + src[RIDX(0, dim-1, dim)].green + src[RIDX(1, dim-2, dim)].green + 
		src[RIDX(1, dim-1, dim)].green) / 4;
	dst[RIDX(0, dim-1, dim)].blue = (src[RIDX(0, dim-2, dim)].blue + src[RIDX(0, dim-1, dim)].blue + src[RIDX(1, dim-2, dim)].blue + 
		src[RIDX(1, dim-1, dim)].blue) / 4;
	// Bottom Left Corner. Dest is [Dim-1][0], Source is [Dim-2][0], [Dim-2][1], [Dim-1][0], [Dim-1][1]
	dst[RIDX(dim-1, 0, dim)].red = (src[RIDX(dim-1, 0, dim)].red + src[RIDX(dim-1, 1, dim)].red + src[RIDX(dim-2, 0, dim)].red +
		 src[RIDX(dim-2, 1, dim)].red) / 4;
	dst[RIDX(dim-1, 0, dim)].green = (src[RIDX(dim-1, 0, dim)].green + src[RIDX(dim-1, 1, dim)].green + src[RIDX(dim-2, 0, dim)].green +
		 src[RIDX(dim-2, 1, dim)].green) / 4;
	dst[RIDX(dim-1, 0, dim)].blue = (src[RIDX(dim-1, 0, dim)].blue + src[RIDX(dim-1, 1, dim)].blue + src[RIDX(dim-2, 0, dim)].blue +
		 src[RIDX(dim-2, 1, dim)].blue) / 4;
	// Bottom Right Corner. Dest is [Dim-1][Dim-1], Source is [Dim-2][Dim-2], [Dim-2][Dim-1], [Dim-1][Dim-2], [Dim-1][Dim-1]
	dst[RIDX(dim-1, dim-1, dim)].red = (src[RIDX(dim-2, dim-2, dim)].red + src[RIDX(dim-2, dim-1, dim)].red + src[RIDX(dim-1, dim-2, dim)].red + 
		src[RIDX(dim-1, dim-1, dim)].red) / 4;
	dst[RIDX(dim-1, dim-1, dim)].green = (src[RIDX(dim-2, dim-2, dim)].green + src[RIDX(dim-2, dim-1, dim)].green + 
		src[RIDX(dim-1, dim-2, dim)].green + src[RIDX(dim-1, dim-1, dim)].green) / 4;
	dst[RIDX(dim-1, dim-1, dim)].blue = (src[RIDX(dim-2, dim-2, dim)].blue + src[RIDX(dim-2, dim-1, dim)].blue + 
		src[RIDX(dim-1, dim-2, dim)].blue + src[RIDX(dim-1, dim-1, dim)].blue) / 4;
	
	/* Left Strip, minus the Top Left and Bottom Left corners. Dest Row I varies 1 to Dim-2, Column J is fixed at 0 
	 Source is going to be [I-1][0], [I][0], [I+1][0] and [I-1][1], [I][1], [I+1][1] */
	for (i = 1; i < dim-1; i++) {
		dst[RIDX(i, 0, dim)].red = (src[RIDX(i-1, 0, dim)].red + src[RIDX(i, 0, dim)].red + src[RIDX(i+1, 0, dim)].red + 
			src[RIDX(i-1, 1, dim)].red + src[RIDX(i, 1, dim)].red + src[RIDX(i+1, 1, dim)].red) / 6;
		dst[RIDX(i, 0, dim)].green = (src[RIDX(i-1, 0, dim)].green + src[RIDX(i, 0, dim)].green + src[RIDX(i+1, 0, dim)].green + 
			src[RIDX(i-1, 1, dim)].green + src[RIDX(i, 1, dim)].green + src[RIDX(i+1, 1, dim)].green) / 6;
		dst[RIDX(i, 0, dim)].blue = (src[RIDX(i-1, 0, dim)].blue + src[RIDX(i, 0, dim)].blue + src[RIDX(i+1, 0, dim)].blue + 
			src[RIDX(i-1, 1, dim)].blue + src[RIDX(i, 1, dim)].blue + src[RIDX(i+1, 1, dim)].blue) / 6;
	}
	
	/* Right Strip, minus the Top Right and Bottom Right corners. Dest Row I varies 1 to Dim-2, Column J is fixed at Dim-1 
	 Source is going to be [I-1][Dim-1], [I][Dim-1], [I+1][Dim-1] and [I-1][Dim-2], [I][Dim-2], [I+1][Dim-2] */
	for (i = 1; i < dim-1; i++) {
		dst[RIDX(i, dim-1, dim)].red = (src[RIDX(i-1, dim-1, dim)].red + src[RIDX(i, dim-1, dim)].red + src[RIDX(i+1, dim-1, dim)].red + 
			src[RIDX(i-1, dim-2, dim)].red + src[RIDX(i, dim-2, dim)].red + src[RIDX(i+1, dim-2, dim)].red) / 6;
		dst[RIDX(i, dim-1, dim)].green = (src[RIDX(i-1, dim-1, dim)].green + src[RIDX(i, dim-1, dim)].green + src[RIDX(i+1, dim-1, dim)].green + 
			src[RIDX(i-1, dim-2, dim)].green + src[RIDX(i, dim-2, dim)].green + src[RIDX(i+1, dim-2, dim)].green) / 6;
		dst[RIDX(i, dim-1, dim)].blue = (src[RIDX(i-1, dim-1, dim)].blue + src[RIDX(i, dim-1, dim)].blue + src[RIDX(i+1, dim-1, dim)].blue + 
			src[RIDX(i-1, dim-2, dim)].blue + src[RIDX(i, dim-2, dim)].blue + src[RIDX(i+1, dim-2, dim)].blue) / 6;
	}
	
	/* Top Strip, minus the Top Left and Top Right corners. Dest Row I is fixed at 0, Column J varies 1 to Dim-2 
	 Source is going to be [0][J-1], [0][J], [0][J+1] and [1][J-1], [1][J], [1][J+1] */
	for (j = 1; j < dim-1; j++) {
		dst[RIDX(0, j, dim)].red = (src[RIDX(0, j-1, dim)].red + src[RIDX(0, j, dim)].red + src[RIDX(0, j+1, dim)].red + 
			src[RIDX(1, j-1, dim)].red + src[RIDX(1, j, dim)].red + src[RIDX(1, j+1, dim)].red) / 6;
		dst[RIDX(0, j, dim)].green = (src[RIDX(0, j-1, dim)].green + src[RIDX(0, j, dim)].green + src[RIDX(0, j+1, dim)].green + 
			src[RIDX(1, j-1, dim)].green + src[RIDX(1, j, dim)].green + src[RIDX(1, j+1, dim)].green) / 6;
		dst[RIDX(0, j, dim)].blue = (src[RIDX(0, j-1, dim)].blue + src[RIDX(0, j, dim)].blue + src[RIDX(0, j+1, dim)].blue + 
			src[RIDX(1, j-1, dim)].blue + src[RIDX(1, j, dim)].blue + src[RIDX(1, j+1, dim)].blue) / 6;
	}
	
	/* Bottom Strip, minus the Bottom Left and Bottom Right corners. Dest Row I is fixed at Dim-1, Column J varies 1 to Dim-2 
	 Source is going to be [Dim-2][J-1], [Dim-2][J], [Dim-2][J+1] and [Dim-1][J-1], [Dim-1][J], [Dim-1][J+1] */
	for (j = 1; j < dim-1; j++) {
		dst[RIDX(dim-1, j, dim)].red = (src[RIDX(dim-2, j-1, dim)].red + src[RIDX(dim-2, j, dim)].red + src[RIDX(dim-2, j+1, dim)].red + 
			src[RIDX(dim-1, j-1, dim)].red + src[RIDX(dim-1, j, dim)].red + src[RIDX(dim-1, j+1, dim)].red) / 6;
		dst[RIDX(dim-1, j, dim)].green = (src[RIDX(dim-2, j-1, dim)].green + src[RIDX(dim-2, j, dim)].green + src[RIDX(dim-2, j+1, dim)].green + 
			src[RIDX(dim-1, j-1, dim)].green + src[RIDX(dim-1, j, dim)].green + src[RIDX(dim-1, j+1, dim)].green) / 6;
		dst[RIDX(dim-1, j, dim)].blue = (src[RIDX(dim-2, j-1, dim)].blue + src[RIDX(dim-2, j, dim)].blue + src[RIDX(dim-2, j+1, dim)].blue + 
			src[RIDX(dim-1, j-1, dim)].blue + src[RIDX(dim-1, j, dim)].blue + src[RIDX(dim-1, j+1, dim)].blue) / 6;
	}
	
	/* So 2 columns and rows have been taken care of, need to deal with next 30, and then however many remaining multiples of 32 are left.
	Need to do 1 iteration with just 31 columns.  Then N number of iterations 32 wide. Will worry about how to do this later. For now
	just going to do a 1-at-a-time loop. */
	 
	 
	/* This section will tell how many times I can iterate through with full 32 column chunks after my initial 1 column, 30 column,
	and before my final 1 column. 
	int times_to_iterate = -1;
	int dim_copy = dim;
	while (dim_copy > 0) {
		times_to_iterate += 1;
		dim_copy -= 32;
	}
	
	*/
	
	/* Read through the middle section one pixel at a time. Dest Row and Column will vary from 1 to Dim-2. 
	  Source Row and Column will be [i-1][j-1], [i-1][j], [i-1][j+1], and [i][j-1], [i][j], [i][j+1], 
	  and [i+1][[j-1], [i+1][j], [i+1][j+1]. 
	*/
	for (i = 1; i < dim-1; i++) {
		for (j = 1; j < dim-1; j++) {
			dst[RIDX(i, j, dim)].red = (src[RIDX(i-1, j-1, dim)].red + src[RIDX(i-1, j, dim)].red + src[RIDX(i-1, j+1, dim)].red +
				src[RIDX(i, j-1, dim)].red + src[RIDX(i, j, dim)].red + src[RIDX(i, j+1, dim)].red + src[RIDX(i+1, j-1, dim)].red +
				src[RIDX(i+1, j, dim)].red + src[RIDX(i+1, j+1, dim)].red) / 9;
			dst[RIDX(i, j, dim)].green = (src[RIDX(i-1, j-1, dim)].green + src[RIDX(i-1, j, dim)].green + src[RIDX(i-1, j+1, dim)].green +
				src[RIDX(i, j-1, dim)].green + src[RIDX(i, j, dim)].green + src[RIDX(i, j+1, dim)].green + src[RIDX(i+1, j-1, dim)].green +
				src[RIDX(i+1, j, dim)].green + src[RIDX(i+1, j+1, dim)].green) / 9;
			dst[RIDX(i, j, dim)].blue = (src[RIDX(i-1, j-1, dim)].blue + src[RIDX(i-1, j, dim)].blue + src[RIDX(i-1, j+1, dim)].blue +
				src[RIDX(i, j-1, dim)].blue + src[RIDX(i, j, dim)].blue + src[RIDX(i, j+1, dim)].blue + src[RIDX(i+1, j-1, dim)].blue +
				src[RIDX(i+1, j, dim)].blue + src[RIDX(i+1, j+1, dim)].blue) / 9;
		}
	}
		
}


/********************************************************************* 
 * register_smooth_functions - Register all of your different versions
 *     of the smooth kernel with the driver by calling the
 *     add_smooth_function() for each test function.  When you run the
 *     driver program, it will test and report the performance of each
 *     registered test function.  
 *********************************************************************/

void register_smooth_functions() {
    add_smooth_function(&smooth, smooth_descr);
    add_smooth_function(&naive_smooth, naive_smooth_descr);
    /* ... Register additional test functions here */
}













































































