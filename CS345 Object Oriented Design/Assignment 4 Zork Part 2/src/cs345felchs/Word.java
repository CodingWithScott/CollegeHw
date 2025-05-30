/**
 * 
 */
package cs345felchs;

//import static cs345felchs.GameGlobals.*;

/**
 * @author felchs
 *
 */
public class Word implements IWord {
	
	private String name;		// Name of the Word
	MatchType match;			// match will be either PREFIX, EXACT, or NONE
	
	// Default constructor 
	public Word() {
		name = null;			
		match = null;
		GameGlobals.allWords.add(this);		// Add a copy of this Word to the allWords list in GameGlobals. Will be useful later, I imagine
	}
	
	// Constructor with a name and MatchType provided
	public Word(String n, MatchType m) {
		this.name = n;
		this.match = m;
		GameGlobals.allWords.add(this);		// Add a copy of this Word to the allWords list in GameGlobals. Will be useful later, I imagine
	}
	
	/* (non-Javadoc)
	 * @see cs345felchs.IWord#getWord()
	 */
	@Override
	public String getWord() {
		return this.name;
	}
	
	public String getName() {
		return ("w" + this.name);	
	}
	
	public MatchType getMatch() {
		return this.match;
	}
	
	public MatchType getMatch(String input) {
		if ((this.name.length() == input.length()) && this.name.equalsIgnoreCase(input))
			return MatchType.EXACT;
		else if ((this.name.length() > input.length()) && this.name.startsWith(input))
			return MatchType.PREFIX;
		else 
			return MatchType.NONE;
	}
	
}