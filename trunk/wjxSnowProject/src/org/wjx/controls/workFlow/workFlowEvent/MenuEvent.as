package org.wjx.controls.workFlow.workFlowEvent
{
	import flash.events.Event;
	
	public class MenuEvent extends Event
	{
		public static var menuClick:String="menuClick";
 		public var menuType:String;
		public function MenuEvent(type:String)
    		{	
    		super(type);		
    		
            }

      // public var Data:Object
	}
}