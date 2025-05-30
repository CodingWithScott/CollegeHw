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
		messageOut = out;
		
//		String inputLine = commandIn.readLine();
//		messageOut.print(GameUtil.canonicalName(inputLine));
		
	}
	
	/**
	 * Run the command interpreter.
	 * @throws IOException
	 */
	public void run() throws IOException {
		// Fill up a list of noiseWords manually before I do anything else. Not sure how to more elegantly do this.
		GameGlobals.populateNoiseWords("a", "an", "the", "and", "it",
				"that", "this", "to", "at", "with", "room");
		// Do an initial lookAround to tell the Player their initial setting, after this lookAround will only be called
		// when moving on paths.
//		GameGlobals.allPlayers.get(0).lookAround();
		while (!exit) {
			runOneCommand();
//			messageOut.print("\n");
		}
		messageOut.println("Game is exiting now.");
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
//		messageOut.println("Entering locateWord");
		
		int timesFound = 0;
		
		int theWordLocation = -1;
		for (int i = 0; i < GameGlobals.allWords.size(); i++) {
//			messageOut.println("A");
//			messageOut.print(GameGlobals.allWords.get(i).getWord() + "\n");
			// If find an exact match, return this location
			if (input.equals(GameGlobals.allWords.get(i).getWord())) {
				theWordLocation = i;
				messageOut.println("FOund Word");
				return theWordLocation;
//				messageOut.print("Found an exact match for " + input + "\n");
			}
			// The MatchType.prefix part is going to make sure that you don't autocomplete "magic", which must be done as an exact match
//			else if ((GameGlobals.allWords.get(i).getWord().startsWith(input)) && (GameGlobals.allWords.get(i).getMatch() == MatchType.PREFIX)) {
//				timesFound++;
//				theWordLocation = i;
//			}
		}
		// If you found no instances then the input must be gibberish so return -1
//		if (timesFound == 0)
//			return -1;
//		// If you found one instance of prefix matching and no others, return location of that match.
//		else if (timesFound == 1)
//			return theWordLocation;
//		else 	// If you found multiple instances of prefix matching, return -2 to indicate multiple matches for the calling method
//			return -2;
		return theWordLocation;
	}
	
	// Will receive a String of input from the command interpreter and return the index location where this term is in allVocabs
	public int locateVocab(String input){
//		messageOut.println("Entering locateVocab");
		int theVocabLocation = -1;
		int timesFound = 0;
		
		// Outer loop reads through allVocab words
		for (int i = 0; i < GameGlobals.allVocabs.size(); i++) {
//			messageOut.println("B");
			// Inner loop reads through all Words in current VocabTerm
			for (int j = 0; j < GameGlobals.allVocabs.get(i).synonyms.size(); j++) {
				// If Input word matches with the Word in current VocabTerm, return location of VocabTerm
				if (input.equalsIgnoreCase(GameGlobals.allVocabs.get(i).synonyms.get(j).getWord())) {
//					messageOut.print("Found an exact match for " + input + "\n");
					theVocabLocation = i;
					return theVocabLocation;
				}
//				else if (GameGlobals.allVocabs.get(i).synonyms.get(j).getWord().startsWith(input) && 
//						(((Word) GameGlobals.allVocabs.get(i).synonyms.get(j)).getMatch() == MatchType.PREFIX)) {
//					timesFound++;
//					theVocabLocation = i;
//				}
			}
		}
		
//		// If you found no instances then the input must be gibberish so return -1
//		if (timesFound == 0)
//			return -1;
//		// If you found one instance of prefix matching and no others, return location of that match.
//		else if (timesFound == 1)
//			return theVocabLocation;
//		else 	// If you found multiple instances of prefix matching, return -2 to indicate multiple matches for the calling method
//			return -2;
		return theVocabLocation;
	}
	
	
	// Will test if a word is a noiseWord
	public boolean isNoiseWord(String input) {
		// Loop through all the known noiseWords
		for (int i = 0; i < GameGlobals.allNoise.size(); i++) {
			// If the input string matches up with one of the noiseWords, return true
//			messageOut.print("input: \"" + input + "\"" + "    ");
//			messageOut.print("GameGlobals.allNoise.get(" + i +"): \"" + GameGlobals.allNoise.get(i).getWord() + "\"" + "\n");
			if (input.equalsIgnoreCase((GameGlobals.allNoise.get(i).getWord()))) {
//				messageOut.print("Found a noiseword:  " + input + "\n");
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
//		boolean Invalid = false;			// Is there anything wrong with current line of input?
		
		// This is where you get input from user, validate and process it
		messageOut.print("?  ");
		RawInput = new ArrayList<String>(GameUtil.canonicalCommand(commandIn.readLine()));
		FilteredInput = new ArrayList<String>();
		
		// Going to filter out the noiseWords from RawInput so that FilteredInput is only 1 or 2 input strings
//		// Will quit after 2 times finding valid words since a valid command will only have 2 non-noiseWords
		while (count < RawInput.size() && (FilteredInputIndex < 2)) {
			if (!isNoiseWord(RawInput.get(count))){
//			if (RawInput.get(count) != "") {
				FilteredInput.add(RawInput.get(count));
				FilteredInputIndex++;
			}
			count++;
		}
		
		if (FilteredInput.size() == 1) {
			messageOut.print("ONE WORD");
			WordLocation1 = locateWord(FilteredInput.get(0));
//			messageOut.println("Entered FilteredInput.size() == 1");
//			messageOut.println("WordLocation1 = " + WordLocation1 + "\n");
		
			// Check for prefix matching (using locateWord when WordLocation1 is assigned)
			if (WordLocation1 == -1) {
				//messageOut.println("set Invalid = true");
				messageOut.println("I didn't understand " + FilteredInput.get(0) + "\n");
//				Invalid = true;
				return;
			}
			else if (WordLocation1 == -2) {
				messageOut.println("\"" + FilteredInput.get(0) + "\" could mean multiple things. Be more specific please.");
//				Invalid = true;
				return;
			}
			/* If WordLocation1 is not -1, then it means it's a valid Word and WordLocation
			is holding the index of this Word's location in allWords */
//			if ((WordLocation1 != -1) && (WordLocation1 != -2)) {
//				messageOut.println("A");
//				VocabLocation1 = locateVocab(FilteredInput.get(0));
//				messageOut.println("VocabLocation1 = " + VocabLocation1 + "\n");
//			}
			
//			if (!Invalid) {
//				messageOut.println("!Invalid");
//				If nothing is Invalid and it's only a 1 word input then find the Action based on that VocabTerm
				for (int i = 0; i < GameGlobals.allActions.size(); i++) {
//						messageOut.println("B");
//						messageOut.print("allActions.get(" + i + ").VT1.getName() = " + GameGlobals.allActions.get(i).VT1.getName() + "\n");
						if (GameGlobals.allActions.get(i).VT1.contains(GameGlobals.allWords.get(WordLocation1)) && (GameGlobals.allActions.get(i).VT2 == null)) {
//							messageOut.println("\nFound a match for Action with " + GameGlobals.allVocabs.get(VocabLocation1).getName() + "\n");
							GameGlobals.allActions.get(i).doAction(allWords.get(WordLocation1), null);
							ActionPerformed = true;
						}
				}
//			}
		}
		
		else if (FilteredInput.size() == 2) {
			messageOut.print("TWO WORDS");
//			messageOut.println("Entered FilteredInput.size() == 2");
			WordLocation1 = locateWord(FilteredInput.get(0));
			WordLocation2 = locateWord(FilteredInput.get(1));
			messageOut.print(GameGlobals.allWords.get(WordLocation1).getWord() + "\n");
			messageOut.print(GameGlobals.allWords.get(WordLocation2).getWord() + "\n");
//			messageOut.print("FilteredInput.get(0) = " + FilteredInput.get(0) + "\n");
//			messageOut.print("FilteredInput.get(1) = " + FilteredInput.get(1) + "\n");
			// Check for prefix matching (using locateWord when WordLocation1 is assigned)
			if (WordLocation1 == -1) {
				//messageOut.println("set Invalid = true");
				messageOut.println("I didn't understand " + FilteredInput.get(0));
//				Invalid = true;
				return;
			}
			else if (WordLocation1 == -2) {
				messageOut.println("\"" + FilteredInput.get(0) + "\" could mean multiple things. Be more specific please.");
//				Invalid = true;
				return;
			}
			// Check for prefix matching (using locateWord when WordLocation1 is assigned)
			if (WordLocation2 == -1) {
				//messageOut.println("set Invalid = true");
				messageOut.println("I didn't understand " + FilteredInput.get(1));
//				Invalid = true;
				return;
			}
			else if (WordLocation2 == -2) {
				messageOut.println("\"" + FilteredInput.get(1) + "\" could mean multiple things. Be more specific please.");
//				Invalid = true;
				return;
			}
			
//			need to hand a Word into locateVocab instead of 
				
//			if (!Invalid) {
//				VocabLocation1 = locateVocab(FilteredInput.get(0));
//				VocabLocation1 = locateVocab(allWords.get(WordLocation1));
//				VocabLocation2 = locateVocab(FilteredInput.get(1));
//				messageOut.println("VocabLocation1 = " + VocabLocation1 + "\n");
//				messageOut.println("VocabLocation2 = " + VocabLocation2 + "\n");
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
//			}

		}
		if (!ActionPerformed) 
			messageOut.println("I didn't understand that.");
	}
}
