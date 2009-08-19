package  org.flowDesign.layout
{
	import mx.core.UIComponent;

	public class HBrokenLineTool extends DrawingTool
	{
		//2 is enough to at least see something is happening on the screen, if we set it to 0, you wouldnt see anything.
		private static var MINIMUM_WIDTH:Number = 2;
		private static var MINIMUM_HEIGHT:Number = 2;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			graphics.clear();
			graphics.lineStyle(this.lineWidth, this.lineColor, 1);
			graphics.moveTo(startX,startY);
			if(this.endX<this.startX)
			{
				graphics.lineTo(startX-60,startY);
				graphics.lineTo(this.startX-60,this.endY);
				super.drawArrowhead(this.startX-60,this.endY,this.endX,this.endY);
			}
			else
			{
			    graphics.lineTo(startX+60,startY);
			    graphics.lineTo(this.startX+60,this.endY);
			    super.drawArrowhead(this.startX+60,this.endY,this.endX,this.endY);
			}
			
			graphics.lineTo(this.endX,this.endY);
		}
	}
}