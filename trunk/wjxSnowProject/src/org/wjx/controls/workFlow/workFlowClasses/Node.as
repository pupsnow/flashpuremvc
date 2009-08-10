package org.wjx.controls.workFlow.workFlowClasses
{
	public class Node
	{
		private var _id:String;
		public function set id(value:String)
		{
			this._id=value;
		}
		public function get id()
		{
			return this._id;
		}
		private var _name:String;
		public function set name(value:String)
		{
			this._name=value;
		}
		public function get name()
		{
			return this._name;
		}
		private var _icon:Class;
		public function set icon(value:Class)
		{
			this._icon=value;
		}
		public function get icon()
		{
			return this._icon;
		}
		private var _type:String;
		public function set type(value:String)
		{
			this._type=value;
		}
		public function get type()
		{
			return this._type;
		}
		private var _x:int;
		public function set x(value:int)
		{
			this._x=value;
		}
		public function get x()
		{
			return this._x;
		}
		private var _y:int;
		public function set y(value:int)
		{
			this._y=value;
		}
		public function get y()
		{
			return this._y;
		}
		private var _fromNodes:Object=new Object();
		public function set fromNodes(value:Object)
		{
			this._fromNodes=value;
		}
		public function get fromNodes()
		{
			return this._fromNodes;
		}
		private var _toNodes:Object=new Object();
		public function set toNodes(value:Object)
		{
			this._toNodes=value;
		}
		public function get toNodes()
		{
			return this._toNodes;
		}
		public function addFromNode(fromNode:Node):void
		{
			this._fromNodes[fromNode.id]=fromNode;
		}
		public function delFromNode(fromNode:Node):void
		{
			delete this._fromNodes[fromNode.id];
		}
		public function addToNode(toNode:Node):void
		{
			this._toNodes[toNode.id]=toNode;
		}
		public function delToNode(toNode:Node):void
		{
			delete this._toNodes[toNode.id];
		}
		
		private var _nodecondition:Array;
		public function pushNodeCondition(nodetype:String){
			_nodecondition.push(nodetype);
		} 
		
		public function popNodeCondition(nodeType:String):String{
			var nodecondition:String=_nodecondition.shift();
			return nodecondition;
		}
		
		public function pushNodeFirstCondition(nodetype:String){
			_nodecondition.unshift(nodetype);
			
		}
		
	}
}