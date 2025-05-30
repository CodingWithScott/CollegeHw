package felchs330Assgn3;

public class TickerData {
	public String ticker;
	public String date;
	public double openPrice;
	public double closePrice;
	
	public void printData() {
		System.out.print("ticker:\t" + this.ticker + "\t");
		System.out.print("date:\t" + this.date + "\t");
		System.out.print("open:\t" + this.openPrice + "\t");
		System.out.print("close:\t" + this.closePrice + "\n");
	}
}