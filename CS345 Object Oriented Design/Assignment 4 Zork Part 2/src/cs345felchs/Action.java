/**
 * 
 */
package cs345felchs;
//import static cs345felchs.GameGlobals.*;


/**
 * @author felchs
 *
 */
public class Action implements ActionMethod {
	// Each Action object is going to contain two VocabTerms and the ActionMethod that it'll perform
	IVocabTerm VT1;
	IVocabTerm VT2;
	ActionMethod action; 
	// The ActionMethod is just going to be blank here, it'll be specified when it's called by HardCodedGame.java
	// via an "anonymous class". See spec file for more info, page 4.
	
	// Default constructor, I don't think this will ever be used
	public Action() { 
		this.VT1 = null;
		this.VT2 = null;
		this.action = null;
		GameGlobals.allActions.add(this);		// Add this object to master list of all Actions stored in GameGlobals
	}
	
	// Constructor accepting two VocabTerms and an anonymous class for ActionMethod (it's defined at time of calling by passing in as a parameter)
	public Action(IVocabTerm VT1, IVocabTerm VT2, ActionMethod action) {
		this.VT1 = VT1;
		this.VT2 = VT2;
		this.action = action;
		GameGlobals.allActions.add(this);		// Add this object to master list of all Actions stored in GameGlobals
	}

	/* (non-Javadoc)
	 * @see cs345felchs.ActionMethod#doAction(cs345felchs.IWord, cs345felchs.IWord)
	 */
	@Override
	public void doAction(IWord w1, IWord w2) {
		// This command will execute the action method passed in as an argument and increment the global CommandCounter
		action.doAction(w1, w2);
	}
}
