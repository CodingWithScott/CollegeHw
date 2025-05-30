/**
 * This work is licensed under the Creative Commons Attribution 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by/3.0/ or send a letter to
 * Creative Commons, 444 Castro Street, Suite 900,
 * Mountain View, California, 94041, USA. 
 */

package cs345felchs;

import java.io.*;
import java.util.*;

import static cs345felchs.GameGlobals.*;

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
	ArrayList<String> RawInput;
	ArrayList<String> FilteredInput;

	/**
	 * Construct a new command interpreter. The input and output streams
	 * to be used by the command interpreter are passed as arguments to
	 * this constructor. All input and output for the command interpreter
	 * should go through these streams.
	 * @param in the input stream for commands for the interpreter
	 * @param out the output stream for all output from the interpreter
	 * @throws IOException 
	 */
	public CommandInterp(BufferedReader in, PrintStream out) throws IOException {
		interp = this;
		commandIn = in;
		messageOut = new MessageOut(out, 72);
	}
	
	public void runEvents() {
		while (!(GameGlobals.allEvents.isEmpty())) {
			Event e = GameGlobals.allEvents.remove();
			for (Handler h : GameGlobals.allHandlers) {
				if (h.event == e) {
					h.doHandler(e);
				}
			}
		}
	}
	
	/**
	 * Run the command interpreter.
	 * @throws IOException
	 */
	public void run() throws IOException {
		// Flush output buffer before doing anything
		messageOut.flush();
		// Fill up a list of noiseWords manually before I do anything else. Not sure how to more elegantly do this.
		GameGlobals.populateNoiseWords("a", "an", "the", "and", "it",
				"that", "this", "to", "at", "with", "room");
		queueEvent(Event.INIT);
		// While Exit is not true, keep running Events
		while (!exit) {
			runEvents();
			// If an Exit event is run then the exit bool will have been set to True. Break without running one more command
			if (exit) 
				break;
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
	
	// Will receive a String of input from the command interpreter and return the index location where this term is in allWords list 
	public int locateWord(String input) {
		int timesFound = 0;
		
		int theWordLocation = -1;
		for (int i = 0; i < GameGlobals.allWords.size(); i++) {
			// If find an exact match, return this location
			if (input.equals(GameGlobals.allWords.get(i).getWord())) {
				theWordLocation = i;
				return theWordLocation;
			}
			// The MatchType.prefix part is going to make sure that you don't autocomplete "magic", which must be done as an exact match
			else if ((GameGlobals.allWords.get(i).getWord().startsWith(input)) && (GameGlobals.allWords.get(i).getMatch() == MatchType.PREFIX)) {
				timesFound++;
				theWordLocation = i;
			}
		}
		// If multiple instances of the word found
		if (timesFound > 1) {
			return -2;
		}
		else
			return theWordLocation;
	}
	
	// Will test if a word is a noiseWord
	public boolean isNoiseWord(String input) {
		// Loop through all the known noiseWords
		for (int i = 0; i < GameGlobals.allNoise.size(); i++) {
			// If the input string matches up with one of the noiseWords, return true
			if (input.equalsIgnoreCase((GameGlobals.allNoise.get(i).getWord()))) {
				return true;
			}
		}
		// If not match is found in allNoise then it's not a noiseWord, return false.
		return false;
	}
	
	/**
	 * Run one command
	 * @throws IOException if there is an IOException when reading or
	 *         writing the input or output streams.
	 */
	private void runOneCommand() throws IOException {
		// To do any output it's: messageOut.
		// To do any input it's:  commandIn.
		
		int WordLocation1  = -1;		// Location of Word1
		int WordLocation2  = -1;		// Location of Word2
		int FilteredInputIndex = 0;		// Will use for subscripting the FilteredInput ArrayList
		int count = 0;					// Used for noiseWords filtering
		
		boolean ActionPerformed = false;	// If no action successfully performed then this will display an error at the end of runOneCommand()
		
		// This is where you get input from user, validate and process it
		messageOut.print("?      ");
		messageOut.flush();
		RawInput = new ArrayList<String>(GameUtil.canonicalCommand(commandIn.readLine()));
		FilteredInput = new ArrayList<String>();
		
		// Going to filter out the noiseWords from RawInput so that FilteredInput is only 1 or 2 input strings
		// Will quit after 2 times finding valid words since a valid command will only have 2 non-noiseWords
		while (count < RawInput.size() && (FilteredInputIndex < 2)) {
			if (!isNoiseWord(RawInput.get(count))){
				FilteredInput.add(RawInput.get(count));
				FilteredInputIndex++;
			}
			count++;
		}
		
		if (FilteredInput.size() == 1) {
			WordLocation1 = locateWord(FilteredInput.get(0));
		
			// Check for prefix matching (using locateWord when WordLocation1 is assigned)
			if (WordLocation1 == -1) {
				messageOut.println("I didn't understand " + FilteredInput.get(0) + "\n");
				return;
			}
			else if (WordLocation1 == -2) {
				messageOut.println("\"" + FilteredInput.get(0) + "\" could mean multiple things. Be more specific please.");
				return;
			}
			
			for (int i = 0; i < GameGlobals.allActions.size(); i++) {
					if (GameGlobals.allActions.get(i).VT1.contains(GameGlobals.allWords.get(WordLocation1)) && (GameGlobals.allActions.get(i).VT2 == null)) {
						GameGlobals.allActions.get(i).doAction(allWords.get(WordLocation1), null);
						ActionPerformed = true;
					}
			}
		}
		
		else if (FilteredInput.size() == 2) {
			WordLocation1 = locateWord(FilteredInput.get(0));
			WordLocation2 = locateWord(FilteredInput.get(1)); 

			// Check for prefix matching (using locateWord when WordLocation1 is assigned)
			if (WordLocation1 == -1) {
				messageOut.println("I didn't understand " + FilteredInput.get(0));
				return;
			}
			else if (WordLocation1 == -2) {
				messageOut.println("\"" + FilteredInput.get(0) + "\" could mean multiple things. Be more specific please.");
				return;
			}
			// Check for prefix matching (using locateWord when WordLocation1 is assigned)
			if (WordLocation2 == -1) {
				messageOut.println("I didn't understand " + FilteredInput.get(1));
				return;
			}
			else if (WordLocation2 == -2) {
				messageOut.println("\"" + FilteredInput.get(1) + "\" could mean multiple things. Be more specific please.");
				return;
			}
				for (int i = 0; i < GameGlobals.allActions.size(); i++) {
					// If both VocabTerms input from user match up with VocabTerms in an Action...
					if (GameGlobals.allActions.get(i).VT2 != null) {
						if (GameGlobals.allActions.get(i).VT1.contains(GameGlobals.allWords.get(WordLocation1)) &&
							GameGlobals.allActions.get(i).VT2.contains(GameGlobals.allWords.get(WordLocation2))) {
							//	then invoke that Action
								GameGlobals.allActions.get(i).doAction(allWords.get(WordLocation1), allWords.get(WordLocation2));
								ActionPerformed = true;
						}
					}
				}
		}
		if (!ActionPerformed) 
			messageOut.println("I didn't understand that.");
	}

	@Override
	// Take an Event and queue it up in the allEvents queue stored in GameGlobals 
	public void queueEvent(Event e) {
		GameGlobals.allEvents.add(e);
	}
}