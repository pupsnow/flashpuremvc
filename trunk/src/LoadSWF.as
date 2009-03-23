package
{
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import loadswf.LoadSwfManager;
	
	import org.puremvc.as3.demos.flex.login.model.DataSource;
	public class LoadSWF extends Sprite {
		public var data:DataSource;
		
		public function LoadSWF() {
			super();
			var btn:Button = new Button();
			btn.label = "aaa";
			btn.x = 100;
			btn.y = 100;
			btn.addEventListener(MouseEvent.CLICK,clickHandler);
			this.addChild(btn);
			this.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		}
		private function clickHandler(e:MouseEvent):void {
			data.testdata = "ceshi";
		}
		private function keyDownHandler(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
					trace("enter2");
					LoadSwfManager.getInstance().unloadSwf();
					LoadSwfManager.getInstance().loadSwf("movie.swf");
					break;
				case Keyboard.ESCAPE:
					LoadSwfManager.getInstance().unloadSwf();
					trace("out2");
					break;
					
				
			}
		}
	}
}