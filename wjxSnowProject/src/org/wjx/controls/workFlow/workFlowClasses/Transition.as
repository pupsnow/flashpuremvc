package  org.wjx.controls.workFlow.workFlowClasses
{
	import org.wjx.common.HashMap;
	
	public class Transition
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
		
		private var _length:int;
		public function set length(value:int)
		{
			this._length=value;
		}
		public function get length()
		{
			return this._length;
		}
		
		private var _fromX:int;
		public function set fromX(value:int)
		{
			this._fromX=value;
		}
		public function get fromX()
		{
			return this._fromX;
		}
		private var _fromY:int;
		public function set fromY(value:int)
		{
			this._fromY=value;
		}
		public function get fromY()
		{
			return this._fromY;
		}
		
		private var _toX:int;
		public function set toX(value:int)
		{
			this._toX=value;
		}
		public function get toX()
		{
			return this._toX;
		}
		private var _toY:int;
		public function set toY(value:int)
		{
			this._toY=value;
		}
		public function get toY()
		{
			return this._toY;
		}
		
		private var _fromNode:NodeData;
		public function set fromNode(value:NodeData)
		{
			this._fromNode=value;
		}
		public function get fromNode()
		{
			return this._fromNode;
		}
		private var _toNode:NodeData;
		public function set toNode(value:NodeData)
		{
			this._toNode=value;
		}
		public function get toNode()
		{
			return this._toNode;
		}
		private var _fromNodeId:String;
		public function set fromNodeId(value:String)
		{
			this._fromNodeId=value;
		}
		public function get fromNodeId()
		{
			return this._fromNodeId;
		}
		private var _toNodeId:String;
		public function set toNodeId(value:String)
		{
			this._toNodeId=value;
		}
		public function get toNodeId()
		{
			return this._toNodeId;
		}
	}
}