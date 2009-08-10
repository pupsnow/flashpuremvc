package basecom.sjd.containers
{
	import mx.containers.Panel;
	import mx.core.UIComponent;
	import mx.core.SpriteAsset;
	import mx.events.FlexEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import mx.containers.TitleWindow;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import mx.events.FlexEvent;
	import mx.controls.Button;
	import mx.containers.TitleWindow;
	import mx.core.Application;
	import basecom.sjd.utils.Constant;
	import basecom.sjd.utils.CursorUtils;

	public class DragTitleWindow extends TitleWindow
	
	{
		
		private static var resizeObj:Object;
		private static var mouseState:Number = 0;
		private static var mouseMargin:Number = 10;

		
		private var oWidth:Number = 0;
		private var oHeight:Number = 0;
		private var oX:Number = 0;
		private var oY:Number = 0;
		private var oPoint:Point = new Point();
		
		private var _showWindowButtons:Boolean = false;
		private var _windowMinSize:Number = 50;
		// Add the creationCOmplete event handler.
		public function DragTitleWindow()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
				
			this.addEventListener(MouseEvent.MOUSE_MOVE, oMouseMove);
			this.addEventListener(MouseEvent.MOUSE_OUT, oMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, oMouseDown);
			//this.addEventListener(MouseEvent.MOUSE_UP, oMouseUp);
			//this.addEventListener(FlexEvent.CREATION_COMPLETE, addButton);
			
			//Application.application.parent:SystemManager
			Application.application.parent.addEventListener(MouseEvent.MOUSE_UP, oMouseUp);
			Application.application.parent.addEventListener(MouseEvent.MOUSE_MOVE, oResize);
		}
		
		// Expose the title bar property for draggin and dropping.
		[Bindable]
		public var myTitleBar:UIComponent;
		
		
		
		
		//
		//
		//
		private static function initPosition(obj:Object):void{
			obj.oHeight = obj.height;
			obj.oWidth = obj.width;
			obj.oX = obj.x;
			obj.oY = obj.y;
		}
			private function oMouseDown(event:MouseEvent):void{
			if(mouseState != Constant.SIDE_OTHER){
				resizeObj = event.currentTarget;
				initPosition(resizeObj);
				oPoint.x = resizeObj.mouseX;
				oPoint.y = resizeObj.mouseY;
				oPoint = this.localToGlobal(oPoint);
			}
		}
		
		/**
		 * Clear the resizeObj and also set the latest position.
		 * @param The MouseEvent.MOUSE_UP
		 */
		private function oMouseUp(event:MouseEvent):void{
			if(resizeObj != null){
				initPosition(resizeObj);
			}
			resizeObj = null;
		}
		
		/**
		 * Show the mouse arrow when not draging.
		 * Call oResize(event) to resize window when mouse is inside the window area.
		 * @param The MouseEvent.MOUSE_MOVE
		 */
		private function oMouseMove(event:MouseEvent):void{
			if(resizeObj == null){
				var xPosition:Number = Application.application.parent.mouseX;
				var yPosition:Number = Application.application.parent.mouseY;
				if(xPosition >= (this.x + this.width - mouseMargin) && yPosition >= (this.y + this.height - mouseMargin)){
					CursorUtils.changeCursor(Constant.LEFT_OBLIQUE_SIZE, -6, -6);
					mouseState = Constant.SIDE_RIGHT | Constant.SIDE_BOTTOM;
				}else if(xPosition <= (this.x + mouseMargin) && yPosition <= (this.y + mouseMargin)){
					CursorUtils.changeCursor(Constant.LEFT_OBLIQUE_SIZE, -6, -6);
					mouseState = Constant.SIDE_LEFT | Constant.SIDE_TOP;
				}else if(xPosition <= (this.x + mouseMargin) && yPosition >= (this.y + this.height - mouseMargin)){
					CursorUtils.changeCursor(Constant.RIGHT_OBLIQUE_SIZE, -6, -6);
					mouseState = Constant.SIDE_LEFT | Constant.SIDE_BOTTOM;
				}else if(xPosition >= (this.x + this.width - mouseMargin) && yPosition <= (this.y + mouseMargin)){
					CursorUtils.changeCursor(Constant.RIGHT_OBLIQUE_SIZE, -6, -6);
					mouseState = Constant.SIDE_RIGHT | Constant.SIDE_TOP;
				}else if(xPosition >= (this.x + this.width - mouseMargin)){
					CursorUtils.changeCursor(Constant.HORIZONTAL_SIZE, -9, -9);
					mouseState = Constant.SIDE_RIGHT;	
				}else if(xPosition <= (this.x + mouseMargin)){
					CursorUtils.changeCursor(Constant.HORIZONTAL_SIZE, -9, -9);
					mouseState = Constant.SIDE_LEFT;
				}else if(yPosition >= (this.y + this.height - mouseMargin)){
					CursorUtils.changeCursor(Constant.VERTICAL_SIZE, -9, -9);
					mouseState = Constant.SIDE_BOTTOM;
				}else if(yPosition <= (this.y + mouseMargin)){
					CursorUtils.changeCursor(Constant.VERTICAL_SIZE, -9, -9);
					mouseState = Constant.SIDE_TOP;
				}else{
					mouseState = Constant.SIDE_OTHER;
					CursorUtils.changeCursor(null, 0, 0);
				}
			}
			//Use SystemManager to listen the mouse reize event, so we needn't handle the event at the current object.
			//oResize(event);
		}
		
		/**
		 * Hide the arrow when not draging and moving out the window.
		 * @param The MouseEvent.MOUSE_MOVE
		 */
		private function oMouseOut(event:MouseEvent):void{
			if(resizeObj == null){
				CursorUtils.changeCursor(null, 0, 0);
			}
		}
		
		/**
		 * Resize when the draging window, resizeObj is not null.
		 * @param The MouseEvent.MOUSE_MOVE
		 */
		private function oResize(event:MouseEvent):void{
			if(resizeObj != null){	
				resizeObj.stopDragging();
				var xPlus:Number = Application.application.parent.mouseX - resizeObj.oPoint.x;
				var yPlus:Number = Application.application.parent.mouseY - resizeObj.oPoint.y;
			    switch(mouseState){
			    	case Constant.SIDE_RIGHT | Constant.SIDE_BOTTOM:
			    		resizeObj.width = resizeObj.oWidth + xPlus > _windowMinSize ? resizeObj.oWidth + xPlus : _windowMinSize;
		    			resizeObj.height = resizeObj.oHeight + yPlus > _windowMinSize ? resizeObj.oHeight + yPlus : _windowMinSize;
			    		break;
			    	case Constant.SIDE_LEFT | Constant.SIDE_TOP:
		    			resizeObj.x = xPlus < resizeObj.oWidth - _windowMinSize ? resizeObj.oX + xPlus: resizeObj.x;
		    			resizeObj.y = yPlus < resizeObj.oHeight - _windowMinSize ? resizeObj.oY + yPlus : resizeObj.y;
			    		resizeObj.width = resizeObj.oWidth - xPlus > _windowMinSize ? resizeObj.oWidth - xPlus : _windowMinSize;
		    			resizeObj.height = resizeObj.oHeight - yPlus > _windowMinSize ? resizeObj.oHeight - yPlus : _windowMinSize;
			    		break;
			    	case Constant.SIDE_LEFT | Constant.SIDE_BOTTOM:
			    		resizeObj.x = xPlus < resizeObj.oWidth - _windowMinSize ? resizeObj.oX + xPlus: resizeObj.x;
			    		resizeObj.width = resizeObj.oWidth - xPlus > _windowMinSize ? resizeObj.oWidth - xPlus : _windowMinSize;
		    			resizeObj.height = resizeObj.oHeight + yPlus > _windowMinSize ? resizeObj.oHeight + yPlus : _windowMinSize;
			    		break;
			    	case Constant.SIDE_RIGHT | Constant.SIDE_TOP:
			    		resizeObj.y = yPlus < resizeObj.oHeight - _windowMinSize ? resizeObj.oY + yPlus : resizeObj.y;
			    		resizeObj.width = resizeObj.oWidth + xPlus > _windowMinSize ? resizeObj.oWidth + xPlus : _windowMinSize;
		    			resizeObj.height = resizeObj.oHeight - yPlus > _windowMinSize ? resizeObj.oHeight - yPlus : _windowMinSize;
			    		break;
			    	case Constant.SIDE_RIGHT:
			    		resizeObj.width = resizeObj.oWidth + xPlus > _windowMinSize ? resizeObj.oWidth + xPlus : _windowMinSize;
			    		break;
			    	case Constant.SIDE_LEFT:
			    		resizeObj.x = xPlus < resizeObj.oWidth - _windowMinSize ? resizeObj.oX + xPlus: resizeObj.x;
			    		resizeObj.width = resizeObj.oWidth - xPlus > _windowMinSize ? resizeObj.oWidth - xPlus : _windowMinSize;
			    		break;
			    	case Constant.SIDE_BOTTOM:
			    		resizeObj.height = resizeObj.oHeight + yPlus > _windowMinSize ? resizeObj.oHeight + yPlus : _windowMinSize;
			    		break;
			    	case Constant.SIDE_TOP:
			    		resizeObj.y = yPlus < resizeObj.oHeight - _windowMinSize ? resizeObj.oY + yPlus : resizeObj.y;
			    		resizeObj.height = resizeObj.oHeight - yPlus > _windowMinSize ? resizeObj.oHeight - yPlus : _windowMinSize;
			    		break;
			    }
			}
		}
		//
		//
		//
					
		private function creationCompleteHandler(event:Event):void
		{
			myTitleBar = titleBar;			
			// Add the resizing event handler.	
			addEventListener(MouseEvent.MOUSE_DOWN, resizeHandler);
		}

		protected var minShape:SpriteAsset;
		protected var restoreShape:SpriteAsset;
		protected var minOrMax:Boolean=true;

		override protected function createChildren():void
		{
				super.createChildren();
			
			// Create the SpriteAsset's for the min/restore icons and 
			// add the event handlers for them.
			minShape = new SpriteAsset();
			minShape.addEventListener(MouseEvent.MOUSE_DOWN, minPanelSizeHandler);
			titleBar.addChild(minShape);
            
			restoreShape = new SpriteAsset();
			restoreShape.addEventListener(MouseEvent.MOUSE_DOWN, restorePanelSizeHandler);
			titleBar.addChild(restoreShape);
			
		}
			
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// Create invisible rectangle to increase the hit area of the min icon.
			minShape.graphics.clear();
			minShape.graphics.lineStyle(0, 0, 0);
			minShape.graphics.beginFill(0xFFFFFF, 0.0);
			minShape.graphics.drawRect(unscaledWidth - 35, 12, 8, 8);

			// Draw min icon.
			minShape.graphics.lineStyle(2);
			minShape.graphics.beginFill(0xFFFFFF, 0.0);
			minShape.graphics.drawRect(unscaledWidth - 35, 18, 8, 2);
				
			// Draw restore icon.
			restoreShape.graphics.clear();
			restoreShape.graphics.lineStyle(2);
			restoreShape.graphics.beginFill(0xFFFFFF, 0.0);
			restoreShape.graphics.drawRect(unscaledWidth - 35, 12, 8, 8);
			restoreShape.graphics.moveTo(unscaledWidth - 35, 15);
			restoreShape.graphics.lineTo(unscaledWidth - 35, 15);

			// Draw resize graphics if not minimzed.				
			graphics.clear()
			if (isMinimized == false)
			{
				graphics.lineStyle(2);
				graphics.moveTo(unscaledWidth - 6, unscaledHeight - 1)
				graphics.curveTo(unscaledWidth - 3, unscaledHeight - 3, unscaledWidth - 1, unscaledHeight - 6);						
				graphics.moveTo(unscaledWidth - 6, unscaledHeight - 4)
				graphics.curveTo(unscaledWidth - 5, unscaledHeight - 5, unscaledWidth - 4, unscaledHeight - 6);						
			}
			if(minOrMax==true){
			 restoreShape.visible=false; 
			 minShape.visible=true;}
			 
		}
					
		private var myRestoreHeight:int;
		private var isMinimized:Boolean = false; 
					
		// Minimize panel event handler.
		private function minPanelSizeHandler(event:Event):void
		{    
			
		
	      
	       
			if (isMinimized != true)
			{   
				
		        minOrMax=false;
               	myRestoreHeight = height;	
				height = titleBar.height;
				isMinimized = true;	

				// Don't allow resizing when in the minimized state.
				//removeEventListener(MouseEvent.MOUSE_DOWN, resizeHandler);
			}				
		}
		
		// Restore panel event handler.
		private function restorePanelSizeHandler(event:Event):void
		{
			if (isMinimized == true)
			{    minOrMax=true;
				height = myRestoreHeight;
				isMinimized = false;	
				// Allow resizing in restored state.				
				/* addEventListener(MouseEvent.MOUSE_DOWN, resizeHandler); */
			}
		}

		// Define static constant for event type.
		public static const RESIZE_CLICK:String = "resizeClick";

		// Resize panel event handler.
		public  function resizeHandler(event:MouseEvent):void
		{
			// Determine if the mouse pointer is in the lower right 7x7 pixel
			// area of the panel. Initiate the resize if so.
			
			// Lower left corner of panel
			var lowerLeftX:Number = x + width; 
			var lowerLeftY:Number = y + height;
				
			// Upper left corner of 7x7 hit area
			var upperLeftX:Number = lowerLeftX-7;
			var upperLeftY:Number = lowerLeftY-7;
				
			// Mouse positionin Canvas
			var panelRelX:Number = event.localX + x;
			var panelRelY:Number = event.localY + y;

			// See if the mousedown is in the lower right 7x7 pixel area
			// of the panel.
			if (upperLeftX <= panelRelX && panelRelX <= lowerLeftX)
			{
				if (upperLeftY <= panelRelY && panelRelY <= lowerLeftY)
				{		
					event.stopPropagation();		
					var rbEvent:MouseEvent = new MouseEvent(RESIZE_CLICK, true);
					// Pass stage coords to so all calculations using global coordinates.
					rbEvent.localX = event.stageX;
					rbEvent.localY = event.stageY;
			
					dispatchEvent(rbEvent);	
				}
			}				
		}		
	}
}
