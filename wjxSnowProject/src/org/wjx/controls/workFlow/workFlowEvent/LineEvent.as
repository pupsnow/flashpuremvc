
package  org.wjx.controls.workFlow.workFlowEvent
{
import flash.events.Event;

public class LineEvent extends Event
{
  public static var rightClick:String="lineRightClick";
  public static var propertyClick:String="linePropertyClick";
  public static var deleteClick:String="lineDeleteClick";
	 public function LineEvent(type:String)
    {
            super(type);

       }

       public var Data:Object

}
}