package
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class MyBt extends SimpleButton
	{
		public function MyBt()
		{
			super();
			this.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		private var i:int = 0;
		private function clickHandler(e:MouseEvent):void
		{
		}
	}
}