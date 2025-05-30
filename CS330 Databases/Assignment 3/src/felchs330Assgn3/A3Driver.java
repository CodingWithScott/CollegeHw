/**
 * 
 */
package felchs330Assgn3;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
//import java.util.Scanner;


//import appLogic.TickerData;

/**
 * @author felchs
 *
 */
public class A3Driver {
	
	public static ArrayList<String> commonTradeDays = new ArrayList<String>();
	public static Connection connSource, connDest;
	public static ArrayList<IndustryData> industryData = new ArrayList<IndustryData>();
	public static ArrayList<String> industryNames = new ArrayList<String>();
	public static ArrayList<PerfData> perfTable = new ArrayList<PerfData>();
	public static ArrayList<String> tradeDays = new ArrayList<String>();
	public static ArrayList<String> validTickers = new ArrayList<String>();

	
	private static void initConnections() {
		try {
			String[] connString = MagicStrings.getStockDBStrings();
			connSource = DriverManager.getConnection(connString[0].trim(), connString[1].trim(), connString[2].trim());
			connString = MagicStrings.getNewDBStrings();
			connDest = DriverManager.getConnection(connString[0].trim(), connString[1].trim(), connString[2].trim());
			System.out.println("Database connections established");
			
			Statement st = connDest.createStatement();
			try {
				st.executeUpdate("drop table splits");
			}
			catch(SQLException ex) { 
				// PFFFFFFFFTTTT pfffft poot poot
			}
			System.out.println("Destination database cleared of tables");
	
			Statement stat = connDest.createStatement();
			stat.executeUpdate("create table splits (Ticker char(6), Date char(10), SplitRatio char(6), PrevClose char(15), NextOpen char(15))");
			System.out.println("Destination table ready");
		}
		catch(SQLException ex) {
			System.out.println("SQL exception\nline 47");
			ex.printStackTrace();
			return;
		}
		
	}

	// Close all connections and exit
	private static void closeConnections() {
		try {
			connSource.close(); 
			connDest.close();
			System.out.println("Database connections closed\n");
		}
		catch(SQLException ex) {
			System.out.println("SQL exception\nline 71");
			ex.printStackTrace();
			return;
		}
	}
	
	private static void getIndustryNames() {
		try {
			Statement stat = connSource.createStatement();
			
			ResultSet rs = stat.executeQuery("select distinct(Industry) " +
					"from company " +
					"order by Industry ASC;");
			while (rs.next()) 
					industryNames.add(0, rs.getString(1));
			
			System.out.println(industryNames.size() + " industries found");
			for (int i = 0; i < industryNames.size(); i++) 
				System.out.println("\t" + industryNames.get(i));
		}
		
		
		catch (SQLException e) {
			System.out.println("SQL exception");
			e.printStackTrace();
			return;
		}
	}
	
	// Gather list of all the tickers which have >= 150 days of trading data 
	private static void getValidTickers() {
		try {
			Statement stat = connSource.createStatement();
			
			ResultSet rs = stat.executeQuery("select Ticker, min(TransDate), max(TransDate), count(distinct TransDate) as tradingDays " +
					"from company natural join pricevolume " +
					"where Industry = 'Telecommunications Services' " +
					"group by Ticker " +
					"having tradingDays >= 150 " +
					"order by Ticker;");
			if (!rs.next())
				System.out.println("No usable tickers found in database");
			else {
				while (rs.next()) 
					validTickers.add(0, rs.getString(1));
				for (int i = 0; i < validTickers.size(); i++)
					System.out.println(i + ":\t" + validTickers.get(i));
			}
			
		}
		catch (SQLException e) {
			System.out.println("SQL exception");
			e.printStackTrace();
			return;
		}
	}
	
	private static void getIndustryData() {
		try {
			String[] connString = MagicStrings.getStockDBStrings();
			// Form connection to Reader database
			Statement stat = connSource.createStatement();
			ResultSet rs = stat.executeQuery("select Ticker, min(TransDate), max(TransDate), count(distinct TransDate) as tradingDays from company natural join pricevolume where Industry = 'Telecommunications Services' group by Ticker having tradingDays >= 150 order by Ticker;");
//			System.out.println("All the industry names...");
			while (rs.next()) {
				IndustryData thisData = new IndustryData();
				thisData.ticker = rs.getString(1);
				thisData.startDate = rs.getString(2);
				thisData.endDate = rs.getString(3);
				thisData.tradingDays = Integer.parseInt(rs.getString(4));
				thisData.printData();
				industryData.add(0, thisData);
			}
		
			System.out.println("Populated industry metadata into array");
		}
		
		catch (SQLException ex) {
			System.out.println("SQL exception:\t getIndustryData()");
			ex.printStackTrace();
			return;
		}
	}
	
