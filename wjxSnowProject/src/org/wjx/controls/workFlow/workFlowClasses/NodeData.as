package  org.wjx.controls.workFlow.workFlowClasses
{
	public class NodeData
	{
		private var _id:String;
		public function set id(value:String):void
		{
			this._id=value;
		}
		public function get id():String
		{
			return this._id;
		}
		private var _name:String;
		public function set name(value:String):void
		{
			this._name=value;
		}
		public function get name():String
		{
			return this._name;
		}
		private var _icon:Class;
		public function set icon(value:Class):void
		{
			this._icon=value;
		}
		public function get icon():Class
		{
			return this._icon;
		}
		private var _type:String;
		public function set type(value:String):void
		{
			this._type=value;
		}
		public function get type():String
		{
			return this._type;
		}
		private var _x:int;
		public function set x(value:int):void
		{
			this._x=value;
		}
		public function get x():int
		{
			return this._x;
		}
		private var _y:int;
		public function set y(value:int):void
		{
			this._y=value;
		}
		public function get y():int
		{
			return this._y;
		}
		private var _fromNodes:Object=new Object();
		public function set fromNodes(value:Object):void
		{
			this._fromNodes=value;
		}
		public function get fromNodes():Object
		{
			return this._fromNodes;
		}
		private var _toNodes:Object=new Object();
		public function set toNodes(value:Object):void
		{
			this._toNodes=value;
		}
		public function get toNodes():Object
		{
			return this._toNodes;
		}
		public function addFromNode(fromNode:NodeData):void
		{
			this._fromNodes[fromNode.id]=fromNode;
		}
		public function delFromNode(fromNode:NodeData):void
		{
			delete this._fromNodes[fromNode.id];
		}
		public function addToNode(toNode:NodeData):void
		{
			this._toNodes[toNode.id]=toNode;
		}
		public function delToNode(toNode:NodeData):void
		{
			delete this._toNodes[toNode.id];
		}
		
		private var _nodecondition:Array;
		public function pushNodeCondition(nodetype:String):void{
			_nodecondition.push(nodetype);
		} 
		
		public function popNodeCondition(nodeType:String):String{
			var nodecondition:String=_nodecondition.shift();
			return nodecondition;
		}
		
		public function pushNodeFirstCondition(nodetype:String):void{
			_nodecondition.unshift(nodetype);
			
		}
		
		private var  _TypeId:String;
		
		public function set TypeId(typeId:String):void{
			this._TypeId=typeId;
		}
		public function get TypeId():String{
		   return this._TypeId;	
		}
			
		private var _nodeState:String=null;
		public function set nodeState(value:String):void{
			this._nodeState=value;
		}
		public function get nodeState():String{
			return this._nodeState;
		}	
		
	}
}