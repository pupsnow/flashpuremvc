package org.flowDesign.event
{
import flash.events.Event;

public class NodeEvent extends Event
{
	  public static var RIGHT_CLICK:String="mouseRightClick";
	  public static var PROPERTY_CLICK:String="nodePropertyClick";
	  public static var DELETE_CLICK:String="nodeDeleteClick";
	  public static var NODESTART_DRAGE:String="nodeStartDrage";
	  public static var NODESTOP_DRAGE:String="nodeStopDrage";
	
	  public static var SETCURRENT_CLICK:String="setcurrent_click";
	  public static var COMPLETECURRENT_CLICK:String="completecurrent_click";
	  public static var PASSCURRENT_CLICK:String="passcurrent_click";
	
	 public function NodeEvent(type:String)
    	{
            super(type);

        }
       public var Data:Object

}
}