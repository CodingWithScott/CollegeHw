    int i, j;
    
    // Eliminating function calls does almost nothing to help
    
    /* Begin Avg */
		int ii, jj;
		pixel_sum sum;
		pixel current_pixel;

		// initialize_pixel_sum(&sum);
	        sum->red = sum->green = sum->blue = 0;
		    sum->num = 0;
	    // ^^ those two lines are contents of initialize_pixel_sum(&sum)
		for(ii = max(i-1, 0); ii <= min(i+1, dim-1); ii++) 
			for(jj = max(j-1, 0); jj <= min(j+1, dim-1); jj++) 
				accumulate_sum(&sum, src[RIDX(ii, jj, dim)]);

		assign_sum_to_pixel(&current_pixel, sum);
    /* End Avg  */
    
    /* Begin Initialize_pixel_sum */
        sum->red = sum->green = sum->blue = 0;
	    sum->num = 0;
    /* End Initialize_pixel_sum */
    
    /* Begin Accumulate_Sum */
		sum->red += (int) p.red;
		sum->green += (int) p.green;
		sum->blue += (int) p.blue;
		sum->num++;
    /* End Accumulate_Sum */
    

	/* Begin Original Smooth Function */
    for (i = 0; i < dim; i++)
		for (j = 0; j < dim; j++)
		    dst[RIDX(i, j, dim)] = avg(dim, i, j, src);
	/* End Original Smooth Function */
