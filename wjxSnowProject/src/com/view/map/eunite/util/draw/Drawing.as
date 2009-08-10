package  com.view.map.eunite.util.draw
{
	import mx.collections.ArrayCollection;
	//import com.adobe.serialization.json.JSON;
	import flash.display.Sprite;
	import mx.controls.Text;
	import mx.controls.SWFLoader;
	import flash.events.IOErrorEvent;
	import mx.containers.Canvas;
		
	[Bindable]
	public class Drawing
	{
		public var drawStack:ArrayCollection = new ArrayCollection();
		public var textArray:ArrayCollection= new ArrayCollection();
		public var picArray:ArrayCollection= new ArrayCollection();
			
		public function Drawing(drawing:String = null)
		{
			if(drawing!=null)
			{
				fromJSON(drawing);
			}			
		}	
		
		public function fromJSON(drawing:String):void{
			//Alert.show("Obj:"+drawing);		
		/* 	var obj:Object = JSON.decode(drawing);			
			if(obj.D!=null){
				for(var i:int=0;i<obj.D.length;i++){
					var drawBatch:DrawBatch = new DrawBatch();
					drawBatch.fromJSON(obj.D[i]);
					drawStack.addItem(drawBatch);
				}
			}
			if(obj.T!=null){
				for(var j:int=0;j<obj.T.length;j++){
					var text:Text = new Text();
					text.setStyle("fontSize", obj.T[j].F);
					text.setStyle("color",obj.T[j].C);
					text.x = obj.T[j].X;
					text.y = obj.T[j].Y;										
					text.text = unescape(obj.T[j].T);
					textArray.addItem(text);				
				}
			}
			if(obj.I!=null){
				for(var k:int=0;k<obj.I.length;k++){
					var img:SWFLoader = new SWFLoader();										
					img.x = obj.I[k].X;
					img.y = obj.I[k].Y;
					img.maxHeight = 400;
					img.maxWidth = 400;					
					img.source = unescape(obj.I[k].U);
				    picArray.addItem(img);				
				}
			} */
		}
		
		public function toJSON(x:int,y:int):String{
			var empty:Boolean = true;
	   		var str:String = "{";
	   		if(drawStack.length>0){
	   			str+="\"D\":[";
	   			for(var i:int=0;i < drawStack.length; i++){
	   				if(i>0){
						str += ",";
					}
					str += drawStack[i].toJSON(x,y);	
	   			}
	   			str+="]";
	   			empty=false;
	   		}
	   		if(textArray.length > 0){
	   			if(!empty){
	   				str+=",";
	   			}
	   			str += "\"T\":[";
	   			for(i=0;i < textArray.length; i++){
	   				if(i>0){
						str += ",";
					}
					str += "{\"C\":\""+textArray[i].getStyle("color")
			      	+"\",\"F\":\""+textArray[i].getStyle("fontSize")
			      	+"\",\"T\":\""+escape(textArray[i].text)
			      	+"\",\"X\":\""+(textArray[i].x-x)			      
			      	+"\",\"Y\":\""+(textArray[i].y-y)+"\"}";	
	   			}
	   			str+="]";
	   			empty=false;
	   		}
	   		if(picArray.length > 0){
	   			if(!empty){
	   				str+=",";
	   			}
	   			str += "\"I\":[";
	   			for(i=0;i < picArray.length; i++){
	   				if(i>0){
						str += ",";
					}
					str += "{\"U\":\""+escape(picArray[i].source)
				  	+"\",\"X\":\""+(picArray[i].x-x)			      
			      	+"\",\"Y\":\""+(picArray[i].y-y)+"\"}";		
	   			}
	   			str+="]";
	   			empty=false;
	   		}
	   		str += "}";     	
	    	return str;
    	}	
				
		public function drawAll( target:Canvas,x:int,y:int):void{    		  
    		target.removeAllChildren();
    		for(var i:int=0;i<drawStack.length;i++){
    			drawStack[i].drawAll(target,x,y);	    		
    		}
    		for(var j:int=0;j< textArray.length;j++){
    			textArray.getItemAt(j).x +=x;
    			textArray.getItemAt(j).y +=y;
				target.addChild(textArray[j]);    			
    		}    		
    		for(var k:int=0;k< picArray.length;k++){
   				picArray.getItemAt(k).x +=x; 
    			picArray.getItemAt(k).y +=y;
    			target.addChild(picArray[k]);    			
    		}
    		
    	}
    	public function redraw(target:Sprite,dx:int=0,dy:int=0):void{
    		target.graphics.clear();    	    	
    		for(var i:int=0;i<drawStack.length;i++){
    			drawStack[i].drawAll(target,dx,dy);	
    		}    	
    		for(var j:int=0;j< textArray.length;j++){
    			textArray.getItemAt(j).x +=dx;
    			textArray.getItemAt(j).y +=dy;
    		}
    		for(var k:int=0;k< picArray.length;k++){
   				picArray.getItemAt(k).x +=dx; 
    			picArray.getItemAt(k).y +=dy;
    		}
    	}
    	
    	public function cleanAll(target:Sprite):void{
    		target.graphics.clear(); 
    		while(target.numChildren>0){
    			target.removeChildAt(target.numChildren-1);
    		}
    	}
	
	}
	
}