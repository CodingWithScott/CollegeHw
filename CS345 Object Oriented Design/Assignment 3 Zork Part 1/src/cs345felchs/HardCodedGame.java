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
	
	public void build() {
		
		/* wordMap is needed for all versions of hardcoded game. */
		wordMap = new HashMap<String, WordData>();

		// Last change. Noise words.
		addWords(noiseWords, MatchType.PREFIX, "a", "an", "the", "and", "it",
				"that", "this", "to", "at", "with", "room");
		
		/* These are a few words that can be used to test word recognition (Step 1). */
		final IWord wQuit = makeWord("quit", MatchType.PREFIX);
		final IWord wExit = makeWord("exit", MatchType.PREFIX);
		final IWord wKill = makeWord("kill", MatchType.PREFIX);
		final IWord wExecute = makeWord("execute", MatchType.PREFIX);
		final IWord wMagic = makeWord("magic", MatchType.EXACT);
		
		/* These define some basic VocabularyTerms and Actions that can be
		 * used without having to define rooms and paths. (Step 2)
		 */
		final IVocabTerm vQuit = builder.makeVocabTerm("quit");
		vQuit.addWord(wQuit);
		vQuit.addWord(wExit);
		
		final IVocabTerm vKill = builder.makeVocabTerm("kill");
		vKill.addWord(wKill);
		vKill.addWord(wExecute);
		
		final IVocabTerm vMagic = builder.makeVocabTerm("magic");
		vMagic.addWord(wMagic);
		
		builder.makeAction(vQuit, null, new ActionMethod() {
			@Override
			public void doAction(IWord w1, IWord w2) {
				messageOut.println("Goodbye.");
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
		
		/* This is additional vocabulary for logic to move between rooms. (Step 3)*/
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

		/* Code from this point on creates Room, Path and Player objects and the actions for moving between rooms. (Step 3)*/
		final IRoom rBalcony = builder.makeRoom("balcony", "You are on a balcony facing west, overlooking a beautiful garden. The only exit from the balcony is behind you.");
		final IRoom rNorth = builder.makeRoom("northroom", "You are in the north end of the Big Room. The room extends south from here. There is an exit to the outside to the west.");
		final IRoom rSouth = builder.makeRoom("southroom", "You are in the south end of the Big Room. The room extends north from here. There is a door in the east wall.");
		final IRoom rBallroom = builder.makeRoom("ballroom", "You are in a magnificent ballroom. The only exit is a door in the west wall.");
		final IRoom rMagic = builder.makeRoom("magicroom", "You are in the magic workshop. There are no doors in any of the walls.");

		builder.makePath(vEastIn, rBalcony, rNorth);
		builder.makePath(vWestOutExit, rNorth, rBalcony);
		builder.makePath(vSouth, rNorth, rSouth);
		builder.makePath(vNorth, rSouth, rNorth);
		builder.makePath(vEast, rSouth, rBallroom);
		builder.makePath(vWest, rBallroom, rSouth);
		
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
		
		builder.makeAction(vMagic, null, new ActionMethod() {
			final IRoom fromRoom = rSouth;
			final IRoom toRoom = rMagic;
			
			@Override
			public void doAction(IWord w1, IWord w2) {
				IRoom loc = thePlayer.getLocation();
				if (loc == fromRoom) {
					/* Can do this, we're in the right location. */
					thePlayer.apportTo(toRoom);
				} else if (loc == toRoom) {
					/* Good idea, the magic word gets you out again. */
					thePlayer.apportTo(fromRoom);
				} else {
					/* Wrong location. Act like we don't know the word. */
					messageOut.printf("I don't understand %s.", w1.getWord());
				}
			}
		});
		
		thePlayer = builder.makePlayer("You");
		thePlayer.apportTo(rBalcony);

	}

}
