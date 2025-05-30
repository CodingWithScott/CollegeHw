/**
 * 
 */
package cs345felchs;

/**
 * @author felchs
 *
 */

import static cs345felchs.GameGlobals.messageOut;

public class GameItem implements IGameItem {
	String name;
	VocabTerm ident;		// VocabTerm used to identify this GameItem, contains one or more Words
							// which map to this VocabTerm
	String inventDesc;
	String hereIsDesc;
	String longDesc;
	
	// Default constructor, I don't think this will ever be used
	public GameItem() {
		this.name = "";
		this.ident = null; 
		this.inventDesc = "";
		this.hereIsDesc = "";
		this.longDesc = "";
		GameGlobals.allItems.add(this);		// Add this object to master list of all GameItems stored in GameGlobals
	}
	
	// Constructor with arguments provided for name, descriptions, and VocabTerm
	public GameItem(String name, IVocabTerm vocab, String inventDesc, String hereIsDesc, String longDesc) {
		this.name = name;
		this.ident = (VocabTerm) vocab; 
		this.inventDesc = inventDesc;
		this.hereIsDesc = hereIsDesc;
		this.longDesc = longDesc;
		GameGlobals.allItems.add(this);		// Add this object to master list of all Rooms stored in GameGlobals
	}

	// Check if the Word passed in is found in this GameItem's VocabTerm
	public boolean match(IWord w) {
		return ident.contains(w);
	}
	
	public String getName() {
		return this.name;
	}
		
	public String getInventoryDesc() {
		return this.inventDesc;
	}
	
	public String getHereIsDesc() {
		return this.hereIsDesc;
	}
	
	public String getLongDesc() {
		return this.longDesc;
	}
	
	public IVocabTerm getVocab() {
		return this.ident;
	}
	
	public void PrintVocabTerms() {
		messageOut.print("Printing content for GameItem " + this.name + "\n");
		for (int i = 0; i < this.ident.size(); i++) {
			messageOut.print("this.ident.get(" + i + ") == " + this.ident.synonyms.get(i).getWord() + "\n");
		}
	}
}