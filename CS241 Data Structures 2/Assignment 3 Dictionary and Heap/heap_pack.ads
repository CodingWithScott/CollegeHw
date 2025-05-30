-- heap_package.ads:  implementation of a heap using an array
-- http://cs.fit.edu/~ryan/ada/programs/tree/heap_package-ads.html

generic
		type Element_Type is private;       -- The type of element in the heap
		type Heap_pack_array is array (Positive range <>) of Element_Type;
		with function ">" (Left, Right: Element_Type) return Boolean is <>;

package Heap_Pack is

	-- Assuming that the root of the heap is the only element out of
	-- place, restore the heap property:  not (Heap(Child) > Heap(Parent))
	-- Time complexity: O(log N)
	procedure Reheap_Down (Heap: in out Heap_pack_array);

	-- Assuming that the last leaf of the heap is the only element out of
	-- place, restore the heap property:  not (Heap(Child) > Heap(Parent))
	-- Time complexity: O(log N)
	procedure Reheap_Up (Heap: in out Heap_pack_array);

	-- Form a heap out of an array of objects.
	-- Time complexity: O(N log N)
	procedure Heapify (Heap: in out Heap_pack_array);

end Heap_Pack;
