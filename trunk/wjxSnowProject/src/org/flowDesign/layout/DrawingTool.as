package  org.flowDesign.layout
{
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.core.UIComponent;
	
	import org.flowDesign.data.LineData;
	import org.flowDesign.data.WorkFlowData;
	import org.wjx.controls.workFlow.workFlowEvent.LineEvent;

	public class DrawingTool extends UIComponent implements IFlowUI
	{
		public var startX:Number;
		public var startY:Number;
		public var endX:Number;
		public var endY:Number;
		
		public var middleX:Number;
		public var middleY:Number;
		public var lineSelect:Boolean;
		public var type:String = "line";
		public var endName:String="";
		public var startName:String="";
		public var workflowdata:WorkFlowData;
		
		 /**
         * 线颜色
         */        
       
        private var _lineColor:uint=0x000000;
        
        public function set lineColor(color:uint):void
        {
        	if(_lineColor==color) return;
        	else
        	{
        	 this._lineColor=color;
        	 this.invalidateDisplayList();
        	}
        }
         
        public function get lineColor():uint
        {
            return this._lineColor;
        }
        
         /**
         * 线的宽度 
         */        
        
        private var _lineWidth:int=2;
        public function set lineWidth(width:int):void
        {
        	this._lineWidth=width;
        }
        public function get lineWidth():int
        {
        	return this._lineWidth;
        }
        
        
		private var _uiSelect:Boolean = false;
		public function set uiSelect(value:Boolean):void
		{
			if(_uiSelect==value) return;
			else
			{
				 _uiSelect = value;
				 this.lineSelect= _uiSelect;
				 if(_uiSelect)
				 {
				 	this.lineColor = 0xff0000;
				 	
				 }
				 else
				 {
				 	this.lineColor = 0x000000;
				 }
				
			}
		}
		public function get uiSelect():Boolean
		{
			return _uiSelect;
		}
		
		public function DrawingTool()
		{		
             initMenu();
  		}      
  	   private var  deleteMenuItem:ContextMenuItem;
       private var nodePropertyMenuItem:ContextMenuItem;
       public function initMenu():void{
	    	var contextMenu : ContextMenu = new ContextMenu();
	    	contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,mouseRightClick);
	    	contextMenu.hideBuiltInItems(); 
			deleteMenuItem = new ContextMenuItem("删除");
			deleteMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,lineDeleteClick);
			contextMenu.customItems.push(deleteMenuItem);
			
			nodePropertyMenuItem= new ContextMenuItem("属性");
			nodePropertyMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,linePropertyClick);
			contextMenu.customItems.push(nodePropertyMenuItem);
			this.contextMenu = contextMenu;
                      
	    } 
  		/**
	     * 鼠标右键  
	     * @param event
	     * @return 
	     * 
	     */	    
	    public function mouseRightClick(event:ContextMenuEvent):void
	    {
	      	if(this.lineSelect)
	      	{
	       		deleteMenuItem.enabled=true;
	       		nodePropertyMenuItem.enabled=true;
	       		this.dispatchEvent(new LineEvent(LineEvent.rightClick));
	       	}else
	       	{
	       		deleteMenuItem.enabled=false;
	       		nodePropertyMenuItem.enabled=false;
	       	}
	     }
	     /**
	      * 删除 
	      * @param event
	      * @return 
	      * 
	      */	     
	     public function lineDeleteClick(event:ContextMenuEvent):void
	     {
	     	this.dispatchEvent(new LineEvent(LineEvent.deleteClick));
	     }
	     /**
	      * 查看属性 
	      * @param event
	      * @return 
	      * 
	      */	     
	     public function linePropertyClick(event:ContextMenuEvent):void
	     {
	     	this.dispatchEvent(new LineEvent(LineEvent.propertyClick));
	     }
		public function  clear():void
		{
			this.graphics.clear();
			this.startX = 0;
			this.startY = 0;
			this.endX = 0;
			this.endY = 0;
		}
	
		public function addNewLine(linedata:LineData):void
		{
			this.workflowdata.newLineData(linedata.fromNodeId,linedata.toNodeId,linedata.lineType);
		}
		
		
		public function lineRefresh(linedata:LineData):void
		{
			var formnode:Node = this.parent.getChildByName(linedata.fromNodeId) as Node;
			var tonode:Node = this.parent.getChildByName(linedata.toNodeId) as Node;
			this.startX = formnode.x+formnode.width/2;
			this.startY = formnode.y+formnode.height/2;
			this.endX = tonode.x+tonode.width/2;
			this.endY = tonode.y+tonode.height/2;
			this.invalidateDisplayList();
		}
		/**
         * 画箭头
         * @param child
         * @return 
         * 
         */        
        public function drawArrowhead(startx:Number,starty:Number,endx:Number,endy:Number):void
        {
        	this.middleX = startx+(endx-startx)/2;
			this.middleY = starty+(endy-starty)/2;
        	graphics.lineTo(this.middleX,this.middleY);
			if(starty<endy)
			var angle:Number =-Math.abs( Math.atan2(endy-starty,endx-startx))
			else
			angle =Math.abs( Math.atan2(endy-starty,endx-startx))
			var lx:Number = this.middleX-10*Math.sin(angle);
			var ly:Number = this.middleY-10*Math.cos(angle);

			var rx:Number = this.middleX+10*Math.sin(angle);
			var ry:Number = this.middleY+10*Math.cos(angle);

			var ex:Number = this.middleX+10*Math.cos(angle);
			var ey:Number = this.middleY-10*Math.sin(angle);
			
			this.graphics.beginFill(0xff0000);
			this.graphics.moveTo(lx, ly);
			this.graphics.lineTo(rx, ry);
			this.graphics.lineTo(ex, ey);
			
			this.graphics.endFill();
			graphics.moveTo(ex, ey);
        }
	}
}