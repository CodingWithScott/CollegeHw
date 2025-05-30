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
public class Player implements IPlayer {
	
	String name;													// Player's name
	IRoom location = null;										 	// Current location
	ArrayList<IGameItem> Inventory = new ArrayList<IGameItem>();	// Inventory of everything the Player is holding
	
	// Default constructor
	public Player() {
		this.name = "";
		GameGlobals.allPlayers.add(this);		// Add this object to master list of all Players stored in GameGlobals
	}
	
	// Constructor accepting a string for name
	public Player(String name) {
		this.name = name;
		GameGlobals.allPlayers.add(this);		// Add this object to master list of all Players stored in GameGlobals
	}

	/* (non-Javadoc)
	 * @see cs345felchs.IPlayer#getLocation()
	 */
	@Override
	public IRoom getLocation() {
		return this.location;
	}

	/* (non-Javadoc)
	 * @see cs345felchs.IPlayer#apportTo(cs345felchs.IRoom)
	 */
	@Override
	public void apportTo(IRoom room) {
		// Teleport Player to whatever room is specified
		this.location = room;
//		this.lookAround();
	}

	/* (non-Javadoc)
	 * @see cs345felchs.IPlayer#startAt(cs345felchs.IRoom)
	 */
	@Override
	public void startAt(IRoom room) {
		// I can't see any way in which this actually differs from apportTo, so I'll just call appportTo.
		this.apportTo(room);
	}

	/* (non-Javadoc)
	 * @see cs345felchs.IPlayer#moveOnPath(cs345felchs.IWord)
	 */
	@Override
	public void moveOnPath(IWord pathName) {
		// pathName is the direction you're going to, ie "south", "out", etc
		for (int i = 0; i < GameGlobals.allPaths.size(); i++) {
			// Make sure that "from" the path in allPaths matches the room the Player is currently in
			if (GameGlobals.allPaths.get(i).getFrom().getDescription().equalsIgnoreCase(this.location.getDescription())) {
				// Make sure that the IWord passed in for pathName is contained in the allPaths entry's VocabTerms
				// Example: IWord is "south", make sure the Path you're looking at in allPaths can go south
				if (GameGlobals.allPaths.get(i).getVocabTerm().contains(pathName)) {
					this.apportTo(GameGlobals.allPaths.get(i).getTo());
					GameGlobals.allEvents.add(Event.MOVE);
					GameGlobals.incrementMoveCounter();
					return;	// This will exit out of the loop once an Apport has been done, so it doesn't continue looping and 
							// move multiple times in a certain direction.
				}
			}
		}
		messageOut.print("I can't move " + pathName.getWord() + ".\n");
	}

	@Override
	public void lookAround() {
		/* Print out the description of the room, then print Names descriptions of all but last Item in room, 
		 * then " and a " and the last item, then breakline. */
		messageOut.print(this.location.getDescription());
		if (this.location.getContents().size() > 1) {
			messageOut.print(" There is a");
			for (int i = 0; i < this.location.getContents().size(); i++) {
				if (i == (this.location.getContents().size() - 1)) {
					messageOut.print(", and a ");
					messageOut.print(this.location.getContents().get(i).getName() + " here.\n");
					break;
				}
				messageOut.print(" " + this.location.getContents().get(i).getName());
			}
		}
		else if (this.location.getContents().size() == 1) {
			messageOut.print(" " + this.location.getContents().get(0).getHereIsDesc());
		}
		messageOut.print("\n");
	}

	@Override
	public void addItem(IGameItem item) {
		this.Inventory.add(item);
	}

	@Override
	public void removeItem(IGameItem item) {
		this.Inventory.remove(item);
	}

	@Override
	public boolean contains(IGameItem item) {
		boolean found = false;
		// Don't try to loop through if there's nothing in the Player's Inventory
//		messageOut.print("In Player.Contains, looking for:  " + item.getName() + "\n");
		if (this.Inventory.size() < 1) 
			return false;
		else {
			// Loop through Player's inventory, if find an exact match for the name of the GameItem then the Player is already holding it, return True
			for (int i = 0; i < this.Inventory.size(); i++) {
				if (this.Inventory.get(i).getName().equals(item.getName())) {
					found = true;
				}
			}
		}
		return found;
	}

	@Override
	public Collection<IGameItem> getContents() {
		return this.Inventory;
	}

}
