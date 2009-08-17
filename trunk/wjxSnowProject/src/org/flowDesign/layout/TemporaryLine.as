package  org.flowDesign.layout{
	
    import mx.core.UIComponent;
    import mx.events.*;

    public class TemporaryLine extends UIComponent {
    	
      public function TemporaryLine() {
          super();
        }
        
        
        /**
         * //线的类型 0为直线 1为曲线
         */        
        private var _lineType:AbstractLine;
        
        public function set lineType(type:AbstractLine):void
        {
        	this._lineType=type;
        	this.invalidateDisplayList();
        }
        public function get lineType():AbstractLine
        {
        	return this._lineType;
        }
        /**
        * 开始节点名称
        */       
       private var _startName:Node;
       public function set startName(value:Node):void{
       	this._startName=value;
       }
       public function get startName():Node{
       	return this._startName;
       }
       
       
       /**
        * 结束结点名称
        */       
       private var _endName:String;
       public function set endName(value:String):void{
       	this._endName=value;
       }
       public function get endName():String{
       	return this._endName;
       }
       
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
        	super.updateDisplayList(unscaledWidth,unscaledHeight);
        	if(lineType!=null)
        	lineType;
        }
        
        public function clear():void
        {
        	this.graphics.clear();
        	this.startName=null;
        	this.endName =null;
        }
    }
}