
package   com.view.map.components.controls
{
	import com.view.map.components.events.ImageMapEvent;
	import flash.display.Graphics;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.*;
	import flash.utils.Timer;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.Glow;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;
	
	/**
	 *  Thickness of the outline of each area.
	 *  
	 *  @default 1
	 */
	[Style(name="outlineThickness", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Color of the outline of each area.
	 *  
	 *  @default 0xff0000
	 */
	[Style(name="outlineColor", type="uint", format="Color", inherit="no")]
	
	/**
	 *  Alpha transparency of the outline of each area. Default is 0 so the outlines are invisible.
	 *  
	 *  @default 0
	 */
	[Style(name="outlineAlpha", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Fill color of each area.
	 *  
	 *  @default 0xff0000
	 */
	[Style(name="fillColor", type="uint", format="Color", inherit="no")]
	
	/**
	 *  Alpha transparency of the fill of each area. Default is 0 so the areas are invisible.
	 *  
	 *  @default 0
	 */
	[Style(name="fillAlpha", type="Number", format="Length", inherit="no")]
	
	/**
	 * Fired when an area is clicked.
	 * 
	 * @eventType flexlib.events.ImageMapEvent.SHAPE_CLICK
	 */
	[Event(name="shapeClick", type="com.view.map.components.events.ImageMapEvent")]
	
	/**
	 * Fired when an area is double clicked.
	 * 
	 * @eventType flexlib.events.ImageMapEvent.SHAPE_DOUBLECLICK
	 */
	[Event(name="shapeDoubleClick", type="com.view.map.components.events.ImageMapEvent")]
	
	/**
	 * Fired when the mouse moves over an area.
	 * 
	 * @eventType flexlib.events.ImageMapEvent.SHAPE_OVER
	 */
	[Event(name="shapeOver", type="com.view.map.components.events.ImageMapEvent")]
	
	/**
	 * Fired when the mouse moves out of an area.
	 * 
	 * @eventType flexlib.events.ImageMapEvent.SHAPE_OUT
	 */
	[Event(name="shapeOut", type="com.view.map.components.events.ImageMapEvent")]
	
	/**
	 * Fired when the mouse is pressed down on an area.
	 * 
	 * @eventType flexlib.events.ImageMapEvent.SHAPE_DOWN
	 */
	[Event(name="shapeDown", type="com.view.map.components.events.ImageMapEvent")]
	
	/**
	 * Fired when the mouse is released on an area.
	 * 
	 * @eventType flexlib.events.ImageMapEvent.SHAPE_UP
	 */
	[Event(name="shapeUp", type="com.view.map.components.events.ImageMapEvent")]
	
	/**
	 * Fired when the mouse is released on an area.
	 * 
	 * @eventType flexlib.events.ImageMapEvent.SHAPE_UP
	 */
	[Event(name="shapeContextmenuOpen", type="com.view.map.components.events.ImageMapEvent")]
	
	[Event(name="shapeContextmenuNet", type="com.view.map.components.events.ImageMapEvent")]
	[IconFile("ImageMap.png")]

	public class ImageMap extends Image
	{
		/**
		 * @private
		 * The array of area object that specifies all the areas we are going to draw.
		 */
		private var _map:Array;
		
		/**
		 * @private
		 * The UIComponent that holds all the shapes we'll be drawing.
		 */
		private var areaHolder:UIComponent;
		
		/**
		 * Indicates whether tool tips should be shown for each area.
		 * 
		 * @default false
		 */
		public var showToolTips:Boolean = false;
		
		/**
		 * Field of the <code>&lt;area /&gt;</code> item that will be used for the tooltip.
		 * @default "alt"
		 */
		public var toolTipField:String = "alt";
				
		/**
		 * @private
		 * 
		 * We initialize the default styles for outline and fill styles by calling
		 * initStyles() when the component is instantiated.
		 */
		private static var stylesInitialised:Boolean = initStyles();

         private  var areaeffect:Glow=new Glow();  
		 private var areaouteffect:Glow=new Glow();

        private var mark:Image;
		/**
		 * @private
		 * 
		 * The default styes are defined here.
		 */
		private static function initStyles():Boolean {
			var sd:CSSStyleDeclaration =
			StyleManager.getStyleDeclaration("ImageMap");
		 
			if (!sd)
			{
				sd = new CSSStyleDeclaration();
				StyleManager.setStyleDeclaration("ImageMap", sd, false);
			}
		
			sd.defaultFactory = function():void
			{
				this.outlineColor = 0xff0000;
				this.outlineAlpha = 1;
				this.outlineThickness = 1;
				this.fillColor = 0xff0000;
				this.fillAlpha = 0;
			}
			return true;
		}
		/** 
		 * new mark,for seach the diffence place 
		 *  **/
		override protected function createChildren():void {
			super.createChildren();
			mark=new  Image();
			mark.source="images/target.swf";
			/* mark.width=30;
			mark.height=30; */
			//var markimage=new Image();
			/* var cent:Sprite=new Sprite();
			var g:Graphics=cent.graphics;
			g.beginFill(0x000000,1);
			g.drawRect(0,0,20,20);
			g.endFill();
			 */
			//mark.addChild(cent);
			this.addChild(mark);
			areaHolder = new UIComponent();
			this.addChild(areaHolder);
		}
		
		
		/**
		 * The <code>&lt;map /&gt;</code> HTML block that is normally used for the image map in an HTML file.
		 * This should be wrapped as an XMLList and can either be cuopy/pasted straight into the MXML
		 * file, or set via Actionscript. 
		 */
		public function set map(value:Array):void {
			_map = value;
			
			invalidateDisplayList();
		}
		
		/**
		 * @private
		 */
		public function get map():Array {
			return _map;
		}
		
		/**
		 * @private
		 * 
		 * Draws each of the areas as a UIComponent.UIComponent is used (as opposed to Sprite) so we
		 * can get the useHandCursor and toolTip functionality. Each shape is drawn and
		 * added to the areaHolder component. 
		 */
		   private var open: ContextMenuItem = new ContextMenuItem("打开");
		   private var net:ContextMenuItem=new ContextMenuItem("公司网站");
		   private var areaContextMenu : ContextMenu = new ContextMenu();
		   private function drawShapes():void {
			 removeChildren();
			
			var outlineThickness:Number = getStyle("outlineThickness");
			var outlineColor:uint = getStyle("outlineColor");
			var outlineAlpha:Number = getStyle("outlineAlpha");
			var fillColor:uint = getStyle("fillColor");
			var fillAlpha:Number = getStyle("fillAlpha");			
			for each(var item:Area in _map) {
				
				var shape:String = item.shape;
				//we split up the coordinates into an Array. The coords are in the format 23,56,34,57,89,...
				var coords:Array = item.coords.split(",");	
							
				var sprite:UIComponent = new UIComponent();	
				sprite.addEventListener(MouseEvent.CLICK, sprite_clickHandler, false, 0, true);
				sprite.addEventListener(MouseEvent.DOUBLE_CLICK, sprite_dblclickHandler, false, 0, true);
				sprite.addEventListener(MouseEvent.MOUSE_DOWN, sprite_downHandler, false, 0, true);
				sprite.addEventListener(MouseEvent.MOUSE_OUT, sprite_outHandler, false, 0, true);
				sprite.addEventListener(MouseEvent.MOUSE_OVER, sprite_overHandler, false, 0, true);
				sprite.addEventListener(MouseEvent.MOUSE_UP, sprite_upHandler, false, 0, true);
						 /**
						   * 下面 实现各个不同区域的右键功能，并触发相应的事件。
						 * */
				 areaContextMenu.hideBuiltInItems();
			     var defaultItems:ContextMenuBuiltInItems = areaContextMenu.builtInItems;
			     defaultItems.print = true; 
			     open.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,sprite_contextmenuopenHandler);//设置右键打开触发的事件
				 areaContextMenu.customItems.push(open); 
				 areaContextMenu.customItems.push(net);  
				 net.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,sprite_contextmenunetHandler);	 	
				 sprite.contextMenu = areaContextMenu; 	
				//sprite.addEventListener(				
				sprite.useHandCursor = this.useHandCursor;
				sprite.buttonMode = true;
				//trace(this.screen.width);
				if(showToolTips) {
					sprite.toolTip = item[toolTipField];				
				}	
				var g:Graphics = sprite.graphics;
				g.lineStyle(outlineThickness, outlineColor, outlineAlpha);
				g.beginFill(fillColor, fillAlpha);
				
				
				switch(shape.toLowerCase()) {
					case "rect"://方形
						g.drawRect(coords[0], coords[1], coords[2] - coords[0], coords[3] - coords[1]);
						break;
					case "poly":
						drawPoly(g, coords);//画多边形
						break;
					case "circle":
						g.drawCircle(coords[0], coords[1], coords[2]);
						break;
				}//设置不同的区域.
				
				g.endFill();
				
				areaHolder.addChild(sprite);				
			}
		}		
		/**
		 * After we finish drawing we make sure that the areaHolder is on top of our loaded image. 
		 * If we don't have the call to setChildIndex then the shapes will all be under the image.
		 * 
		 * We set the x and y scale of the areaHolder to match the content, since we might be
		 * scaling the content to fit the size of this Image component. We also implement the clipping
		 * of the shapes by using the content's scrollRect boundaries.
		 */
		
		 
		 override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			mark.setActualSize(50,50);			
			if(contentHolder) {
				areaHolder.scaleX = contentHolder.scaleX;
				areaHolder.scaleY = contentHolder.scaleY;
				areaHolder.scrollRect = contentHolder.scrollRect;
			}
			
			drawShapes();
			
			//without this the shapes would get stuck underneath the main loaded content
			setChildIndex(areaHolder, numChildren - 1);
		}
		
		/**
		 * @private
		 * Simple utility function to draw a polygon from an array of points.
		 * 多边形的绘制
		 */
		private function drawPoly(g:Graphics, coords:Array):void {	
			g.moveTo(coords[0], coords[1]);
		//绘制点放在moveTo，绘制一条到lineTo的直线。
			//since we moved to the first point, we loop over all points starting on the second point	
			for(var i:int=2; i<coords.length; i+=2) {
				g.lineTo(coords[i], coords[i+1]);
			}
			
			//got to remember to reconnect from the last point to the first point
			g.lineTo(coords[0], coords[1]);
		}
		
		/**
		 * @private
		 * I don't know why UIComponent doesn't have a removeAllChildren() method, but this
		 * method just does that, removes all children of the areaHolder.
		 */
		private function removeChildren():void {
			while(areaHolder.numChildren > 0) {
				areaHolder.removeChildAt(0);
			}
		}
		
		
		
		/**
		 * @private
		 * We're basically re-creating the functionality of all the mouse events. But we need
		 * to dispatch our custom ImageMapEvent so we can pass back the link information as well
		 * as the basic mouse event info. So I've recreated the click, double-click, down, up, over,
		 * and out mouse events.
		 */
		private function sprite_clickHandler(event:MouseEvent):void {
			 var sprite:UIComponent = event.currentTarget as UIComponent;
			doDispatchEvent(sprite, ImageMapEvent.SHAPE_CLICK); 
			/* var mycomputer=new(eventtarget.target_name)(); */
			
		}
		
		/**
		 * @private
		 */
		private function sprite_dblclickHandler(event:MouseEvent):void {
			var sprite:UIComponent = event.currentTarget as UIComponent;
			doDispatchEvent(sprite, ImageMapEvent.SHAPE_DOUBLECLICK);
		}
		
		/**
		 * @private
		 */
		private function sprite_downHandler(event:MouseEvent):void {
			var sprite:UIComponent = event.currentTarget as UIComponent;
			doDispatchEvent(sprite, ImageMapEvent.SHAPE_DOWN);
		}
		
		/**
		 * @private
		 */
		private function sprite_upHandler(event:MouseEvent):void {
			var sprite:UIComponent = event.currentTarget as UIComponent;
			doDispatchEvent(sprite, ImageMapEvent.SHAPE_UP);
		}
		
		/**
		 * @private  ues timer for the glow effect .when the mouse over the sprite  timer start,and then 
		 * glow begin and repeated in 400s.
		 * when the mouse out timer stop ,glow stop /
		 */
		private var timer:Timer=new Timer(400);
		private var timerstop:Timer=new Timer(400,1);
		private function sprite_overHandler(event:MouseEvent):void {		
			var sprite:UIComponent = event.currentTarget as UIComponent;		
			doDispatchEvent(sprite, ImageMapEvent.SHAPE_OVER);
			sprite.setStyle("outlineAlpha",1.0);
			areaeffect.target=sprite;			
		 	timer.addEventListener(TimerEvent.TIMER,areaovereffectHandler);
 			timer.start();
		}
		/**
		 * @private  sprite_outHandler
		 */
		private function sprite_outHandler(event:MouseEvent):void {
			var sprite:UIComponent = event.currentTarget as UIComponent;
			doDispatchEvent(sprite, ImageMapEvent.SHAPE_OUT);		
			timer.stop();
			timerstop.addEventListener(TimerEvent.TIMER,areaouteffectHandler);
			timerstop.start();
		  //停止时间的同时需要移除发光的效果-------------------------------------------------	
			
		}
		/**
		 * @private   ContextMenu Event open
		 */
		private function sprite_contextmenuopenHandler(event:ContextMenuEvent):void{
		
			trace(event.mouseTarget.name);
			var sprite:UIComponent = event.mouseTarget as UIComponent;
				doDispatchEvent(sprite, ImageMapEvent.SHAPE_CONTEXTMENUOPEN);
		     
		}
		/**
		 * @private   ContextMenu Event net
		 */
        private function sprite_contextmenunetHandler(event:ContextMenuEvent):void{
        	var sprite:UIComponent = event.mouseTarget as UIComponent;
				doDispatchEvent(sprite, ImageMapEvent.SHAPE_CONTEXTMENUNET);
		     
        }
		
		/**
		 * mark  move 标记。
		 * ==============================================================================
		 **/
		 
		 public function MarkMove(x:Number,y:Number):void
		 {		 	
		 	mark.move(x,y);
		 
		 }
	 
		 /**============================================================================*/
		
		/** 
		 * effect  for diffent  area,
		 * use timer for
		 * repect glow
		 * **/
		 private function areaovereffectHandler(event:TimerEvent):void{	 
		 	     areaeffect.alphaFrom=1.0;
				 areaeffect.alphaTo=.3;
				 areaeffect.blurXFrom=0;
				 areaeffect.blurXTo=60; 
				 areaeffect.blurYFrom=0;
				 areaeffect.blurYTo=60;
				 areaeffect.color=0xFFFFFF;
				 areaeffect.end();
				 areaeffect.play();
		 }
		  private function areaouteffectHandler(event:TimerEvent):void{
		  	     areaouteffect.duration=1000;
		 	     areaouteffect.alphaFrom=1.0;
				 areaouteffect.alphaTo=.0;
				 areaouteffect.blurXFrom=60;
				 areaouteffect.blurXTo=0; 
				 areaouteffect.blurYFrom=60;
				 areaouteffect.blurYTo=0;
				 areaouteffect.color=0xFFFFFF;
				 areaeffect.end();
				 areaeffect.play();
		 }
		/**
		 * @private
		 * This lets us dispatch one of these ImageMapEvents. Basically we need to figure
		 * out which shape was clicked, and when we dispatch the event we reference the href link
		 * for that shape, and we also pass back the entire XML item for that shape. This is because
		 * someone might want to use this component for something other than the standard image map linking
		 * scenario. Passing back the XML item should give maximum flexibility.
		 */
		private function doDispatchEvent(sprite:UIComponent, type:String):void {
			
			if(sprite.parent != areaHolder) return;
			
			var index:int = areaHolder.getChildIndex(sprite);
			var item:Area = _map[index];
			
			var target:String = "";
			if(item.target_num) {
				target = item.target;
			}
			var target_name:Class=null;
			if(item.target_name)
			{
				target_name=item.target_name;
			
			}
			var href:String = "";
			if(item.href) {
				href = item.href;
			}
			var open:String="";
			if(item.open) {
				href = item.open;
			}
			var net:String="";
			if(item.net) {
				href = item.net;
			}
			dispatchEvent(new ImageMapEvent(type, false, false,
			 href, item, target,target_name,open,net));	
		}
	}
}
