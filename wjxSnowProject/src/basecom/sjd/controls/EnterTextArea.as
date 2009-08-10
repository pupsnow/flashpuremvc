package  basecom.sjd.controls
{   /* 为TextArea提供设置一个新的enter事件.
     主要用在弹出窗口的快捷键中.
      */
	import flash.ui.Keyboard;
	import mx.events.FlexEvent;
	import flash.events.KeyboardEvent;
	import mx.controls.TextArea;
     [Event(name="enter", type="mx.events.FlexEvent")]
	public class EnterTextArea extends TextArea
	{
		
		public function EnterTextArea(){
			super()
		}
		override protected function keyDownHandler(event:KeyboardEvent):void
    {
        switch (event.keyCode)
        {
            case Keyboard.ENTER:
            {
                dispatchEvent(new FlexEvent(FlexEvent.ENTER));
                break;
            }
        }
    }
	}
}