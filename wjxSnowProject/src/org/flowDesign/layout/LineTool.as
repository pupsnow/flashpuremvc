package  org.flowDesign.layout
{
	import mx.core.UIComponent;

	public class LineTool extends DrawingTool
	{		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			graphics.clear();
			graphics.lineStyle(this.lineWidth, this.lineColor, 1);
			graphics.moveTo(startX,startY);
			super.drawArrowhead(this.startX,this.startY,this.endX,this.endY);
			graphics.lineTo(endX,endY);
		}
	}
}