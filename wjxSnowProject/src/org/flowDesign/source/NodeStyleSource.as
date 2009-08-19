package  org.flowDesign.source
{
	public class NodeStyleSource{
		public static var defaultState:String="default";
		public static var complete:String="complete";
		public static var execute:String="execute";
		public static var noExecute:String="noExecute";
		
		[Embed(source="/org/flowDesign/images/general_links.png")]
		[Bindable]
		private var general_links:Class;
		
		[Embed(source="/org/flowDesign/images/line.png")]
		[Bindable]
		private var line:Class;
		
		[Embed(source="/org/flowDesign/images/machinery_links.png")]
		[Bindable]
		private var machinery_links:Class;
		
		
		[Embed(source="/org/flowDesign/images/parallel_links.png")]
		[Bindable]
		private var parallel_links:Class;
		
		
		[Embed(source="/org/flowDesign/images/sub_workflow.png")]
		[Bindable]
		private var sub_workflow:Class;
		
		
		[Embed(source="/org/flowDesign/images/v_Broken_line.png")]
		[Bindable]
		private var v_Broken_line:Class;
		
		[Embed(source="/org/flowDesign/images/h_Broken_line.png")]
		[Bindable]
		private var h_Broken_line:Class;
		
		[Embed("/org/flowDesign/images/start.png")]
			[Bindable]
			public var start:Class;
			
			[Embed("/org/flowDesign/images/end.png")]
			[Bindable]
			public var end:Class;
			
			[Embed("/org/flowDesign/images/line.png")]
			[Bindable]
			public var node:Class;
			
			[Embed("/org/flowDesign/images/transition.gif")]
			[Bindable]
			public var transition:Class;
			
			
			[Embed("/org/flowDesign/images/drag.png")]
			[Bindable]
			public var movebutton:Class;
			
			[Embed("/org/flowDesign/images/machinery_links.png")]
			[Bindable]
			public var automatism:Class;
			
			[Embed("/org/flowDesign/images/general_links.png")]
			[Bindable]
			public var manual:Class;
			
			[Embed("/org/flowDesign/images/sub_workflow.png")]
			[Bindable]
			public var child:Class;
			
			[Embed("/org/flowDesign/images/curveLine.png")]
			[Bindable]
			public var curveLine:Class;
			
		private static var Instance:NodeStyleSource;
		public static function getInstace():NodeStyleSource
		{
			if(Instance==null) Instance = new NodeStyleSource();
			return Instance;
		}
		public function getIcon(value:String):Class
		{
			return this[value] as Class;
		}
	}
}