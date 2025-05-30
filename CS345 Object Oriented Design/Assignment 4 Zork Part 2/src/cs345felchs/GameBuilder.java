/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345felchs;

/**
 * This class is a skeleton for implementation of an IBuilder for the game.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public class GameBuilder implements IBuilder {
	
	/**
	 * Make a Word
	 * @param word the string value for the word
	 * @param match the MatchType for the word, either MatchType.PREFIX
	 *              or MatchType.EXACT
	 * @return the created IWord object
	 */
	
	@Override
	public IWord makeWord(String word, MatchType match) {
		// Create new Word object, named word, using the Word constructor
		Word newWord = new Word(word, match);
		return newWord;
	}
	
	/**
	 * Make a VocabTerm.
	 * @param name the String name for the VocabTerm
	 * @return The created IVocabTerm object
	 */
	@Override
	public IVocabTerm makeVocabTerm(String name) {
		// Create a new VocabTerm object, using provided String for the name
		VocabTerm newVocabTerm = new VocabTerm(name);
		return newVocabTerm;
	}
	
	/**
	 * Make a Room.
	 * @param name the String name for the Room
	 * @param desc the String description for the Room
	 * @return The created IRoom object
	 */
	@Override
	public IRoom makeRoom(String name, String desc) {
		// Create a new Room object, using provided Strings for name and description
		IRoom newRoom = new Room(name, desc);
		return newRoom;
	}
	
	/**
	 * Make a Path between rooms
	 * @param vocab an IVocabTerm for words that designate the path
	 * @param from the IRoom object where the path originates
	 * @param to the IRoom object where the path terminates
	 */
	@Override
	public void makePath(IVocabTerm vocab, IRoom from, IRoom to) {
		// Creates a new Path. Doesn't return the value, the call to the constructor will store it in GameGlobals.allPaths 
		Path newPath = new Path(vocab, from, to);
		newPath.equals(newPath);
	}
	
	/**
	 * Make an Action and add it to the set of all Action.
	 * @param vocab1 the first VocabTerm for this Action.
	 * @param vocab2 the second VocabTerm for this Action or null if there
	 *               is no second VocabTerm.
	 * @param action the actual action to be executed.
	 */
	@Override
	public void makeAction(IVocabTerm vocab1, IVocabTerm vocab2, ActionMethod action) {
		// Create a new Action object called newAction, invoking the Action 
		Action newAction = new Action(vocab1, vocab2, action);
		newAction.equals(newAction);	// This line does nothing except make the warning go away saying that "newAction is unused".
	}
	
	/**
	 * Make a Player.
	 * @param name the name of the player
	 */
	@Override
	public IPlayer makePlayer(String name) {
		Player newPlayer = new Player(name);
		return newPlayer;
	}
	
	public IGameItem makeGameItem(String name, IVocabTerm vocab, String inventoryDesc, String hereIsDesc, String longDesc) {
		IGameItem newIGameItem = new GameItem(name, vocab, inventoryDesc, hereIsDesc, longDesc);
		return newIGameItem; 
	}
	
	public void makeHandler(Event e, HandlerMethod hm) {
		Handler newHandler = new Handler(e, hm);
		GameGlobals.allHandlers.add(newHandler);
	}
}
