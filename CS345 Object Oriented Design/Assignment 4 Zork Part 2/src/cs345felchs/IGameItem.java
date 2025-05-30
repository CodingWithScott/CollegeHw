/**
 * 
 */
package cs345felchs;

/**
 * @author felchs
 *
 */
public interface IGameItem {
	boolean match(IWord w); 
	IVocabTerm getVocab();
	String getName();
	String getInventoryDesc();
	String getHereIsDesc();
	String getLongDesc();
	
	public void PrintVocabTerms();
	
}