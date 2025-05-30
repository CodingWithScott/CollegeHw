/**
 * 
 */
package cs345felchs;

import java.util.*;

/**
 * @author felchs
 *
 */
public interface IContainer {
	void addItem(IGameItem item);
	void removeItem(IGameItem item);
	boolean contains(IGameItem item);
	
	// What does this line do? Do I need to define "Collection"?
	Collection<IGameItem> getContents();
}