package cs345felchs;



public class Path {	
	// Each Path object is going to have a vocabTerm (ex: "north"), a Room coming from (implicit from Player's location), and a Room going to
	private IVocabTerm vocab;
	private IRoom from;
	private IRoom to;
	
	// Default constructor
	public Path() {
		this.vocab = null;
		this.from = null;
		this.to = null;
	}
	
	// Constructor accepting a vocabTerm, Room coming from, and Room going to
	public Path(IVocabTerm vocab, IRoom from, IRoom to) {
		this.vocab = vocab;
		this.from = from;
		this.to = to;
		GameGlobals.allPaths.add(this);		// Add a copy of this Path to the allPaths list in GameGlobals.
	}
	
	public IVocabTerm getVocabTerm() {
		return this.vocab;
	}
	
	public IRoom getFrom() {
		return this.from;
	}
	
	public IRoom getTo() {
		return this.to;
	}
	
}