	// Receive an industry string, loop through all PerfData objects in the array to assign start and end dates
	private static void getStartEndDays(String industry) {
		try {
			System.out.println("calling getStartEndDays with:\t" + industry);
			PreparedStatement start_date = connSource.prepareStatement("select max(startDate) " + 
						" from( " +
						" select Ticker, min(TransDate) as startDate, count(distinct TransDate) as tradingDays " + 
						" from company natural join pricevolume " + 
						" where Industry = ? " +
						" group by Ticker " +
						" having tradingDays >= 150 " +
						" )as MinTradeDay");

			start_date.setString(1, industry);
			ResultSet st_date_result = start_date.executeQuery();
			st_date_result.next();
			String st_date = st_date_result.getString(1);
			
			PreparedStatement end_date = connSource.prepareStatement("select min(endDate) from( " +
						" select Ticker, max(TransDate) as endDate, count(distinct TransDate) as tradingDays " + 
						" from company natural join pricevolume " + 
						" where Industry = ? " +
						" group by Ticker " + 
						" having tradingDays >= 150 " +
						" )as MaxTradeDay");

			end_date.setString(1, industry);
			ResultSet en_date_result = end_date.executeQuery();
			en_date_result.next();
			String en_date = en_date_result.getString(1);

			for (int i = 0; i < perfTable.size(); i++ ) {
				if (perfTable.get(i).industry.equalsIgnoreCase(industry)) {
					perfTable.get(i).startDate = st_date;
					perfTable.get(i).endDate = en_date;
				}
			}
		}
		catch (SQLException ex) {
			System.out.println("SQL exception:\t getStartEndDays()");
			ex.printStackTrace();
			return;
		}
	}
	
	private static void getCommonTradeDays() {
		try {
			PreparedStatement common_trade_days = connSource.prepareStatement("select min(tradingDays) " +
					" from " +
					" (select Ticker, min(TransDate), max(TransDate), count(distinct TransDate) as tradingDays " +
					" from company natural join pricevolume " +
					" where Industry = ? and TransDate >= ? " +
					" and TransDate <= ? " +
					" group by Ticker " +
					" having tradingDays >= 150 " + 
					" order by Ticker )as tradeInterval");
			
			System.out.println("Starting getCommonTradeDays().... God help you.");
			System.out.println("perfTable.size():\t" + perfTable.size());
			for (int i = 0; i < perfTable.size(); i++) {
//				System.out.println("line 214, iteration " + i);
				common_trade_days.setString(1, perfTable.get(i).industry);
				common_trade_days.setString(2, perfTable.get(i).startDate);
				common_trade_days.setString(3, perfTable.get(i).endDate);
				ResultSet common_trade_days_result = common_trade_days.executeQuery();
				common_trade_days_result.next();
				perfTable.get(i).commonTradeDays = Integer.parseInt(common_trade_days_result.getString(1));
			}
			System.out.println("Welcome to the other side!");
			
		}
		catch (SQLException ex) {
			System.out.println("SQL exception:\t getCommonTradeDays()");
			ex.printStackTrace();
			return;
		}
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		initConnections();
		getIndustryNames();
//		getValidTickers();
		getCommonTradeDays();
		
		try {
			// Get usable tickers (>= 150 trading days)
			PreparedStatement usableTickers = connSource.prepareStatement("select distinct(Ticker), Industry, count(distinct TransDate) as tradingDays " +
					"from company natural join pricevolume " +
					"where Industry = ? " +
					"group by Ticker " + 
					"having tradingDays >= 150 " +
					"order by Ticker;");
			
			// Iterate through every industry
			for (int i = 0; i < industryNames.size(); i++) {
				// uTR = usableTickerResults
				usableTickers.setString(1, industryNames.get(i));
				ResultSet uTR = usableTickers.executeQuery();
				// Store ticker and industry as a new object for each iteration
				while(uTR.next()) {
					PerfData currPerf = new PerfData();
					currPerf.ticker = uTR.getString(1);
//					System.out.println("ticker:\t" + uTR.getString(1));
					currPerf.industry = uTR.getString(2);
//					System.out.println("currPerf:\t" + currPerf.ticker + "\t" + currPerf.industry);
					perfTable.add(0, currPerf);
			
				}
			}

			// Fill in Start-End dates for all the PerfData objects
//			for(int i = 0; i < industryNames.size(); i++) {
//				getStartEndDays(industryNames.get(i));
				getStartEndDays("Energy");
//			}
			System.out.println("line 272");
			// Fill in Common Trade Days for all the PerfData objects
			getCommonTradeDays();
			
			// Print out perfTable to verify contents
			for (int i = 0; i < perfTable.size(); i++)
				perfTable.get(i).printPerfData();
			
			System.out.println("Total # of tickers:\t" + perfTable.size());
			closeConnections();
		}
		catch (SQLException ex) {
			System.out.println("SQL exception");
			ex.printStackTrace();
			return;
		}
	}
	
	
	private static String quote(String str) {
		return "'" + str + "'";
	}
}
