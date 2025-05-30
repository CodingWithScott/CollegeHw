/* CS 305 -- Deep Learning
 *
 *	 Geoffrey Murray, Scotty Felch
 *   Bridget Tueffers, Ellyn Ayton
 *   Feb 25 2015
 * 	 CS 305
 *   Simulation class
 */

import java.lang.*;
import java.util.*; 
import java.io.*;

public class Simulation {
	public static int counter;

	public static void main(String args[]) {
		int bounds = 10000;
		int trials = 10000;  //Need to use Big Int for anything higher than 10000000.
		Random rand = new Random();

		/* Build ladder */
		ArrayList<Integer> ladder = new ArrayList<Integer>();

		for (int i = 0; i < bounds; i++) {
			ladder.add(i);
		}

		int testCounter1 = 0;
		int testCounter2 = 0;
		int testCounter3 = 0;
		int testCounter4 = 0;
		int testCounter5 = 0;
		int testCounter6 = 0;

		for (int i = 0; i < trials; i++) {
			/* Build Eggs */
			int rung = rand.nextInt(bounds);
			int strongEgg = rand.nextInt(bounds - 2) + 2;

			int mediumEgg = rand.nextInt(bounds - 1) + 1;
			while (mediumEgg >= strongEgg) {
				mediumEgg = rand.nextInt(bounds - 1) + 1;
			}

			int weakEgg = rand.nextInt(bounds);
			while (weakEgg >= mediumEgg) {
				weakEgg = rand.nextInt(bounds);			
			}

			counter = 0;
			testOne(ladder, strongEgg, mediumEgg, weakEgg);
			testCounter1 += counter;

			counter = 0;
			testTwo(ladder, strongEgg, mediumEgg, weakEgg);
			testCounter2 += counter;

			counter = 0;
			testThree(ladder, strongEgg, mediumEgg, weakEgg);
			testCounter3 += counter;

			counter = 0;
			testFour(ladder, strongEgg, mediumEgg, weakEgg);
			testCounter4 += counter;

			counter = 0;
			testFive(ladder, strongEgg, mediumEgg, weakEgg);
			testCounter5 += counter;

			counter = 0;
			testSix(ladder, strongEgg, mediumEgg, weakEgg);
			testCounter6 += counter;
		}

		System.out.println("Average for Permutation H M F:" + testCounter1 / trials);
		System.out.println("Average for Permutation H F M: " + testCounter2 / trials);
		System.out.println("Average for Permutation M H F: " + testCounter3 / trials);
		System.out.println("Average for Permutation M F H: " + testCounter4 / trials);
		System.out.println("Average for Permutation F H M: " + testCounter5 / trials);
		System.out.println("Average for Permutation F M H: " + testCounter6 / trials);
	}

	public static void testOne(ArrayList<Integer> ladder, int strongEgg, int mediumEgg, int weakEgg) {
		/* Binary Search (Strong Egg) */
		int eggbounds = binarySearch(ladder, ladder.size(), 0, strongEgg);

		/* Binary Search (Medium Egg) */
		eggbounds = binarySearch(ladder, eggbounds, 0, mediumEgg);

		/* Binary Search (Weak Egg) */
		binarySearch(ladder, eggbounds, 0, weakEgg);
	}



	public static void testTwo(ArrayList<Integer> ladder, int strongEgg, int mediumEgg, int weakEgg) {
		/* Binary Search (Strong Egg) */
		int eggbounds = binarySearch(ladder, ladder.size(), 0, strongEgg);

		/* Binary Search (Weak Egg) */
		int eggbounds2 = binarySearch(ladder, eggbounds, 0, weakEgg);
	
		/* Binary Search (Medium Egg) */
		binarySearch(ladder, eggbounds, eggbounds2, mediumEgg);
	}



	public static void testThree(ArrayList<Integer> ladder, int strongEgg, int mediumEgg, int weakEgg) {
		/* Binary Search (Medium Egg) */
		int eggbounds = binarySearch(ladder, ladder.size(), 0, mediumEgg);

		/* Binary Search (Strong Egg) */
		int eggbounds2 = binarySearch(ladder, ladder.size(), eggbounds, strongEgg);

		/* Binary Search (Weak Egg) */
		binarySearch(ladder, eggbounds, 0, weakEgg);
	}



	public static void testFour(ArrayList<Integer> ladder, int strongEgg, int mediumEgg, int weakEgg) {
		/* Binary Search (Medium Egg) */
		int eggbounds = binarySearch(ladder, ladder.size(), 0, mediumEgg);

		/* Binary Search (Weak Egg) */
		int eggbounds2 = binarySearch(ladder, eggbounds, 0, weakEgg);

		/* Binary Search (Strong Egg) */
		binarySearch(ladder, ladder.size(), eggbounds, strongEgg);
	}



	public static void testFive(ArrayList<Integer> ladder, int strongEgg, int mediumEgg, int weakEgg) {
		/* Binary Search (Weak Egg) */
		int eggbounds = binarySearch(ladder, ladder.size(), 0, weakEgg);

		/* Binary Search (Strong Egg) */
		int eggbounds2 = binarySearch(ladder, ladder.size(), eggbounds, strongEgg);

		/* Binary Search (Medium Egg) */
		binarySearch(ladder, eggbounds2, eggbounds, mediumEgg);
	}



	public static void testSix(ArrayList<Integer> ladder, int strongEgg, int mediumEgg, int weakEgg) {
		/* Binary Search (Weak Egg) */
		int eggbounds = binarySearch(ladder, ladder.size(), 0, weakEgg);

		/* Binary Search (Medium Egg) */
		int eggbounds2 = binarySearch(ladder, ladder.size(), eggbounds, mediumEgg);

		/* Binary Search (Strong Egg) */
		binarySearch(ladder, ladder.size(), eggbounds2, strongEgg);
	}



	public static int binarySearch(ArrayList<Integer> ladder, int upperBound, int lowerBound, int target) {
		int min = lowerBound;
		int max = upperBound;
		int binCounter = 0;
		while (min <= max) {
			int mid = min + ((max - min) / 2);

			if (ladder.get(mid) == target) {
				binCounter++;
				counter += binCounter;
				return mid;

			} else if (ladder.get(mid) < target) {
				min = mid + 1;
			} else {
				max = mid - 1;
			}
			binCounter++;
		}
		System.out.println("Error");
		return -1;
	}
}