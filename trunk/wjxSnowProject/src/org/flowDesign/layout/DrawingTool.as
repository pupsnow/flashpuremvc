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
		public function draw():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,0xff0000,1);
			this.graphics.moveTo(startX,startY);
			this.graphics.lineTo(endX,endY);
		}
		
		public function addNewLine(linedata:LineData):void
		{
			this.workflowdata.newLineData(linedata.fromNodeId,linedata.toNodeId,linedata.lineLabelText,linedata.lineType);
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
	}
}