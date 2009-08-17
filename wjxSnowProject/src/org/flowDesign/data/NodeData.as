package   org.flowDesign.data
{
	public class NodeData
	{
		/**
		 *节点id 
		 */		
		private var _id:String;
		public function set id(value:String):void
		{
			this._id=value;
		}
		public function get id():String
		{
			return this._id;
		}
		/**
		 *节点name 
		 */		
		private var _name:String;
		public function set name(value:String):void
		{
			this._name=value;
		}
		public function get name():String
		{
			return this._name;
		}
		/**
		 *节点对应的图标 
		 */		
		private var _icon:Class;
		public function set icon(value:Class):void
		{
			this._icon=value;
		}
		public function get icon():Class
		{
			return this._icon;
		}
		
		/**
		 *节点类型 
		 */		
		private var _type:String;
		public function set type(value:String):void
		{
			this._type=value;
		}
		public function get type():String
		{
			return this._type;
		}
		/**
		 *节点x 
		 */		
		private var _x:int;
		public function set x(value:int):void
		{
			this._x=value;
		}
		public function get x():int
		{
			return this._x;
		}
		/**
		 *节点y 
		 */		
		private var _y:int;
		public function set y(value:int):void
		{
			this._y=value;
		}
		public function get y():int
		{
			return this._y;
		}
		/**
		 *上一步流程节点 
		 */		
		private var _fromNodes:Object=new Object();
		public function set fromNodes(value:Object):void
		{
			this._fromNodes=value;
		}
		public function get fromNodes():Object
		{
			return this._fromNodes;
		}
		
		/**
		 *下一步流程节点 
		 */		
		private var _toNodes:Object=new Object();
		public function set toNodes(value:Object):void
		{
			this._toNodes=value;
		}
		public function get toNodes():Object
		{
			return this._toNodes;
		}
		/**
		 * 添加上一步节点 
		 * @param fromNode
		 * 
		 */		
		public function addFromNode(fromNode:NodeData):void
		{
			this._fromNodes[fromNode.id]=fromNode;
		}
		/**
		 *删除上一步节点 
		 * @param fromNode
		 * 
		 */		
		public function delFromNode(fromNode:NodeData):void
		{
			delete this._fromNodes[fromNode.id];
		}
		
		/**
		 *添加下一步节点 
		 * @param toNode
		 * 
		 */		
		public function addToNode(toNode:NodeData):void
		{
			this._toNodes[toNode.id]=toNode;
		}
		
		/**
		 *删除下一步节点 
		 * @param toNode
		 * 
		 */		
		public function delToNode(toNode:NodeData):void
		{
			delete this._toNodes[toNode.id];
		}
		
		/**
		 *增加后面节点条件 
		 */		
		private var _nodecondition:Array;
		public function pushNodeCondition(nodetype:String):void{
			_nodecondition.push(nodetype);
		} 
		
		/**
		 * 增加前面节点条件
		 * @param nodeType
		 * @return 
		 * 
		 */		
		public function popNodeCondition(nodeType:String):String{
			var nodecondition:String=_nodecondition.shift();
			return nodecondition;
		}
		/**
		 *删除前面节点条件 
		 * @param nodetype
		 * 
		 */		
		public function pushNodeFirstCondition(nodetype:String):void{
			_nodecondition.unshift(nodetype);
			
		}
		
		/**
		 *类型Id 
		 */		
		private var  _TypeId:String;
		public function set TypeId(typeId:String):void{
			this._TypeId=typeId;
		}
		public function get TypeId():String{
		   return this._TypeId;	
		}
		
		/**
		 *节点类型 
		 */			
		private var _nodeState:String=null;
		public function set nodeState(value:String):void{
			this._nodeState=value;
		}
		public function get nodeState():String{
			return this._nodeState;
		}	
		
	}
}