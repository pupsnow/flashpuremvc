package  org.flowDesign.layout
{
	import mx.core.UIComponent;

	public class LineTool extends DrawingTool
	{		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			graphics.clear();
			graphics.lineStyle(1, 0x000000, 1);
			graphics.moveTo(startX,startY);
			graphics.lineTo(endX,endY);
		}
	}
}