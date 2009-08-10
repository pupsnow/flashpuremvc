package org.wjx.controls.workFlow.workFlowClasses
{
	import mx.controls.Label;
	import mx.events.ResizeEvent;
	public class LineLabel extends Label
	{  
		public function LineLabel(){
			this.addEventListener(ResizeEvent.RESIZE,lineNameResize);
		}
		
		private var _middleX:int;
		public function set middleX(value:int):void{
			this._middleX=value;
		}
		public function get middleX():int{
			return this._middleX;
		}
		
		private var _middleY:int;
		public function set middleY(value:int):void{
			this._middleY=value;
		}
		public function get middleY():int{
			return this._middleY;
		}
		
		public function lineNameResize(event:ResizeEvent):void{
			refashXY();
		}
		public function refashXY():void{
			this.x=this.middleX-(this.width/2);
			this.y=this.middleY-(this.height/2);
				
		}
	}
}