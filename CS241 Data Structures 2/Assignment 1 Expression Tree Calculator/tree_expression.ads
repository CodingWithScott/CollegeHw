--------------------------------------------------------------------------------
-- CSCI 241, Assignment 1: Expression Tree
-- Tree_Expression.ads
-- Spec file for building and processing expression trees

-- Originally from Yudong, made some slight modifications myself.
-- Changes: moved Float_Functions to package body, changed traversal from functions to procedures
-- Removed: removed To_String function, Tree_string data type
--------------------------------------------------------------------------------
with Gen_Tree, Ada.Numerics.Generic_Elementary_Functions, Ada.Strings.Fixed;
use Ada.Strings.Fixed;
PACKAGE Tree_Expression IS

	type Guts is record
		operator :	character := '#';
		number	:	integer := -1000;
	end record;
	
	package Binary_Expression_Tree is new Gen_Tree(Guts);
		use Binary_Expression_Tree;

	subtype Expression_Node_Ptr is Binary_Expression_Tree.Node_Ptr;

	function Construct_ExpressionTree (Expression_String : String; First, Last : Natural) return Expression_Node_Ptr;
	
	function Evaluate_Expression (Input : Expression_Node_Ptr) return Float;

	procedure Infix_Notation   (Node : Expression_Node_Ptr);
	procedure Prefix_Notation  (Node : Expression_Node_Ptr);
	procedure Postfix_Notation (Node : Expression_Node_Ptr);

end Tree_Expression;
