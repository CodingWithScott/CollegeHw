/* This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345felchs;

import java.io.*;
import java.util.*;

/**
 * This class contains the global objects for a game.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public class GameGlobals {
	
	/**
	 * A VocabTerm for all noise words.
	 */
	// Creates a new VocabTerm for holding noisewords, just give it the word "a" to start. More will be added in HardCodedGame.
//	public static IVocabTerm noiseWords = new VocabTerm("a"); 
	
	// List of all Words, VocabTerms, Actions, Rooms, etc in the game, will be populated every time a new object is created by that object's constructor
	public static ArrayList<Action>         allActions = new ArrayList<Action>();
	public static ArrayList<Handler> 	   allHandlers = new ArrayList<Handler>();
	public static ArrayList<IGameItem>        allItems = new ArrayList<IGameItem>();
	public static ArrayList<IWord>	          allNoise = new ArrayList<IWord>();
	public static ArrayList<IPlayer>  		allPlayers = new ArrayList<IPlayer>();		// List of all Players. Shouldn't there only be 1 Player? I'm not sure, I think so.
	public static ArrayList<Path>	   		  allPaths = new ArrayList<Path>();
	public static ArrayList<IRoom> 			  allRooms = new ArrayList<IRoom>();
	public static ArrayList<IVocabTerm> 	 allVocabs = new ArrayList<IVocabTerm>();
	public static ArrayList<IWord>		 	  allWords = new ArrayList<IWord>();
	public static Queue<Event>			     allEvents = new PriorityQueue<Event>();	
	
	private static int commandCounter = 0;	// Keep track of total number of Commands and Moves the Player does during the game.
	private static int moveCounter = 0;		// Will then output the numbers when exiting the game. 
	
	public static IVocabTerm noiseWords = new VocabTerm();
	
	// Public method for incrementing the Command counter so I can keep the counter itself private.
	public static void incrementCommandCounter() {
		GameGlobals.commandCounter = GameGlobals.commandCounter + 1;
	}
	
	// Public method for incrementing the Move counter so I can keep the counter itself private.
	public static void incrementMoveCounter() {
		GameGlobals.moveCounter = GameGlobals.moveCounter + 1;
	}

	// Accessor for the value of commandCounter
	public static int getCommandCounter () {
		return GameGlobals.commandCounter;
	}
	
	// Accessor for the value of moveCounter
	public static int getMoveCounter () {
		return GameGlobals.moveCounter;
	}
	
	public static void populateNoiseWords(String... words) {
		for (String w : words) {
			Word newNoiseWord = new Word(w, MatchType.PREFIX);
			noiseWords.addWord(newNoiseWord);
			allNoise.add(newNoiseWord);
		}
	}
	
	/**
	 * The player.
	 */
	public static IPlayer thePlayer;
	
	/**
	 * The command interpreter.
	 */
	public static ICommandInterp interp;
	
	/**
	 * A BufferedReader that is used to receive input from the user. This
	 * reader is initialized by the command interpreter.
	 */
	public static BufferedReader commandIn;
	
	/**
	 * A PrintStream that is used to send output to the user. This
	 * stream is initialized by the command interpreter.
	 */
	public static MessageOut messageOut;
	
	/**
	 * The constructor is private to prevent creation of any actual
	 * GameGlobals objects.
	 */
	private GameGlobals() {
		/* Block creation of a GameGlobals object. */
	}

}
