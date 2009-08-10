
package basecom.sjd.containers
{
import flash.events.Event;

public class ResizeWindowEvent extends Event
{
  public static var CLOSE:String="wfClose";
	 public function ResizeWindowEvent(type:String)
    {
            super(type);

       }

       public var Data:Object

}
}
