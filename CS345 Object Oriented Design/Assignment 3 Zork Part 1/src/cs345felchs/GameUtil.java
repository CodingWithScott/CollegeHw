/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345name;

import java.util.*;

/**
 * This class provides a collection of convenience functions for use
 * in the game.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public class GameUtil {
	
	/**
	 * Converts a string to a canonical form of that string. The
	 * canonical form of the string has all characters in lower
	 * case and all white space reduced to single spaces.
	 * 
	 * @param name the string to be canonicalized
	 * @return the canonical form of the string
	 */
	public static String canonicalName(final String name) {
		return name.trim().toLowerCase().replaceAll("\\s+", " ");	
	}
	
	/**
	 * Parse a command line and return a List of the individual words
	 * in that line. All words in the line are converted to canonical
	 * form which is all lower case characters. If the line is null or
	 * all white space characters, a List of length zero is returned.
	 * 
	 * @param command a String which is the command line
	 * @return a List containing the individual words.
	 */
	public static List<String> canonicalCommand(final String command) {
		String[] strs = command.trim().toLowerCase().split("\\s+");
		/* If the last argument is a null string, which happens on all
		 * blank input, get rid of it.
		 */
		int last = strs.length;
		if (last > 0 && strs[last - 1].equals("")) {
			last -= 1;
			strs = Arrays.copyOf(strs, last);
		}
		return Arrays.asList(strs)	;	
	}
	
	/**
	 * Join a collection of Strings by concatenating the strings with
	 * the delimiter string separating pairs of strings. For example,
	 * <code>join(iter, ", ")</code> will return "a, b, c" assuming that
	 * the iterator iter yields the three strings "a", "b", and "c".
	 * 
	 * @param items		an iterator for the collection of strings
	 * @param delim		the delimiter string that separates the strings
	 * @return		a string containing all the strings returned by the
	 * 				iterator separated by the delimiter string
	 */
	public static String join(Iterator<String> items, String delim) {
		final StringBuffer buff = new StringBuffer();
		boolean first = true;
		while (items.hasNext()) {
			final String str = items.next();
			if (first) {
				first = false;
			} else {
					buff.append(delim);
			}
			buff.append(str);
		}
		return buff.toString();
	}
	
	/**
	 * Join the strings in an array of strings. See <code>
	 * join(Iterator<String>, String)</code> for more information.
	 */
	public static String join(final String[] items, String delim) {
		return join(Arrays.asList(items).iterator(), delim);
	}
	
	/**
	 * Join the strings in any collection of strings that implements
	 * the <code>Iterable</code> interface. See <code>join(Iterator<String>, String)</code>
	 * for more information.
	 */
	public static String join(final Iterable<String> items, String delim) {
		return join(items.iterator(), delim);
	}
}
