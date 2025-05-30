/* CS 305 -- Deep Learning
 *
 *	 Geoffrey Murray, Scotty Felch
 *   Bridget Tueffers, Ellyn Ayton
 *   March 1 2015
 * 	 CS 305
 *   Simulation class
 */

import java.lang.*;
import java.util.*; 
import java.io.*;
import java.lang.Math;

public class TwoEggs {
	static int strongEgg;
	static int mediumEgg;
	static int weakEgg;
	static int count;

	public static void main(String args[]) {
		int bounds = 10000;
		int trials = 1000000;
		Random rand = new Random();

		/* Build ladder */
		ArrayList<Integer> ladder = new ArrayList<Integer>();
		for (int i = 0; i < bounds; i++) {
			ladder.add(i);
		}

		int countOne = 0;
		int countTwo = 0;
		int countThree = 0;
		int countFour = 0;
		int countFive = 0;
		int countSix = 0;		

		for (int i = 0; i < trials; i++) {
			/* Build Eggs */
			strongEgg = rand.nextInt(bounds - 2) + 2;

			mediumEgg = rand.nextInt(bounds - 1) + 1;
			while (mediumEgg >= strongEgg) {
				mediumEgg = rand.nextInt(bounds - 1) + 1;
			}

			weakEgg = rand.nextInt(bounds);
			while (weakEgg >= mediumEgg) {
				weakEgg = rand.nextInt(bounds);	
			}

			count = 0;
			testHMF(ladder, strongEgg, mediumEgg, weakEgg);
			countOne += count;

			count = 0;
			testHFM(ladder, strongEgg, weakEgg, mediumEgg);
			countTwo += count;

			count = 0;
			testMHF(ladder, mediumEgg, strongEgg, weakEgg);
			countThree += count;

			count = 0;
			testMFH(ladder, mediumEgg, weakEgg, strongEgg);
			countFour += count;

			count = 0;
			testFHM(ladder, weakEgg, strongEgg, mediumEgg);
			countFive += count;

			count = 0;
			testFMH(ladder, weakEgg, mediumEgg, strongEgg);
			countSix += count;
		}

		System.out.println("Average for Permutation H M F:" + countOne / trials);
		System.out.println("Average for Permutation H F M: " + countTwo / trials);
		System.out.println("Average for Permutation M H F: " + countThree / trials);
		System.out.println("Average for Permutation M F H: " + countFour / trials);
		System.out.println("Average for Permutation F H M: " + countFive / trials);
		System.out.println("Average for Permutation F M H: " + countSix / trials);
	}


	public static void testHMF(ArrayList<Integer> ladder, int eggOne, int eggTwo, int eggThree) {
		int eggBound = testEggOne(ladder, ladder.size(), 0, eggOne);
		eggBound = testEggTwo(ladder, eggBound, 0, eggTwo);
		testEggThree(ladder, eggBound, 0, eggThree);
	}

	public static void testHFM(ArrayList<Integer> ladder, int eggOne, int eggTwo, int eggThree) {
		int eggBound = testEggOne(ladder, ladder.size(), 0, eggOne);
		int eggBound2 = testEggTwo(ladder, eggBound, 0, eggTwo);
		testEggThree(ladder, eggBound, eggBound2, eggThree);
	}

	public static void testMHF(ArrayList<Integer> ladder, int eggOne, int eggTwo, int eggThree) {
		int eggBound = testEggOne(ladder, ladder.size(), 0, eggOne);
		int eggBound2 = testEggTwo(ladder, ladder.size(), eggBound, eggTwo);
		testEggThree(ladder, eggBound, 0, eggThree);
	}

	public static void testMFH(ArrayList<Integer> ladder, int eggOne, int eggTwo, int eggThree) {
		int eggBound = testEggOne(ladder, ladder.size(), 0, eggOne);
		int eggBound2 = testEggTwo(ladder, eggBound, 0, eggTwo);
		testEggThree(ladder, ladder.size(), eggBound, eggThree);
	}

	public static void testFHM(ArrayList<Integer> ladder, int eggOne, int eggTwo, int eggThree) {
		int eggBound = testEggOne(ladder, ladder.size(), 0, eggOne);
		int eggBound2 = testEggTwo(ladder, ladder.size(), eggBound, eggTwo);
		testEggThree(ladder, eggBound2, eggBound, eggThree);
	}

	public static void testFMH(ArrayList<Integer> ladder, int eggOne, int eggTwo, int eggThree) {
		int eggBound = testEggOne(ladder, ladder.size(), 0, eggOne);
		int eggBound2 = testEggTwo(ladder, ladder.size(), eggBound, eggTwo);
		testEggThree(ladder, ladder.size(), eggBound2, eggThree);
	}



	public static int testEggOne(ArrayList<Integer> ladder, int upperBound, int lowerBound, int eggOne) {
		int eggOneSquare = (int) Math.floor(Math.sqrt((double) eggOne));
		int eggBreak = 0;

		int i = lowerBound;
		while (true) {
			if (i >= eggOne) {
				eggBreak = i - eggOneSquare;
				break;
			}
			count++;
			i += eggOneSquare;
		}

		i = eggBreak;
		while (true) {
			if (i == eggOne) {
				break;
			}
			count++;
			i++;
		}

		return eggOne;
	}

	public static int testEggTwo(ArrayList<Integer> ladder, int upperBound, int lowerBound, int eggTwo) {
		int eggTwoSquare = (int) Math.floor(Math.sqrt((double) eggTwo));
		int eggBreak = 0;

		int i = lowerBound;
		while (true) {
			if (i >= eggTwo) {
				eggBreak = i - eggTwoSquare;
				break;
			}
			count++;
			i += eggTwoSquare;
		}

		i = eggBreak; 
		while (true) {
			if (i == eggTwo) {
				break;
			}
			count++;
			i++;
		}

		return eggTwo;
	}

	public static int testEggThree(ArrayList<Integer> ladder, int upperBound, int lowerBound, int eggThree) {
		int count = 0;
		int eggThreeSquare = (int) Math.floor(Math.sqrt((double) eggThree));
		int eggBreak = 0;

		int i = lowerBound;
		while (true) {
			if (i >= eggThree) {
				eggBreak = i - eggThreeSquare;
				break;
			}
			count++;
			i += eggThreeSquare;
		}	

		i = eggBreak;
		while (true) {
			if (i == eggThree) {
				break;
			}
			count++;
			i++;
		}

		return eggThree;
	}
}