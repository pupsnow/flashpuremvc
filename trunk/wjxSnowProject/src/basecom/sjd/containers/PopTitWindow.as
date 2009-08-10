package  basecom.sjd.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.LinkButton;
     [Event(name="minwindow")]	
	
	public class PopTitWindow extends PreResizeWindow
   {       private var minButton:LinkButton;
           // private var minresButton:LinkButton;
		[Embed("../assets/max.png")]
     	 private var minButtonUpIcon:Class;
     	//[Embed("../assets/maxdown.png")]
     	// private var minButtonDownIcon:Class;
		
		public function PopTitWindow()
		{	 
			super();
		}
		 protected override function createChildren():void
		 {
	       super.createChildren();
	       minButton=new  LinkButton();
	       //minresButton=new  LinkButton();
	       minButton.setStyle("upIcon",minButtonUpIcon);
	       minButton.addEventListener(MouseEvent.CLICK,doMin);
	      // minButton.dispatchEvent(new Event('minwindow'));
	      // minresButton.addEventListener(MouseEvent.CLICK,doTesdore);
	       minButton.visible=true;
	      // minresButton.visible=false;
	       this.rawChildren.addChild(minButton);
	       //this.rawChildren.addChild(minresButton);
	       	       
		 }
		 private function doMin(event:Event):void
		 {
		 	//this.width=0;
		 	//this.height=0;
		 
		 this.minButton.visible=false;
		 this.visible=false;
		 //最小化时设置其为不可见。
		 }		 
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
		 super.updateDisplayList(unscaledWidth, unscaledHeight);
		 var up:DisplayObject = btStateUp.getChildByName("upIcon");
	    var down:DisplayObject = btStateDown.getChildByName("upIcon");
	    var margin:int = 4; 
	    titleBar.doubleClickEnabled=true;   
	    minButton.setActualSize(up.width+margin, up.height+margin);
	   // btStateDown.setActualSize(up.width+margin, up.height+margin);
	    var pixelsFromTop:int = 1;
	    var pixelsFromRight:int = 10;
	    var buttonWidth:int=btStateUp.width;
	    var x:Number = unscaledWidth - buttonWidth - pixelsFromRight; 
	    var y:Number = pixelsFromTop;
	    minButton.move(x-32, y+5);	
		} 
	}
}