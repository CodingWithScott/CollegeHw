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

public class LabelessTwoEggs {
	public static int count;
	public static int weakEgg;
	public static int mediumEgg;
	public static int strongEgg;

	public static void main(String args[]) {
		int bounds = 10000;
		int trials = 1000000;
		Random rand = new Random();

		/* Build ladder */
		ArrayList<Integer> ladder = new ArrayList<Integer>();

		for (int i = 0; i < bounds; i++) {
			ladder.add(i);
		}

		for (int i = 0; i < trials; i++) {
			/* Build Eggs */
			int rung = rand.nextInt(bounds);
			strongEgg = rand.nextInt(bounds - 2) + 2;

			mediumEgg = rand.nextInt(bounds - 1) + 1;
			while (mediumEgg >= strongEgg) {
				mediumEgg = rand.nextInt(bounds - 1) + 1;
			}

			weakEgg = rand.nextInt(bounds);
			while (weakEgg >= mediumEgg) {
				weakEgg = rand.nextInt(bounds);			
			}

			/* Pick an egg at random */
			int choice = rand.nextInt(3) + 1;
			int unknownEgg = randToEgg(choice);

			testEgg(ladder, unknownEgg, choice);
		}

		System.out.println("Average for (two unknownEgg) sets: " + count / trials);
	}

	public static void testEgg(ArrayList<Integer> ladder, int unknownEgg, int choice) {
		int eggBound = testEggOne(ladder, ladder.size(), 0, unknownEgg);
		int eggBound2 = 0;
		Random rand = new Random();	

		int secondChoice = rand.nextInt(3) + 1;
		while (secondChoice == choice) {
			secondChoice = rand.nextInt(3) + 1;
		}

		int thirdChoice = rand.nextInt(3) + 1;
		while (thirdChoice == choice || thirdChoice == secondChoice) {
			thirdChoice = rand.nextInt(3) + 1;
		}


		int secondUnknownEgg = randToEgg(secondChoice);
		int thirdUnknownEgg = randToEgg(thirdChoice);


		if (secondUnknownEgg < eggBound && thirdUnknownEgg < eggBound) {	
			eggBound2 = testEggTwo(ladder, eggBound, 0, secondUnknownEgg);

			if (thirdUnknownEgg < eggBound2) {
				testEggThree(ladder, eggBound2, 0, thirdUnknownEgg);				
			} else {
				testEggThree(ladder, eggBound, eggBound2, thirdUnknownEgg);
			}

		} else if (secondUnknownEgg > eggBound && thirdUnknownEgg < eggBound) {	
			eggBound2 = testEggTwo(ladder, ladder.size(), eggBound, secondUnknownEgg);
			testEggThree(ladder, eggBound, 0, thirdUnknownEgg);

		} else if (secondUnknownEgg < eggBound && thirdUnknownEgg > eggBound) {
			eggBound2 = testEggTwo(ladder, eggBound, 0, secondUnknownEgg);
			testEggThree(ladder, ladder.size(), eggBound, thirdUnknownEgg);

		} else if (secondUnknownEgg > eggBound && thirdUnknownEgg > eggBound) {
			eggBound2 = testEggTwo(ladder, ladder.size(), eggBound, secondUnknownEgg);

			if (thirdUnknownEgg > eggBound2) {
				testEggThree(ladder, ladder.size(), eggBound2, thirdUnknownEgg);				
			} else {
				testEggThree(ladder, eggBound2, eggBound, thirdUnknownEgg);
			}
		}
	}

	public static int randToEgg(int choice) {
		if (choice == 1) {
			return weakEgg;
		} else if (choice == 2) {
			return mediumEgg;
		} else if (choice == 3) {
			return strongEgg;
		} else {
			System.out.println("Error");
		}
		return -1;
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