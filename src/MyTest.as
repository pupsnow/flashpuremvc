package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.demos.flex.login.ApplicationFacade;
	import org.puremvc.as3.demos.flex.login.model.DataSource;
	import org.puremvc.as3.demos.flex.login.view.LoadSwfMediate;
	public class MyTest extends Sprite
	{
		public var facade:ApplicationFacade = ApplicationFacade.getInstance();
		public function MyTest()
		{
			super();
			facade.startUp(this);
			var url:URLRequest = new URLRequest("loadswf.swf");
			var urll:Loader= new Loader();
				urll.x = 200;
				urll.y = 200;
				urll.load(url);
			this.addChild(urll);
			urll.contentLoaderInfo.addEventListener(Event.COMPLETE,initHandler);
		}
		
		private function initHandler(e:Event):void
		{
			
			//var mov:LoadSWF = e.target.content;
			//trace(e.target);
			//mov.data = DataSource.getInstance();
			//facade.registerMediator(new LoadSwfMediate(mov));
		}
	}
}