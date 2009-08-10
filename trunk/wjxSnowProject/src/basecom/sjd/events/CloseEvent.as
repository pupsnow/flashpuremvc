package  basecom.sjd.events
{
	import flash.events.Event;

	public class CloseEvent extends Event
	{
		[Bindable]
		public var index:int;
		[Bindable]
		public var name_str:String;
		public function CloseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}