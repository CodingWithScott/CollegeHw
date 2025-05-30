generic

	-- the generic parameter: the type of item to be queued
	type element_type is private;
	
package gen_queue is

	type queue_type is limited private;

	-- procedure enqueue
	-- purpose:	add an item to the tail of the queue
	procedure enqueue(queue : in out queue_type; item : in element_type);
	
	-- procedure dequeue
	-- purpose:	remove the item from the front of the queue
	-- exception:	raises queue_underflow on attempt to dequeue from an empty queue 
	procedure dequeue(queue : in out queue_type; item : out element_type);
	
	-- function isEmpty
	-- purpose:	determine whether the queue is empty
	function isEmpty(queue : in queue_type) return boolean;
	
	queue_underflow : exception;
	
private

	-- data type for the linked list items
	type node_type;
	type node_link is access node_type;
	type node_type is record
		data : element_type;
		next : node_link := null;
	end record;
	
	-- data type for the queue
	type queue_type is record
		head : node_link := null;
		tail : node_link := null;
	end record;
	
end gen_queue;
