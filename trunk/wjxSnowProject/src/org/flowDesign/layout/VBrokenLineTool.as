package  org.flowDesign.layout
{
	import mx.core.UIComponent;

	public class VBrokenLineTool extends DrawingTool
	{
		//2 is enough to at least see something is happening on the screen, if we set it to 0, you wouldnt see anything.
		private static var MINIMUM_WIDTH:Number = 2;
		private static var MINIMUM_HEIGHT:Number = 2;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			this.middleX = this.startX+(this.endX-this.startX);
			this.middleY = this.startY+(this.endY-this.startY);
			graphics.clear();
			graphics.lineStyle(1, 0x000000, 1);
			graphics.moveTo(startX,startY);
			if(this.endY<this.startY)
			{
				graphics.lineTo(startX,startY-20);
				graphics.lineTo(this.endX,this.startY-20);
				super.drawArrowhead(this.endX,this.startY-20,this.endX,this.endY);
			}
			else
			{
			    graphics.lineTo(startX,startY+20);
			    graphics.lineTo(this.endX,this.startY+20);
			    super.drawArrowhead(this.endX,this.startY+20,this.endX,this.endY);
			}
			
			graphics.lineTo(this.endX,this.endY);

		}
	}
}