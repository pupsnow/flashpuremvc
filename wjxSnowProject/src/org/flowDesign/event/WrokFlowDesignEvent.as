package  org.flowDesign.event
{   
	import flash.events.Event;
	
	import org.flowDesign.data.LineData;
	import org.flowDesign.data.NodeData;
	public class WrokFlowDesignEvent extends Event
	{
		
		public static var nodeComplete:String="nodeCompleteEvent";
		public static var lineCpmplete:String="lineCpmplete";
		public static var nodeDel:String="nodeDel";
		public static var lineDel:String="lineDel";
		public static var nodeMove:String="nodeMove";
		public static var nodeProperty:String="nodeProperty";
		public static var lineProPerty:String="lineProPerty";
		public static var maxScroll:String="maxScroll";
        public var nodeData:NodeData;
        public var lineData:LineData;
        public var nodeId:String;
        public var lineId:String;
		public function WrokFlowDesignEvent(type:String)
    		{
            super(type);

      	 }

       public var Data:Object
		
	}
}