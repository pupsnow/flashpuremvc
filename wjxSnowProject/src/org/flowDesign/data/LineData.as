package   org.flowDesign.data
{
	
	
	public class LineData
	{
		/**
		 *线id 
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
		 *线name 
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
		 *开始节点id 
		 */		
		private var _fromNodeId:String;
		public function set fromNodeId(value:String):void
		{
			this._fromNodeId=value;
		}
		public function get fromNodeId():String
		{
			return this._fromNodeId;
		}
		
		
		/**
		 *结束节点id 
		 */		
		private var _toNodeId:String;
		public function set toNodeId(value:String):void
		{
			this._toNodeId=value;
		}
		public function get toNodeId():*
		{
			return this._toNodeId;
		}
		
		/**
		 *线类型 
		 */		
		private var _lineType:Class;
		public  function set lineType(lineType:Class):void{
			this._lineType=lineType;
		}
		public function get lineType():Class{
			return this._lineType;
		}
		
		
		/**
		 *线状态 
		 */		
		private var _lineState:String=null;
		public function set lineState(value:String):void{
		this._lineState=value;
		}
		public function get lineState():String{
			return this._lineState;
		}
		
		/**
		* 节点其他属性
		*/			
		private var _lineProperty:IProperty;
		
		public function set lineProperty(value:IProperty):void
		{
			_lineProperty  = value;
		}
		public function get lineProperty():IProperty
		{
			return _lineProperty;
		}
	}
}