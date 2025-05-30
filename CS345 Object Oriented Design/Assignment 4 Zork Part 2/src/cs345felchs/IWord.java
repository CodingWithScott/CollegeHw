/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345felchs;

/**
 * This is the interface provided for words.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public interface IWord {
	
	/**
	 * Get the string for the word represented by this word.
	 * @return the String for the word
	 */
	String getWord();
	MatchType getMatch();
}