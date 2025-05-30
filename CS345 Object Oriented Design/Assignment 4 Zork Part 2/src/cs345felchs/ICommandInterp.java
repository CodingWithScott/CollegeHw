/* This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345felchs;

/**
 * This is the interface provided for a Command Interpreter.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public interface ICommandInterp {

	/**
	 * This method sets the exit flag. Setting the exit flag causes the
	 * interpreter to exit when the next command is to be executed.
	 * @param exit if true, will cause the interpreter to exit at the
	 *             start of the next cycle
	 * @return the previous value the exit flag.
	 */
	public boolean setExit(boolean exit);
	public void queueEvent(Event e);
}
