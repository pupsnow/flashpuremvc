package  org.flowDesign.layout
{
	import mx.core.UIComponent;

	public class RectangleTool extends DrawingTool
	{
		//2 is enough to at least see something is happening on the screen, if we set it to 0, you wouldnt see anything.
		private static var MINIMUM_WIDTH:Number = 2;
		private static var MINIMUM_HEIGHT:Number = 2;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			var w:Number;
			var h:Number; 
			if( !isNaN(endX) ){
				w = startX - endX;
				h = startY - endY;
				w = Math.abs(w); //switch to positive number;
				h = Math.abs(h); //switch to positive number;
				
				if( endX < startX && endY < startY){
					w = MINIMUM_WIDTH;
					h = MINIMUM_HEIGHT;
				}
				
				//if the mouse is left of starting position, but dragging below it, start to expand then box downward (only set the MINIMUM WIDTH, not the height
				if( endX < startX && endY > startY )w = MINIMUM_WIDTH;
				
				//if the mouse is right of the starting position, and draggin above it, expand the box to the right (only set the min height)
				if( endX > startX && endY < startY )h = MINIMUM_HEIGHT;
				
				
			}else{
				w = unscaledWidth;
				h = unscaledHeight;
			}
			
			graphics.clear();
			graphics.lineStyle(1, 0x000000, 1);
			graphics.moveTo(startX,startY);
			if(this.endY<this.startY)
			{
				graphics.lineTo(startX,startY-20);
				graphics.lineTo(this.endX,this.startY-20);
			}
			else
			{
			    graphics.lineTo(startX,startY+20);
			    graphics.lineTo(this.endX,this.startY+20);
			}
			
			graphics.lineTo(this.endX,this.endY);
			
//			graphics.beginFill(0xFFFFFF,.5);
//			graphics.drawRect(startX,startY,w,h);
//			graphics.endFill();
		}
	}
}