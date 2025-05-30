/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345name;

import static cs345name.GameGlobals.*;

import java.util.*;

/**
 * This class builds a hard coded game.
 * 
 * @author Chris Reedy (Chris.Reedy@wwu.edu)
 */
public class HardCodedGame {
	
	// CHANGE Events. Static variables used by handlers.
	static int numCmd = 0;
	static int numMove = -1; // -1 to eliminate first non-move
	
	private IBuilder builder;
	
	private class WordData {
		MatchType m;
		IWord word;
		
		WordData(MatchType m, IWord word) {
			this.m = m;
			this.word = word;
		}
	}
	
	/* wordMap is a used inside the HardCodedGame to track constructed
	 * words. This is used to keep build() from building the same word
	 * multiple times. wordMap is private to the HardCodedGame class.
	 */
	private Map<String, WordData> wordMap;
	
	HardCodedGame(IBuilder builder) {
		this.builder = builder;
	}
	
	private IWord makeWord(String w, MatchType m) {
		WordData wData = wordMap.get(w);
		if (wData != null) {
			assert wData.m == m : "Differing MatchTypes for " + w; 
			return wData.word;
		}
		IWord newWord = builder.makeWord(w, m);
		wordMap.put(w, new WordData(m, newWord));
		return newWord;
	}
	
	private void addWords(IVocabTerm vocab, MatchType match, String... words) {
		for (String w : words) {
			IWord word = makeWord(w, match);
			vocab.addWord(word);
		}
	}
	
