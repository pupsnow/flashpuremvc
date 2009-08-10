package  basecom.sjd.containers
{
	import mx.containers.TitleWindow;
	import flash.events.MouseEvent;
	import skins.*;
	import mx.controls.*;
	import mx.events.CloseEvent;
	import mx.core.Application;
	import com.universalmind.community.events.*;
	import mx.states.State;
	
	[Style(name="rollOver", type="string", inherit="yes")]
	[Style(name="plus", type="boolean", inherit="yes")]
	
	public class TitlePanelExtended extends mx.containers.TitleWindow
	{
		
		/**
		 * When the titlebar is clicked, the close
		 * event is dispatched so the pod manager (SpaceSharingContainer)
		 * knows how to lay out the pods based on their states.
		 */		
		[Event(name="close", type="mx.events.CloseEvent")]
		
		[Bindable] public var state:String;
		
		/**
		 *	Application instance used to register this class as a listener of ListEvents
		 */
		protected var application:Application = Application.application as Application;
					
		/**
		 * The list of entries that should be displayed
		 * inside of the pod.
		 */
		[Bindable] public var entries:Array;
		[Bindable] public var blogs:Array;
		
		/** Constant to be used for the minimized state */
		public static const MINIMIZED:String = "minimized";
		
		/** Constant to be used for the normal state */
		public static const NORMAL:String = "normal";

		/** Constant to be used for the expanded state */
		public static const EXPANDED:String = "expanded";
		
		public var min:State;
		public var nor:State;
		public var exp:State;
		
		/**
		 *	Register this component to listen all the ListEvents that happen in the
		 *	application.
		 */
		private function initComponent():void
		{
			application.addEventListener(ListEvent.LIST_CHANGED, onListChange);
		}
			
		/**
		 *	This function gets called every time that a ListEvent is dispatched in the application
		 *	In this case, we do nothing, it must be implemented in the subclass
		 */
		protected function onListChange(event:ListEvent):void
		{
			/** must be implemented on the subclass */
		}
			
		public function resize(event:MouseEvent):void 
		{			
			if (state == EXPANDED) 
				state = NORMAL;
			else
				state = EXPANDED;
	
			this.dispatchEvent(new CloseEvent(CloseEvent.CLOSE ));
		}
		
		public function TitlePanelExtended():void
		{
			super();
			
			this.setStyle("roundedBottomCorners", "true");
			this.setStyle("cornerRadius", "5");
			this.setStyle("borderThicknessBottom", "0"); 
			this.setStyle("borderThicknessLeft", "0"); 
			this.setStyle("borderThicknessRight", "0"); 
			this.setStyle("titleBackgroundSkin", TitleSkin);
			this.setStyle("shadowDistance", "1");
			this.setStyle("borderStyle", "solid");
			this.setStyle("borderColor", "0xBDBDBD");
			this.setStyle("borderThickness", "1");
			
			this.setStyle("paddingLeft", "0");
			this.setStyle("paddingRight", "0");
			this.setStyle("paddingTop", "0");
			this.setStyle("paddingBottom", "0");
			this.layout = "vertical";
			this.setStyle("verticalGap", "0");
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			
			min = new State();
			min.name = "minimized";
			this.states.push(min);
			
			nor = new State();
			nor.name = "normal";
			this.states.push(min);
			
			exp = new State();
			exp.name = "expanded";
			this.states.push(min);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			this.titleBar.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.titleBar.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.titleBar.addEventListener(MouseEvent.CLICK, resize);
			titleBar.useHandCursor = true;
			titleBar.buttonMode = true;
			titleBar.mouseEnabled = true;
			titleTextField.mouseEnabled = false;
		}
		
		public function updateRowHeight():void
		{
			
		}
		
		//sets row height for each list depending on what state it's in
		public function findRowHeight(list:List):void
		{
			var currentHeight:int;
			
			if(list.id == "bloggers") 
			{
				if(this.state == EXPANDED) 
				{
					list.rowHeight = 25;
				} 
				else {
					list.rowHeight = 24;
				}
				
			}
			else if (list.id == "posts")
			{
				list.rowHeight = 40;

			}
			else if (list.id == "articles")
			{
				if(this.state == EXPANDED) 
				{
					list.rowHeight = 33;
				} 
				else {
					list.rowHeight = 34;
				}
			}
			else
			{
				if(this.state == EXPANDED) 
				{
					list.rowHeight = 33;
				} 
				else {
					list.rowHeight = 34;
				}
			}
		}
		
		public function rollOutHandler(event:MouseEvent):void
		{			
			this.setStyle("rollState", "out");
			this.setStyle("titleBackgroundSkin", TitleSkin);
		}
		
		public function rollOverHandler(event:MouseEvent):void
		{
			this.setStyle("rollState", "over");
			this.setStyle("titleBackgroundSkin", TitleSkin);
		}
	}
}