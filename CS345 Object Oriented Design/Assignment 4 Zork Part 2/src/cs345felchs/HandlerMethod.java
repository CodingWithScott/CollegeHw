/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345felchs;

/**
 * This is the interface defines the method for an Event Handler.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public interface HandlerMethod {
	public void doHandler(Event e);
}