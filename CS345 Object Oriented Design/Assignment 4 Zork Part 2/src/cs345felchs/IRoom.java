/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345felchs;
import java.util.*;

/**
 * This is the interface provided for Rooms.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public interface IRoom extends IContainer {
	
	/**
	 * Get the description for the room.
	 * @return the String containing the description.
	 */
	public String getDescription();
	public ArrayList<IGameItem> getContents();
	
}
