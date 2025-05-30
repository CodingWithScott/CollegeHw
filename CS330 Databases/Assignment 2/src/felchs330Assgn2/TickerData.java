package felchs330Assgn2;

public class TickerData {
	public String date;
	public double open;
	public double close;
	
	public void printTicker(){
		System.out.println(this.date + "   " + this.open + "    " + this.close);
	}
}

