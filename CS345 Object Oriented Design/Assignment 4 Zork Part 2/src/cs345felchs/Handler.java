/**
 * 
 */
package cs345felchs;

/**
 * @author felchs
 *
 */
public class Handler implements HandlerMethod {
	// A Handler is an object that accepts an enumerated EventType, and an anonymous class HandlerMethod, and uses these to perform the
	// Event passed in. The Handler may INIT (begin the game), perform a MOVE action, do a COMMAND (such as "get" or "kill"), or EXIT the game. 
	// It functions in essentially the same way as Action does, I basically just copied Action.java so see Action.java and ActionMethod.java for more information. 
	
	Event event;		// The enumerated Event type for this Handler
	HandlerMethod hm;	// The HandlerMethod which will be passed in as an anonymous class when this object is contructed
	
	// Default constructor, I don't think this will ever be used
	public Handler() {
		this.event = null;
		this.hm = null;
		GameGlobals.allHandlers.add(this);
	}
	
	// Overloaded constructor, accepts an Event enumerated type argument and a HandlerMethod
	public Handler(Event e, HandlerMethod hm) {
		this.event = e;
		this.hm = hm;
//		GameGlobals.allHandlers.add(this);
	}

	/* (non-Javadoc)
	 * @see cs345felchs.HandlerMethod#doHandler(cs345felchs.Event)
	 */
	@Override
	public void doHandler(Event e) {
		hm.doHandler(e);
	}
}