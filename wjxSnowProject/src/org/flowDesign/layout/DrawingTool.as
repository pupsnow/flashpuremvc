package  org.flowDesign.layout
{
	import mx.core.UIComponent;
	
	import org.flowDesign.data.LineData;
	import org.flowDesign.data.WorkFlowData;

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
		public function set uiSelect(value:Boolean):void
		{
			
		}
		public function get uiSelect():Boolean
		{
			return true;
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