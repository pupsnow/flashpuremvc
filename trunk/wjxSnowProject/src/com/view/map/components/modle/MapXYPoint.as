package  com.view.map.components.modle
{
	import mx.containers.VBox;
	
	public class MapXYPoint
	{
		private static var model:MapXYPoint;
		public static function getInstance():MapXYPoint
		{
			if(model==null)
			model=new MapXYPoint();
			return model;
		}
		function MapXYPoint():void
		{
		}
		[Bindable]
		public var x:Number;
		[Bindable]
		public var y:Number;
		[Bindable]
		public var CenterX:Number;
		[Bindable]
		public var CenterY:Number;
		[Bindable]
		public var btn:VBox;
		[Bindable]
		public var zoomX:Number;
		[Bindable]
		public var zoomY:Number;
	}
}