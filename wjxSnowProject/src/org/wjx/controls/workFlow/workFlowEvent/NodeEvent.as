
package org.wjx.controls.workFlow.workFlowEvent
{
import flash.events.Event;

public class NodeEvent extends Event
{
  public static var rightClick:String="mouseRightClick";
  public static var propertyClick:String="nodePropertyClick";
  public static var deleteClick:String="nodeDeleteClick";
 public static var nodeStartDrage:String="nodeStartDrage";
	public static var nodeStopDrage:String="nodeStopDrage";
	 public function NodeEvent(type:String)
    {
            super(type);

       }

       public var Data:Object

}
}