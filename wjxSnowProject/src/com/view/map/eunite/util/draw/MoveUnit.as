package   com.view.map.eunite.util.draw
{
	public class MoveUnit
	{		
		public var sX:Number;
		public var sY:Number;
		public var eX:Number;
		public var eY:Number;
		
		
		public function toJSON(x:int=0,y:int=0):String{			
			return (sX-x)+","+(sY-y)+","+(eX-x)+","+(eY-y);			
		}		
	}
}