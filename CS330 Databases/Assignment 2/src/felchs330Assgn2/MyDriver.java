/**
 * 
 */
package felchs330Assgn2;

import java.io.File;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Scanner;

/**
 * @author felchs
 * 
 */
public class MyDriver {

	public static Connection conn;
	static ArrayList<TickerData> dataArray = new ArrayList<TickerData>();

	public static void main(String[] args) {
		try {
			// Parse login info from text file
			Scanner connStrSource = new Scanner(new File(
					"connection_string.txt"));
			String[] connString = connStrSource.nextLine().trim().split("\\s+");
			connStrSource.close();
			conn = DriverManager.getConnection(connString[0].trim(),
					connString[1].trim(), connString[2].trim());

			// Connect to DB
			System.out.println("Database connection established:   jdbc:mysql://db.cs.wwu.edu/CS330_201410   felchs_reader   ********");
			Scanner keyboard = new Scanner(System.in);

			// Get company to query
			System.out.print("Enter a ticker symbol: ");
			String ticker = keyboard.nextLine().trim();
			while (!ticker.matches("")) {
				// Populate the array of data for the company
				populateData(ticker);
				System.out.print("\nEnter a ticker symbol: ");
				ticker = keyboard.nextLine().trim();
			}
			conn.close();
			System.out.println("Database connection closed");
			keyboard.close();
		} catch (FileNotFoundException ex) {
			System.out.println("File connection_string.txt not found");
			return;
		} catch (SQLException ex) {
			System.out.println("SQL exception");
			ex.printStackTrace();
			return;
		}
	}

	// Populate the arrays of ticker data
	private static void populateData(String ticker) {
		try {
			Statement stat = conn.createStatement(); /* a SQL statement
			 holds all data from the SQL query, getting information from the
			 "pricevolume" entity */
			ResultSet rs = stat.executeQuery("select * from company where ticker = " + quote(ticker));

			if (!rs.next())
				System.out.println("Ticker " + ticker + " not found in database");
			else {
				System.out.println(rs.getString(2)); // Print company name
			
				rs = stat.executeQuery("select * from pricevolume where ticker = " + quote(ticker) + " order by transDate DESC ");
				// If invalid ticker then report error
				if (!rs.next())
					System.out.println("\nNo data for ticker " + ticker);
				else {
					// Populate dataArray from database
					boolean done = false;
					while (!done) {
						TickerData data = new TickerData(); // Create TickerData for
															// current day X
						data.date = rs.getString(2).trim();
						
						// Pulling field 3 from pricevolume, "OpenPrice"
						data.open = Double.parseDouble(rs.getString(3).trim());
						// Pulling field 6 from pricevolume, "ClosePrice"
						data.close = Double.parseDouble(rs.getString(6));
						// Add current elem to index=0, shift everything right by 1
						dataArray.add(0, data); 
	
						// Finished populating dataArray
						if (!rs.next())
							done = true;
					}
	
					double open = 0.0; // Will store opening price of next day (x-1)
					double close = 0.0; // Will store closing price for current day (x)
					double ratio = 0.0; // Ratio of close(x)/open(x-1)
					String date = ""; // Curr date
					ArrayList<String> results = new ArrayList<String>(); // Hold all the results
	
					// Now modify original data to adjusted data
					for (int x = 0; x < dataArray.size() - 1; x++) {
						close = dataArray.get(x).close; // X is today
						open = dataArray.get(x + 1).open; // X+1 is the next day
						ratio = close / open;
						date = dataArray.get(x).date;
	
						// 2:1 stock split
						if (Math.abs(ratio - 2.0) < 0.13) {
							results.add("2:1 split on " + date + " " + close + " --> " + open);
							for (int y = x; y >= 0; y--) {
								dataArray.get(y).close /= 2;
								dataArray.get(y).open /= 2;
							}
						}
						// 3:1 stock split
						else if (Math.abs(ratio - 3.0) < 0.13) {
							results.add("3:1 split on " + date + " " + close + " --> " + open);
							
							for (int y = x; y >= 0; y--) {
								dataArray.get(y).close /= 3;
								dataArray.get(y).open /= 3;
							}
						}
						// 3:2 stock split
						else if (Math.abs(ratio - 1.5) < 0.13) {
							results.add("3:2 split on " + date + " " + close + " --> " + open);
							
							for (int y = x; y >= 0; y--) {
								dataArray.get(y).close /= 1.5;
								dataArray.get(y).open /= 1.5;
							}
						}
					}
	
					for (int i = results.size()-1; i >= 0; i--)
						System.out.println(results.get(i));
					
					performTransactions(ticker);
					dataArray.clear();	// Clear dataArray before next query to avoid errantly accumulating values
				}
			}
		} catch (SQLException ex) {
			System.out.println("SQL exception in processTicker");
		}
	}

	private static void performTransactions(String ticker) {
		double money = 0.0; // Current balance of money I have
		int shares = 0; // Number of shares I own of current company

		double sum = 0.0; // Sum of closing price for last 50 days
		double avg = 0.0; // Running average of closing price the last 50 days
							// of transactions
		int trans_count = 0; // Running total of transactions
		double net_gain = 0.0; // Total money earned from our stock scam

		System.out.println("\nExecuting investment strategy");

		for (int x = 0; x < dataArray.size() - 1; x++) {
			// Compute average
			if (x > 49) {
				sum = 0.0;
				for (int y = x - 50; y < x; y++) {
					sum += dataArray.get(y).close;
				}
				avg = sum / 50;
			}

			// Buy shares if closing price is >3% drop from open price
			if ((dataArray.get(x).close < avg)
					&& ((dataArray.get(x).open - dataArray.get(x).close) / dataArray.get(x).open) >= 0.03) {
				shares += 100;
				money = money - 8.00 - (dataArray.get(x + 1).open * 100);
				trans_count += 1;
			}
			// Sell shares if open price is >1% increase from yesterday's price
			else if (shares >= 100
					&& (dataArray.get(x).open > avg)
					&& (dataArray.get(x).open - dataArray.get(x - 1).close)
							/ dataArray.get(x - 1).close >= 0.01) {
				shares -= 100;
				money = money
						- 8.00
						+ ((((dataArray.get(x).open + dataArray.get(x).close) / 2)) * 100);
				trans_count += 1;
			}
		}

		// Net gain is final balance + value of all shares sold at the final
		// day's opening price
		net_gain = money + (shares * dataArray.get(dataArray.size() - 1).open);
		double roundedMoneyValue = Math.round(net_gain * 100.0)/100.0;
		
		System.out.println("Transactions executed:\t" + trans_count);
		System.out.println("Net gain:\t" + roundedMoneyValue);
	}

	private static String quote(String str) {
		return "'" + str + "'";
	}
}
