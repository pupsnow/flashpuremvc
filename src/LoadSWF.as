package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import fl.controls.Button;
	import flash.events.MouseEvent;
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
		}
		private function clickHandler(e:MouseEvent):void {
			data.testdata = "ceshi";
		}
	}
}