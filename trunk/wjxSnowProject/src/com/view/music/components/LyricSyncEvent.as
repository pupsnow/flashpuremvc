package  com.view.music.components
{
	import flash.events.*;
	
	public class LyricSyncEvent extends Event
	{
		public static const Sync:String = 'SYNC';
		public var timeState:LyricTimeState;
		public function LyricSyncEvent(eventType:String,state:LyricTimeState):void{
			super(eventType);
			this.timeState = state;
		}
	
	}
}