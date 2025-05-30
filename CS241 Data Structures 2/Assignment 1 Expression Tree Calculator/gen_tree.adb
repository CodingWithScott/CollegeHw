-- Scott Felch
-- 29 October 2012
-- CSCI 241, Assignment 2: AVL Trees
-- Generic AVL tree package body
-- Based on skeleton provided by Yudong, took out some superfluous functions. 

with Ada.Text_Io, Ada.Integer_Text_IO;
use  Ada.Text_Io, Ada.Integer_Text_IO;

package body gen_tree is
	-- Constructor function to make a new node. Should be functional
	function Create_Node(Data : Item_Type; Left_Child, Right_Child : Node_Ptr) return Node_Ptr is
	begin -- Begin Create_Node
		return new node_type'(Data, Left_Child, Right_Child);
	end Create_Node;

	function Get_Data (Node : Node_Ptr) return Item_Type is
	begin -- Begin Get_Data
		return Node.Data;
	end Get_Data;
	
	procedure Set_Data (Node : Node_Ptr; Item : Item_Type) is
	begin -- Begin Set_Data
		node.data := item;
	end Set_Data;

	function Get_Left_Child (Node : Node_Ptr) return Node_Ptr is
	begin -- Begin Get_Left_Child
		return Node.Left_Child;
	end Get_Left_Child; 

	procedure Set_Left_Child (Node : Node_Ptr; Left_Child : Node_Ptr) is
	begin -- Begin Set_Left_Child
		-- Set Left_Child pointer in Node (1st node passed in) to point to Left_Child (2nd node passed in)
		Node.Left_Child := Left_Child;
	end Set_Left_Child;

	function Get_Right_Child (Node : Node_Ptr) return Node_Ptr is
	begin -- Begin Get_Right_Child
		return Node.Right_Child;
	end Get_Right_Child; 

	procedure Set_Right_Child (Node : Node_Ptr; Right_Child : Node_Ptr) is
	begin -- Begin Set_Right_Child
		-- Set Right_Child pointer in Node (1st node passed in) to point to Right_Child (2nd node passed in)
		Node.Right_Child := Right_Child;
	end Set_Right_Child;
end gen_tree;
