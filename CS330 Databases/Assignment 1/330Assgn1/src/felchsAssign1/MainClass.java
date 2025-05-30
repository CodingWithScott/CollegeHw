package felchsAssign1;
/* Scotty Felch
 * 31 January 2014
 * CSCI 330, Johnson
 * Assignment 1
 * 
 * This program sort of pretends it's using a database. It's going to read in data from
 * a text file with stock market ticker information for several companies. Each line
 * has the data: company, date, opening price, high price, low price, closing price,
 * volume, and adjusted closing.
 * 
 * High, low, volume, and adjusted closing are superfluous as far as this assignment
 * is concerned, I'm assuming they'll come into play later. */

/**
 * @author felchs
 *
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class MainClass {
	static ArrayList<TradeDay> theTrades = new ArrayList<TradeDay>();
	
	public static void populateArray() {
		
		@SuppressWarnings("resource")
		Scanner sc = new Scanner(System.in);
		String fileName = "stockData.txt";
		
		try {
			// Read a single line of the text file, split it up 
			sc = new Scanner(new File(fileName)).useDelimiter(";");
			System.out.print("Reading data from " + fileName + "... "); // Display the string.

			// While there is another line in the file, read in the currLine and split it along semicolons.
			while (sc.hasNext()) {
				String[] str = sc.nextLine().split(";");
				
				String currTicker = str[0].trim();
				String currDate = str[1].trim();
				double currOpen = Double.parseDouble(str[2].trim());
				double currHigh = Double.parseDouble(str[3].trim());
				double currLow  = Double.parseDouble(str[4].trim());
				double currClose = Double.parseDouble(str[5].trim());
				int currVolume = Integer.parseInt(str[6].trim());
				double currAdjClose = Double.parseDouble(str[7].trim());
				
				TradeDay currTradeDay = new TradeDay(currTicker, currDate, currOpen, currHigh, currLow, currClose, currVolume, currAdjClose);
				
				theTrades.add(currTradeDay);
			}
			sc.close();
		}
		
		catch (FileNotFoundException ex) {
			System.out.println("File " + fileName + " not found");
			return;
		}
		
		System.out.println("Trade data populated.\n");
	}
	
	public static void displaySplits() {
		// Print name of the first company being processed
		String currTicker = theTrades.get(0).getTicker();
		System.out.println("Processing " + currTicker + "...");
		
		int numSplits = 0; 
		int totalSplits = 0;
		boolean newCompany = false;		// Flag to check if currTicker is a different company than previous.
								// This will prevent getting false positives/negatives for splits by comparing
								// apples and oranges.
		
		// Stat 1 entry into the array to avoid going out of bounds 
		for (int x = 1; x < theTrades.size(); x++) {
			newCompany = false;		// Assume the currTicker is same company as last iteration, unless following check says otherwise.
			// If the current ticker is the first of a new company then print out the number of splits for
			// for previous company, reset the counter, and then print new company's name.
			if (!(currTicker.equals(theTrades.get(x).getTicker()))) {
				newCompany = true;
				System.out.println("splits: " + numSplits);
				totalSplits += numSplits;
				numSplits = 0;
				currTicker = theTrades.get(x).getTicker();
				System.out.println();
				System.out.println("Processing " + currTicker + "...");
			}
			// Check for the stock split conditions
			// 2:1 stock split
			if (!newCompany && Math.abs(theTrades.get(x).getClose() / theTrades.get(x-1).getOpen() - 2.0) < 0.05) {
				System.out.println("2:1 split on " + theTrades.get(x).getDate() + " " + 
						theTrades.get(x).getClose() + " --> " + theTrades.get(x-1).getOpen());
				numSplits += 1;
			}
			// 3:1 stock split
			else if (!newCompany && Math.abs(theTrades.get(x).getClose() / theTrades.get(x-1).getOpen() - 3.0) < 0.05) {
				System.out.println("3:1 split on " + theTrades.get(x).getDate() + "\t" + 
						theTrades.get(x).getClose() + " --> " + theTrades.get(x-1).getOpen());
				numSplits +=1;
			}
			// 3:2 stock split
			else if (!newCompany && Math.abs(theTrades.get(x).getClose() / theTrades.get(x-1).getOpen() - 1.5) < 0.05) {
				System.out.println("3:2 split on " + theTrades.get(x).getDate() + "\t" + 
						theTrades.get(x).getClose() + " --> " + theTrades.get(x-1).getOpen());
				numSplits += 1;
			}
		}
		System.out.println("splits: " + numSplits);
		System.out.println();
		System.out.println("Total # of trades:  " + theTrades.size());
		System.out.println("Total # of splits:  " + totalSplits);
	}
	
	public static void main(String[] args) {
		populateArray();
		displaySplits();
	}
}
