/**
 * 
 */
package cs345felchs;

import java.util.*;
import static cs345felchs.GameGlobals.*;

/**
 * @author felchs
 *
 */
public class VocabTerm implements IVocabTerm {
	
	private String name;
	// The ArrayList will hold all the different possible names for an object
	public ArrayList<IWord> synonyms = new ArrayList<IWord>();
	
	// Default constructor 
	public VocabTerm() {
		this.name = null;
		// Don't touch synonyms here, it's already initialized!
		GameGlobals.allVocabs.add(this);		// Add this object to master list of all VocabTerms stored in GameGlobals
	}
	
	// Constructor with a single string provided for a name
	public VocabTerm(String name) {
		this.name = name;
		//Don't touch synonyms here, it's already initialized!
		GameGlobals.allVocabs.add(this);		// Add this object to master list of all VocabTerms stored in GameGlobals
	}

	/* (non-Javadoc)
	 * @see cs345felchs.IVocabTerm#addWord(cs345felchs.IWord)
	 */
	@Override
	public void addWord(IWord word) {
		this.synonyms.add(word);
	}
	
	public String getName() {
//		return ("v" + this.name);
		return this.name; 
	}
	
	public void printWords() {
		// Loop that will go through and print each Word in the VocabTerm
		messageOut.println("Printing contents of v" + this.name + ":  \n");
		
		for (int i = 0; i < synonyms.size(); i++) {
			messageOut.print(" " + this.synonyms.get(i).getWord() + "\n");
		}
		messageOut.println(" ");		
	}
	
	public boolean contains(IWord word) {
		// Loop through this VocabTerm looking for a certain Word, if the Word is found then return true
		// otherwise return false.
//		messageOut.print("In VocabTerm contains, looking for:  " + word.getWord() + "\n");
		for (int i = 0; i < synonyms.size(); i++) {
			if (synonyms.get(i).getWord().equals(word.getWord())) {
//				messageOut.print("VocabTerm: " + this.name + " == ");
//				messageOut.print("VocabTerm.synonyms.get(" + i + ").getWord() == " + word.getWord() + "\n");
				return true;
			}
			else if (synonyms.get(i).getWord().startsWith(word.getWord()) && (word.getMatch() == MatchType.PREFIX))
				return true;
		}
		return false;
	}
	
	public int size() {
		return synonyms.size();
	}
	
}