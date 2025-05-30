/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345name;

import java.io.*;

import static cs345name.GameGlobals.*;

/**
 * This class is the command interpreter for a game. 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public class CommandInterp implements ICommandInterp {

	/**
	 * This boolean controls the execution of the command interpreter
	 * Setting this boolean to true, using setExit, will cause the
	 * interpreter to exit before starting the next command.
	 */
	private boolean exit = false;

	/**
	 * Construct a new command interpreter. The input and output streams
	 * to be used by the command interpreter are passed as arguments to
	 * this constructor. All input and output for the command interpreter
	 * should go through these streams.
	 * @param in the input stream for commands for the interpreter
	 * @param out the output stream for all output from the interpreter
	 */
	public CommandInterp(BufferedReader in, PrintStream out) {
		interp = this;
		commandIn = in;
		messageOut = out;
	}
	
	/**
	 * Run the command interpreter.
	 * @throws IOException
	 */
	public void run() throws IOException {
		while (!exit) {
			runOneCommand();
		}
	}
	
	/**
	 * Set the exit flag to the specified value. The old value of exit
	 * is returned.
	 * @param exit the new value for the exit flag
	 * @return the old value of the exit flag
	 */
	@Override
	public boolean setExit(boolean exit) {
		boolean old = exit;
		this.exit = exit;
		return old;
	}
	
	/**
	 * Run one command
	 * @throws IOException if there is an IOException when reading or
	 *         writing the input or output streams.
	 */
	private void runOneCommand() throws IOException {
		/* TODO Command Interpretation here. */
	}
}
