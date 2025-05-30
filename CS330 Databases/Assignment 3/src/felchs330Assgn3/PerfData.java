/**
 * 
 */
package felchs330Assgn3;

/**
 * @author felchs
 
 "create table performance (Industry char(30), Ticker char(6), StartDate char(10), " +
					"EndDate char(10), TickerReturn char(12), IndustryReturn char(12))
 */

public class PerfData {
	public String ticker 		= "";	// Filled in upon construction
	public String industry 		= ""; 	// ""
	public String startDate 	= "";	// Filled in with getStartEndDate() 
	public String endDate 		= "";	// ""
	public int commonTradeDays	= 0;	// Filled with commonTradeDays
	public double tickReturn	= 0.0;	// Filled in with computeReturn()
	public double indReturn 	= 0.0;	// ""
	
	public void printPerfData() {
		System.out.println("ticker:\t" + this.ticker +
				"\tindustry:\t" + this.industry + 
				"\t" + this.startDate + " - " + this.endDate + "common trades:\t" + this.commonTradeDays);
	}
}