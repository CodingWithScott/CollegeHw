/**
 * 
 */
package cs345felchs;

import static cs345felchs.GameGlobals.messageOut;

import java.util.*;

/**
 * @author felchs
 *
 */
public class Container implements IContainer {
	
//	public HashSet<IGameItem> inventory = new HashSet<IGameItem>();
	public ArrayList<IGameItem> inventory = new ArrayList<IGameItem>();

//	/* (non-Javadoc)
//	 * @see cs345felchs.IContainer#addItem(cs345felchs.IGameItem)
//	 */
//	@Override
	public void addItem(IGameItem item) {
		this.inventory.add(item);
	}

//	/* (non-Javadoc)
//	 * @see cs345felchs.IContainer#removeItem(cs345felchs.IGameItem)
//	 */
//	@Override
	public void removeItem(IGameItem item) {
		this.inventory.remove(item);
	}

//	/* (non-Javadoc)
//	 * @see cs345felchs.IContainer#contains(cs345felchs.IGameItem)
//	 */
//	@Override
	public boolean contains(IGameItem itemLookingFor) {
		boolean found = false;
		
		// Loop through Inventory looking for a certain GameItem, if the GameItem is found in the Inventory then return true
		messageOut.print("Container.contains() looking for:  " + itemLookingFor.getName() + "\n");
		for (int i = 0; i < this.inventory.size(); i++) {
			if (inventory.get(i).getName().equals(itemLookingFor.getName()))
				messageOut.print("Found " + itemLookingFor.getName() + " in " + " inventory.get( " + i + ")\n");
				found = true;
		}
		return found;
	}

//	@Override
	public Collection<IGameItem> getContents() {
		return this.inventory;
	}
	
	public boolean isEmpty() {
		if (this.inventory.isEmpty()) 
			return true;
		else
			return false;
	}
}