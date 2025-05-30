/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345name;

/**
 * This is the interface provided for Vocab Items.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public interface IVocabTerm {
	
	/**
	 * Add the given word to this VocabTerm.
	 * @param word the word to be added
	 */
	public void addWord(IWord word);
	
}
