package  org.flowDesign.layout
{
	import flash.events.MouseEvent;
	
	public class DrawingToolManager
	{
		public static function createTool(className:Class, event:MouseEvent):DrawingTool
		{
			var newClass:DrawingTool = new className();
			newClass.startX = event.localX;
	    	newClass.startY = event.localY;
	    	newClass.endX = event.localX;
	    	newClass.endY = event.localY;
	    	newClass.invalidateDisplayList();
			return newClass;
		}
	}
}