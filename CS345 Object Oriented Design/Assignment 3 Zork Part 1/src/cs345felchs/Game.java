/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345name;

import java.io.*;

/**
 * This class provides a main program for the interactive fiction
 * engine. This class creates a new IBuilder and a new 
 * interpreter and invokes them.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public class Game {

	/**
	 * @param args		command line arguments (not used)
	 * @throws IOException if there is an unhandled I/O error
	 */
	public static void main(String[] args) throws IOException {

		/* Create the command interpreter for the game. The command
		 * interpreter is initialized with a BufferedReader which
		 * is the source of used input and a PrintStream which is
		 * the target for the user output.
		 */
		CommandInterp ci = new CommandInterp(
				new BufferedReader(new InputStreamReader(System.in)),
				System.out);
		
		/* Create a GameBuilder object and pass it to the
		 * HardCodedGame to create the game.
		 */
		IBuilder gb = new GameBuilder();
		new HardCodedGame(gb).build();
		
		/* Run the command interpreter to play the game. */
		ci.run();
	}

}
