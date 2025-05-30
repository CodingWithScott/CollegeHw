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

public class LabelessEggs {
	public static int counter;
	public static int weakEgg;
	public static int mediumEgg;
	public static int strongEgg;

	public static void main(String args[]) {
		int bounds = 10000;
		long trials = 2^63;
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

		System.out.println("Average for (unlimited unknownEgg) sets: " + counter / trials);
	}

	public static void testEgg(ArrayList<Integer> ladder, int unknownEgg, int choice) {
		int eggBound2 = 0;
		int eggBound = binarySearch(ladder, ladder.size(), 0, unknownEgg);
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
			eggBound2 = binarySearch(ladder, eggBound, 0, secondUnknownEgg);

			if (thirdUnknownEgg < eggBound2) {
				binarySearch(ladder, eggBound2, 0, thirdUnknownEgg);				
			} else {
				binarySearch(ladder, eggBound, eggBound2, thirdUnknownEgg);
			}

		} else if (secondUnknownEgg > eggBound && thirdUnknownEgg < eggBound) {	
			eggBound2 = binarySearch(ladder, ladder.size(), eggBound, secondUnknownEgg);
			binarySearch(ladder, eggBound, 0, thirdUnknownEgg);

		} else if (secondUnknownEgg < eggBound && thirdUnknownEgg > eggBound) {
			eggBound2 = binarySearch(ladder, eggBound, 0, secondUnknownEgg);
			binarySearch(ladder, ladder.size(), eggBound, thirdUnknownEgg);

		} else if (secondUnknownEgg > eggBound && thirdUnknownEgg > eggBound) {
			eggBound2 = binarySearch(ladder, ladder.size(), eggBound, secondUnknownEgg);

			if (thirdUnknownEgg > eggBound2) {
				binarySearch(ladder, ladder.size(), eggBound2, thirdUnknownEgg);				
			} else {
				binarySearch(ladder, eggBound2, eggBound, thirdUnknownEgg);
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

	public static int binarySearch(ArrayList<Integer> ladder, int upperBound, int lowerBound, int target) {
		int min = lowerBound;
		int max = upperBound - 1;
		while (min <= max) {
			int mid = min + ((max - min) / 2);

			if (ladder.get(mid) == target) {
				//System.out.println("(return: " + mid + ")");
				counter++;
				return mid;
			} else if (ladder.get(mid) < target) {
				min = mid + 1;
			} else {
				max = mid - 1;
			}
			counter++;
			//System.out.print(mid + ", ");
		}
		return -1;
	}
}