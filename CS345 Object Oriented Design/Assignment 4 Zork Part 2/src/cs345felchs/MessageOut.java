/**
 * 
 */
package cs345felchs;

import java.io.PrintStream;
import java.util.*;


/**
 * @author felchs
 *
 */
public class MessageOut {
	private int maxLength;				// Maximum length of a line of output (assuming no extra long words)
	private PrintStream ScottOut; 		// Will override the builtin printstream
	private StringBuilder buffer;		/* The buffer of all the text that will be stored in this object before 
										being output periodically. */
	private StringTokenizer st;		 	// Will hold the input string once it's broken up into individual words.
	boolean BeginNewLine = true;		/* BeginNewLine keeps track of _______________ (what does it keep track of?), 
									 	 * in order to prevent printing a space at the beginning of a newline. */
	boolean WhiteSpaceNeeded = false;	/* This is going to keep track of whether a space is needed to be inserted
	 									 * after a token. */

	// Default constructor, I don't think this will ever be used for anything.
	public MessageOut() {
		this.maxLength = 72;
		this.ScottOut = null;
		this.buffer = new StringBuilder(maxLength);
	}
	
	// Constructor with arguments provided for a PrintStream (which I still don't understand what it is)
	// and an integer for maximum line length.
	public MessageOut(PrintStream p, int maxLength) {
		this.maxLength = maxLength;
		this.ScottOut = p;
		this.buffer = new StringBuilder(maxLength);
	}
	
	private void resetBuffer() {
		buffer.setLength(0);
	}
	
	private void addToBuffer(String inputSA) {
		buffer.append(inputSA);
	}
	
	/* TODO: Figure out how to configure flags to handle punctuation and spacing correctly. 
	 * I am NOT getting a space after the ? prompt, need to fix that so I do.
	 * I AM getting a space at the beginning of newlines, need to fix it so I don't. */
	// Take the string S, store word by word in buffer until buffer reaches capacity, then flush, rinse and repeat.
	public void print(String s) {
		// First break up the input string into individual tokens, one per word
		st = new StringTokenizer(s);
		
		// Current token being analyzed while walking through all the tokens
		String currToken = "";

		/* Will add words to buffer one token at a time, until buffer has reached capacity. Then flush,
		 * continue putting tokens into the buffer, rinse and repeat until tokens are depleted.	*/ 
		while (st.hasMoreTokens()) {
			currToken = st.nextToken();
			
			// If the next token contains a ? then this is a print command for the user prompt, add a newline first.
			if (currToken.contains("?"))  
				addToBuffer(System.getProperty("line.separator"));
			
			if (WhiteSpaceNeeded) {
				addToBuffer(" ");
				WhiteSpaceNeeded = false;
			}
			
			// Check that adding next token won't exceed buffer size
			if (buffer.toString().length() + currToken.length() <= maxLength) {
				// If the token being added contains punctuation then set a flag to not insert a space on the next
				// token being entered to buffer. 
				if (currToken.equals(".") || currToken.equals(",")) {
					addToBuffer(currToken);
					WhiteSpaceNeeded = false;
				}
					
				// Otherwise if it's a full word then add the token and set a flag to add.
				else {
					addToBuffer(currToken);
					WhiteSpaceNeeded = true;
				}
			}

			// If adding token would exceed buffer size then flush the buffer before adding token.
			else if (buffer.toString().length() + currToken.length() > maxLength) {
				addToBuffer(System.getProperty("line.separator"));
				this.flush();
				/* If the token being added contains punctuation then set a flag to not insert a space on the next
				 * token being entered to buffer. */ 
				if (currToken.equals(".") || currToken.equals(",")) {
					addToBuffer(currToken);
					WhiteSpaceNeeded = false;
				}
				// Otherwise if it's a full word then add the token plus a space.
				else {
					addToBuffer(currToken);
					WhiteSpaceNeeded = true;
				}
			}
		}
	}
			
	// Take the string S and append it to the buffer of stuff to be output, and then a newline at the end of that.
	public void println(String s) {
		this.print(s + System.getProperty("line.separator"));
	}
	
	// Just do a newline with no other text.
	public void println() {
		this.print(System.getProperty("line.separator"));
	}
	
	/* Accept a string specifying formatting options, and then one or more objects. Output the contents of the objects
	 using the formatting specified in the string. (I think that's what this means??) */
	public void printf(String format, Object... args) {
			this.print(String.format(format, args));
	}
	
	public void flush() {
		ScottOut.print(buffer);
		resetBuffer();
	}
}