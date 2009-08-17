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
	 public function NodeEvent(type:String)
    	{
            super(type);

        }
       public var Data:Object

}
}