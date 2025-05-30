package felchs330Assgn3;

public class MagicStrings {
	public static String[] getStockDBStrings() {
		String[] retval = new String[3];
		retval[0] = "jdbc:mysql://db.cs.wwu.edu/CS330_201410";
		retval[1] = "felchs_reader";
		retval[2] = "9qwJFXWM";
		return retval;
	}
	
	public static String[] getNewDBStrings() {
		String[] retval = new String[3];
		retval[0] = "jdbc:mysql://db.cs.wwu.edu/felchs";
		retval[1] = "felchs_writer";
		retval[2] = "B29RbAyZ";
		return retval;
	}
}
