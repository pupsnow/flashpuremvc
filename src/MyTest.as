package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import loadswf.LoadSwfManager;
	
	import org.puremvc.as3.demos.flex.login.ApplicationFacade;
	public class MyTest extends Sprite
	{
		public var facade:ApplicationFacade = ApplicationFacade.getInstance();
		public var loadManager:LoadSwfManager = LoadSwfManager.getInstance();
		public function MyTest()
		{
			super();
			loadManager.mainswf = this;
			facade.startUp(this);
			this.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
//			var url:URLRequest = new URLRequest("loadswf.swf");
//			var urll:Loader= new Loader();
//				urll.x = 200;
//				urll.y = 200;
//				urll.load(url);
//			this.addChild(urll);
//			urll.contentLoaderInfo.addEventListener(Event.COMPLETE,initHandler);
		}
		
		private function initHandler(e:Event):void
		{
			
//			var mov:LoadSWF = e.target.content;
//			trace(e.target);
//			mov.data = DataSource.getInstance();
//			facade.registerMediator(new LoadSwfMediate(mov));
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
					trace("enter0")
					loadManager.loadSwf("loadswf.swf");
					this.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
					break;
//				case Keyboard.ESCAPE:
//					loadManager.unloadSwf();
//					trace("out");
//					break;
					
				
			}
		}
	}
}