	// CHANGE GameItems. The findItem method is needed by actions
	// related to GameItems.
	private static IGameItem findItem(IWord w) {
		for (IGameItem it : allItems) {
			if (it.match(w)) {
				return it;
			}
		}
		return null;
	}

	
	public void build() {
		
		/* wordMap is needed for all versions of hardcoded game. */
		wordMap = new HashMap<String, WordData>();

		addWords(noiseWords, MatchType.PREFIX, "a", "an", "the", "and", "it",
				"that", "this", "to", "at", "with", "room");
		
		final IWord wQuit = makeWord("quit", MatchType.PREFIX);
		final IWord wExit = makeWord("exit", MatchType.PREFIX);
		final IWord wKill = makeWord("kill", MatchType.PREFIX);
		final IWord wExecute = makeWord("execute", MatchType.PREFIX);
		final IWord wMagic = makeWord("magic", MatchType.EXACT);
		
		/* These define some basic VocabularyTerms and Actions that can be
		 * used without having to define rooms and paths.
		 */
		final IVocabTerm vQuit = builder.makeVocabTerm("quit");
		vQuit.addWord(wQuit);
		vQuit.addWord(wExit);
		
		final IVocabTerm vKill = builder.makeVocabTerm("kill");
		vKill.addWord(wKill);
		vKill.addWord(wExecute);
		
		final IVocabTerm vMagic = builder.makeVocabTerm("magic");
		vMagic.addWord(wMagic);
		
		// CHANGE If Events are implemented, leave this as is. If events are
		// not implemented, comment out the queueEvent call and uncomment
		// the println and setExit calls.
		builder.makeAction(vQuit, null, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				// messageOut.println("Goodbye.");
				// interp.setExit(true);
				interp.queueEvent(Event.EXIT);
			}
		});
		
		// CHANGE Events. Handler for the EXIT event.
		builder.makeHandler(Event.EXIT, new HandlerMethod() {
			@Override
			public void doHandler(Event e) {
				messageOut.printf("You used %d commands and made %d moves.\n", numCmd, numMove);
				messageOut.println("Hope you enjoyed your game. Come back and play again.");
				interp.setExit(true);
			}
		});

		builder.makeAction(vKill, null, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				messageOut.printf("What exactly is it you want me to %s?", w1.getWord());
			}
		});
		
		final IVocabTerm vKillStuff = builder.makeVocabTerm("killstuff");
		addWords(vKillStuff, MatchType.PREFIX, "gold", "silver", "floor", "wall");

		builder.makeAction(vKill, vKillStuff, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				messageOut.printf("How exactly do you propose that I %s the %s?", w1.getWord(), w2.getWord());
			}
		});
		
		final IVocabTerm vMove = builder.makeVocabTerm("move");
		addWords(vMove, MatchType.PREFIX, "move", "go", "proceed", "walk");
		
		final IVocabTerm vNorth = builder.makeVocabTerm("north");
		addWords(vNorth, MatchType.PREFIX, "north");
		final IVocabTerm vSouth = builder.makeVocabTerm("south");
		addWords(vSouth, MatchType.PREFIX, "south");
		final IVocabTerm vEast = builder.makeVocabTerm("east");
		addWords(vEast, MatchType.PREFIX, "east");
		final IVocabTerm vEastIn = builder.makeVocabTerm("eastorin");
		addWords(vEastIn, MatchType.PREFIX, "east", "in");
		final IVocabTerm vWest = builder.makeVocabTerm("west");
		addWords(vWest, MatchType.PREFIX, "west");
		final IVocabTerm vWestOutExit = builder.makeVocabTerm("westoutorexit");
		addWords(vWestOutExit, MatchType.PREFIX, "west", "out", "exit");
		final IVocabTerm vDirect = builder.makeVocabTerm("direction");
		addWords(vDirect, MatchType.PREFIX, "north", "south", "east", "west", "in", "out", "exit");
		
		final IVocabTerm vLook = builder.makeVocabTerm("look");
		addWords(vLook, MatchType.PREFIX, "look");
		
		final IVocabTerm vAround = builder.makeVocabTerm("around");
		addWords(vAround, MatchType.PREFIX, "around");

		final IRoom rBalcony = builder.makeRoom("balcony", "You are on a balcony facing west, overlooking a beautiful garden. The only exit from the balcony is behind you.");
		final IRoom rNorth = builder.makeRoom("northroom", "You are in the north end of the Big Room. The room extends south from here. There is an exit to the outside to the west.");
		final IRoom rSouth = builder.makeRoom("southroom", "You are in the south end of the Big Room. The room extends north from here. There is a door in the east wall.");
		final IRoom rMagic = builder.makeRoom("magicroom", "You are in the magic workshop. There are no doors in any of the walls.");

		// CHANGE Output formatting. A room with a loooooong description.
		final IRoom rBallroom = builder.makeRoom("ballroom", "You have entered the ballroom. The room has a high ceiling with two magnificent crystal chandeliers which illuminate the room. "
				+ "The floor is a polished wooden parquet with flowers inlaid around the edge. "
				+ "The north wall is lined with mirrors while the south wall has large windows which look out on a beautiful garden. "
				+ "There is a door in the west wall of the room.");

		builder.makePath(vEastIn, rBalcony, rNorth);
		builder.makePath(vWestOutExit, rNorth, rBalcony);
		builder.makePath(vSouth, rNorth, rSouth);
		builder.makePath(vNorth, rSouth, rNorth);
		builder.makePath(vEast, rSouth, rBallroom);
		builder.makePath(vWest, rBallroom, rSouth);
		
		// CHANGE GameItems. Add vocabulary for game items.
		final IVocabTerm vExamine = builder.makeVocabTerm("examine");
		addWords(vExamine, MatchType.PREFIX, "examine");
		final IVocabTerm vInventory = builder.makeVocabTerm("inventory");
		addWords(vInventory, MatchType.PREFIX, "inventory");
		final IVocabTerm vGet = builder.makeVocabTerm("get");
		addWords(vGet, MatchType.PREFIX, "get");
		final IVocabTerm vDrop = builder.makeVocabTerm("drop");
		addWords(vDrop, MatchType.PREFIX, "drop");
		final IVocabTerm vMessage = builder.makeVocabTerm("message");
		addWords(vMessage, MatchType.PREFIX, "message", "paper");
		final IVocabTerm vCoin = builder.makeVocabTerm("coin");
		addWords(vCoin, MatchType.PREFIX, "coin", "goldcoin");
		final IVocabTerm vItems = builder.makeVocabTerm("items");
		addWords(vItems, MatchType.PREFIX, "message", "paper", "coin", "goldcoin");
		final IVocabTerm vRead = builder.makeVocabTerm("read");
		addWords(vRead, MatchType.PREFIX, "read");
		
		// CHANGE GameITems. Create two game items.
		final IGameItem iMessage = builder.makeGameItem("paper", vMessage,
				"a piece of paper",
				"There is a piece of paper here.",
				"It's a piece of paper with some writing on it.");
		
		final IGameItem iCoin = builder.makeGameItem("coin", vCoin,
				"a gold coin",
				"There is a gold coin here.",
				"It's a US golden double eagle.");

		// CHANGE GameITems. Put the items in the rooms.
		rNorth.addItem(iCoin);
		rBallroom.addItem(iMessage);
		
		builder.makeAction(vMove, vDirect, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				thePlayer.moveOnPath(w2);
			}
		});
		
		builder.makeAction(vLook, null, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				thePlayer.lookAround();
			}
		});
		
		builder.makeAction(vLook, vAround, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				thePlayer.lookAround();
			}
		});
		
		// CHANGE Events. If Events are not implemented, comment out the
		// two calls to queueEvent.
		builder.makeAction(vMagic, null, new ActionMethod() {
			final IRoom fromRoom = rSouth;
			final IRoom toRoom = rMagic;
			
			@Override
			public void doAction(IWord w1, IWord w2) {
				IRoom loc = thePlayer.getLocation();
				if (loc == fromRoom) {
					/* Can do this, we're in the right location. */
					thePlayer.apportTo(toRoom);
					interp.queueEvent(Event.MOVE);
				} else if (loc == toRoom) {
					/* Good idea, the magic word gets you out again. */
					thePlayer.apportTo(fromRoom);
					interp.queueEvent(Event.MOVE);
				} else {
					/* Wrong location. Act like we don't know the word. */
					messageOut.printf("I don't understand %s.", w1.getWord());
				}
			}
		});
		
		// CHANGE GameITems. Add five new actions for game items.
		builder.makeAction(vGet, vItems, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				IGameItem item = findItem(w2);
				assert (item != null);
				if (thePlayer.contains(item)) {
					messageOut.printf("You're already carrying %s.", item.getInventoryDesc());
				} else if (thePlayer.getLocation().contains(item)) {
					thePlayer.getLocation().removeItem(item);
					thePlayer.addItem(item);
					messageOut.printf("You're now carrying %s.", item.getInventoryDesc());
				} else {
					messageOut.printf("I can't find %s here.", item.getInventoryDesc());
				}
			}
		});
		
		builder.makeAction(vDrop, vItems, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				IGameItem item = findItem(w2);
				assert (item != null);
				if (thePlayer.contains(item)) {
					thePlayer.removeItem(item);
					thePlayer.getLocation().addItem(item);
					messageOut.printf("You've dropped %s.", item.getInventoryDesc());
				} else {
					messageOut.printf("You're not carrying %s.", item.getInventoryDesc());
				}
			}
		});
		
		builder.makeAction(vExamine, vItems, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				IGameItem item = findItem(w2);
				assert (item != null);
				if (thePlayer.contains(item)) {
					messageOut.print(item.getLongDesc());
				} else {
					messageOut.printf("You are not carrying %s.", item.getInventoryDesc());
				}
			}
		});
		
		builder.makeAction(vInventory, null, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				Collection<IGameItem> c = thePlayer.getContents();
				if (c.isEmpty()) {
					messageOut.println("You are not carrying anything.");
				} else {
					messageOut.print("You are carrying ");
					boolean first = true;
					for (IGameItem item : c) {
						if (first)
							first = false;
						else
							messageOut.print(", ");
						messageOut.print(item.getInventoryDesc());
					}
					messageOut.println(".");
				}
			}
		});
		
		builder.makeAction(vRead, vMessage, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				messageOut.printf("The %s says, \"Enjoy your game.\"", w2.getWord());
			}
		});

		thePlayer = builder.makePlayer("You");
		thePlayer.apportTo(rBalcony);
		
		// CHANGE Events. Handlers for the INIT, MOVE, and COMMAND events.
		builder.makeHandler(Event.INIT, new HandlerMethod() {
			@Override
			public void doHandler(Event e) {
				messageOut.printf("Welcome to your adventure. Have a good game.\n");
				interp.queueEvent(Event.MOVE);
			}
		});
		
		builder.makeHandler(Event.MOVE, new HandlerMethod() {
			@Override
			public void doHandler(Event e) {
				thePlayer.lookAround();
			}
		});
		
		builder.makeHandler(Event.MOVE, new HandlerMethod() {
			@Override
			public void doHandler(Event e) {
				numMove += 1;
			}
		});	

		builder.makeHandler(Event.COMMAND, new HandlerMethod() {
			@Override
			public void doHandler(Event e) {
				numCmd += 1;
			}
		});

	}

}
