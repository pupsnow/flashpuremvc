package   com.view.map.eunite.util.draw
{
	
	import flash.display.Sprite;
	import mx.controls.Alert;
	
	public class DrawBatch
	{
		private var movestack:Array = new Array();
		public var color:uint;	
		public var thread:uint;
		
		public function DrawBatch(color:uint=0,thread:uint=1){
			this.color = color;
			this.thread = thread;		
		}
		
		public function length():uint{
			return movestack.length;
		}
		
		public function move(moveUnit:MoveUnit):void{
			if(moveUnit!=null){
				movestack.push(moveUnit);
			}
		}
		
		public function moveBy(sX:uint,sY:uint,eX:uint,eY:uint):void{		
			var moveUnit:MoveUnit = new MoveUnit();			
			moveUnit.sX = sX;
			moveUnit.sY = sY;
			moveUnit.eX = eX;
			moveUnit.eY = eY;
			movestack.push(moveUnit);
		}
		
		public function drawAll( target:Sprite, dx:int=0,dy:int=0 ):void{		
			target.graphics.lineStyle(thread, color);
						
			for(var i:int=0; i<movestack.length;i++){
				if(dx != 0 || dy != 0){
					movestack[i].sX += dx;
					movestack[i].sY += dy;
					movestack[i].eX += dx;
					movestack[i].eY += dy
				}
				target.graphics.moveTo(movestack[i].sX, movestack[i].sY);
	        	target.graphics.lineTo(movestack[i].eX, movestack[i].eY);
			}	        	           			            		        
		}
		
		public function drawLastStep( target:Sprite ):void{		
			target.graphics.lineStyle(thread, color);
			var i:uint = movestack.length;
			if(i>0){
				i=i-1;
				target.graphics.moveTo(movestack[i].sX, movestack[i].sY);
    	    	target.graphics.lineTo(movestack[i].eX, movestack[i].eY);
   			}
		}
		
		public function undo():void{
			movestack.pop();
		}		
		
		public function toJSON(x:int,y:int):String{
			var str:String = "{\"C\":\""+color.toString()+"\",\"T\":\""+thread.toString()+"\",\"M\":[";
			for(var i:int=0;i<movestack.length;i++){	
				if(i>0){
					str += ",";	
				}			
				str += movestack[i].toJSON(x,y);
			}
			str +="]}";
			return str;
		}
		
		public function fromJSON(obj:Object):void{
			color = obj.C;
			thread = obj.T;			
			for(var i:int=3;i<obj.M.length;i+=4){
				var moveUnit:MoveUnit = new MoveUnit();			
				moveUnit.sX = obj.M[i-3];
				moveUnit.sY = obj.M[i-2];
				moveUnit.eX = obj.M[i-1];
				moveUnit.eY = obj.M[i];
				movestack.push(moveUnit);
			}
			
		}
				
	}
}