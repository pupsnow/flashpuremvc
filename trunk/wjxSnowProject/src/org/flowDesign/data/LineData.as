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
		 *线对应上的关系控件id 
		 */		
		private var _lineLabelId:String;
		public function set lineLabelId(value:String):void{
			this._lineLabelId=value;
		}
		public function get lineLabelId():String{
			return this._lineLabelId;
		}
		
	    /**
	     *关系名称 
	     */		
	    private var _lineLabelText:String;
	    public function set lineLabelText(value:String):void{
	    	this._lineLabelText=value;
	    }
	    public function get lineLabelText():String{
	    	return this._lineLabelText;
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
		private var _lineType:String;
		public  function set lineType(lineType:String):void{
			this._lineType=lineType;
		}
		public function get lineType():String{
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
		
	}
}