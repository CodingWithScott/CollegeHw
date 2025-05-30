/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345name;

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
		/* TODO construct a Word object and return it. */
		return null;
	}
	
	/**
	 * Make a VocabTerm.
	 * @param name the String name for the VocabTerm
	 * @return The created IVocabTerm object
	 */
	@Override
	public IVocabTerm makeVocabTerm(String name) {
		/* TODO construct a VocabTerm object and return it. */
		return null;
	}
	
	/**
	 * Make a Room.
	 * @param name the String name for the Room
	 * @param desc the String description for the Room
	 * @return The created IRoom object
	 */
	@Override
	public IRoom makeRoom(String name, String desc) {
		/* TODO construct a Room object and return it. */
		return null;
	}
	
	/**
	 * Make a Path between rooms
	 * @param vocab an IVocabTerm for words that designate the path
	 * @param from the IRoom object where the path originates
	 * @param to the IRoom object where the path terminates
	 */
	@Override
	public void makePath(IVocabTerm vocab, IRoom from, IRoom to) {
		/* TODO create a Path object. */
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
		/* TODO create an Action. */
	}
	
	/**
	 * Make a Player.
	 * @param name the name of the player
	 */
	@Override
	public IPlayer makePlayer(String name) {
		/* TODO construct a Player object and return it. */
		return null;
	}

}
