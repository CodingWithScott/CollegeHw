package felchs330Assgn3;

/**
 * @author felchs
 *
 */
public class IndustryData {
	public String ticker;
	public String startDate;
	public String endDate;
	public int tradingDays;
	
	public void printData() {
		System.out.print("ticker:\t" + this.ticker + "\t");
		System.out.print("start:\t" + this.startDate  + "\t");
		System.out.print("end:\t" + this.endDate + "\t");
		System.out.print("trading days:\t" + this.tradingDays + "\n");
	}
}
