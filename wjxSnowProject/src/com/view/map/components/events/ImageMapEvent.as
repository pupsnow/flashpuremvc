

package   com.view.map.components.events
{
	import  com.view.map.components.controls.Area
	
	import flash.events.Event;

	/**
	 * An <code>ImageMapEvent</code> is like a generic Event, but we add the <code>href</code>, 
	 * <code>alt</code>, and <code>linkTarget</code> properties and so
	 * on.
	 */
	public class ImageMapEvent extends Event
	{
		/** *
		 *  mouseEvent
		 * */
		public static const SHAPE_CLICK:String = "shapeClick";
		public static const SHAPE_DOUBLECLICK:String = "shapeDoubleClick";	
		public static const SHAPE_OVER:String = "shapeOver";
		public static const SHAPE_OUT:String = "shapeOut";
		public static const SHAPE_DOWN:String = "shapeDown";
		public static const SHAPE_UP:String = "shapeUp";
		/** 
		 * rightMenuEvent
		 * **/
		 public static const SHAPE_CONTEXTMENUOPEN:String= "shapeContextmenuOpen";
		 public static const SHAPE_CONTEXTMENUABOUT:String= "shapeContextmenuAbout";
		 public static const SHAPE_CONTEXTMENUNET:String="shapeContextmenuNet";
		 
		
	
		public var href:String;
		public var item:Area;
		public var linkTarget:String;
		public var target_name:Class;
		public var open:String;
		public var net:String;
		
		public function ImageMapEvent(type:String, bubbles:Boolean = false,
									  cancelable:Boolean = false,
									  href:String=null, item:Area=null,
									  target:String=null,target_name:Class=null,
									  open:String=null,net:String=null) 
		{
			/**
			 * cancelable 属性来检查是否可以阻止任何指定事件对象的默认行为，
			 * 您可以使用 preventDefault() 方法阻止或取消与少量事件关联的默认行为
			 * bubbles 属性包含有关事件流中事件对象参与的部分的信息。
			 * Event.bubbles 属性存储一个布尔值，用于指示事件对象是否参与冒泡阶段。
			 * 由于冒泡的所有事件还参与捕获和目标阶段，因此这些事件参与事件流的所有三个阶段。
			 * 如果值为 true，则事件对象参与所有三个阶段。如果值为 false，则事件对象不参与冒泡阶段。
			 * 
			 * eventPhase 属性指示事件流中的当前阶段。  */
			super(type, bubbles, cancelable);
			this.href = href;
			this.item = item;
			this.linkTarget = target;  
			this.target_name=target_name;
			this.open=open;
			this.net=net;
		}
		
	}
}