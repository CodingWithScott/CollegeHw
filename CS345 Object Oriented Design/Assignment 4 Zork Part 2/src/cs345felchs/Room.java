/**
 * 
 */
package cs345felchs;

import java.util.*;

/**
 * @author felchs
 *
 */
public class Room implements IRoom {
	
	private String name;		// Room name
	private String desc; 		// Room description
	static ArrayList<Path> RoomPaths = new ArrayList<Path>();	// List of all paths connected to this Room
	ArrayList<IGameItem> Inventory = new ArrayList<IGameItem>(); 

	// Default constructor, I don't think this will ever be used
	public Room() {
		this.name = "";
		this.desc = "";
		GameGlobals.allRooms.add(this);		// Add this object to master list of all Rooms stored in GameGlobals
	}
	
	// Constructor with arguments provided for name, description
	public Room(String name, String desc) {
		this.name = name;
		this.desc = desc;
		GameGlobals.allRooms.add(this);		// Add this object to master list of all Rooms stored in GameGlobals
	}
	
	public String getName() {
		return this.name;
	}
	/* (non-Javadoc)
	 * @see cs345felchs.IRoom#getDescription()
	 */
	@Override
	public String getDescription() {
		return this.desc;
	}
	
	/* Will need to keep track of all paths to/from this room, so when a new path is created GameBuilder will invoke the addPath
	methods for both Rooms involved. */ 
	public void addPath(Path pathToAdd){
		RoomPaths.add(pathToAdd);
	}

	@Override
	// Add an item to the Room's inventory
	public void addItem(IGameItem item) {
//		messageOut.print("room.addItem(" + item.getName() + ")\n");
		this.Inventory.add(item);
	}

	@Override
	// Remove an item from the Room's inventory
	public void removeItem(IGameItem item) {
		this.Inventory.remove(item);
	}

	@Override
	public boolean contains(IGameItem item) {
 		boolean found = false;
		// Don't try to loop through if there's nothing in the Room's Inventory
		if (this.Inventory.size() > 0) {
			// Loop through Room's inventory, if find an exact match for the name of the GameItem then the Room already contains it, return True
			for (int i = 0; i < this.Inventory.size(); i++) {
				if (item.getName().equals(this.Inventory.get(i).getName())) {
					found = true;
				}
			}
		}
		return found;
	}

	@Override
	public ArrayList<IGameItem> getContents() {
		return this.Inventory;
	}
	
}
