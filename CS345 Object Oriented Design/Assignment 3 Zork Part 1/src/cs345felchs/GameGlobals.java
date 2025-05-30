/* This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345name;

import java.io.*;

/**
 * This class contains the global objects for a game.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public class GameGlobals {
	
	/**
	 * A VocabTerm for all noise words.
	 */
	public static IVocabTerm noiseWords; // TODO This needs to be initialized.
	
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
	 * reader isinitialized by the command interpreter.
	 */
	public static BufferedReader commandIn;
	
	/**
	 * A PrintStream that is used to send output to the user. This
	 * stream is initialized by the command interpreter.
	 */
	public static PrintStream messageOut;
	
	/**
	 * The constructor is private to prevent creation of any actual
	 * GameGlobals objects.
	 */
	private GameGlobals() {
		/* Block creation of a GameGlobals object. */
	}

}
