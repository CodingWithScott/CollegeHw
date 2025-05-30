/**
 * 
 */
package felchsAssign1;

/**
 * @author felchs
 *
 */
public class TradeDay {
	private String ticker;
	private String date;
	private double open;
	private double high;
	private double low; 
	private double close;
	private int volume;
	private double adjClose;
	
	// Default constructor (never used)
	public TradeDay() {
		this.ticker 	= "";
		this.date 		= "";
		this.open 		= 0.0;
		this.high 		= 0.0;
		this.low  		= 0.0;
		this.close 		= 0.0;
		this.volume 	= 0;
		this.adjClose 	= 0.0;
	}
	
	// Constructor with all inputs specified
	public TradeDay(String ticker, String date, double open, double high, double low, double close, int volume, double adjClose) {
		this.ticker 	= ticker;
		this.date 		= date;
		this.open 		= open;
		this.high 		= high;
		this.low  		= low;
		this.close 		= close;
		this.volume 	= volume;
		this.adjClose 	= adjClose;
	}
	
	// Accessors and mutators
	public String getTicker() {
		return this.ticker;
	}
	public void setTicker(String ticker) {
		this.ticker = ticker;
	}
	
	public String getDate() {
		return this.date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	
	public double getOpen() {
		return this.open;
	}
	public void setOpen(double open) {
		this.open = open;
	}
	
	public double getHigh() {
		return this.high;
	}
	public void setHigh(double high) {
		this.high = high;
	}
	
	public double getLow() {
		return this.low;
	}
	public void setLow(double low) {
		this.low = low;
	}
	
	public double getClose() {
		return this.close;
	}
	public void setClose(double close) {
		this.close = close;
	}
	
	public int getVolume() {
		return this.volume;
	}
	public void setVolume(int volume) {
		this.volume = volume;
	}
	
	public double getAdjClose() {
		return this.adjClose;
	}
	public void setAdjClose(double adjClose) {
		this.adjClose = adjClose;
	}

	// Easily print out all the info from a single TradeDay. Only for troubleshooting, 
	// not used in final code, but may need for future assignments.
	public void printTradeDay() {
		System.out.print(this.ticker + " ");
		System.out.print(this.date + "      ");
		System.out.print(this.open + "      ");
		System.out.print(this.high + "      ");
		System.out.print(this.low + "      ");
		System.out.print(this.close + "      ");
		System.out.print(this.volume + "      ");
		System.out.println(this.adjClose);
	}
}
