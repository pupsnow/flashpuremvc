package basecom.sjd.containers
{
	/**可以自由缩放的titlewindow。
	用于弹出窗口。 
	其中的放大和还原窗口都是linkbutton。
	在此设置样式即可。
	关闭窗口是titlewindow自带的。可以直接应用
	时间：2007-9-6*/
  	import flash.display.DisplayObject;
  	import flash.events.Event;
  	import flash.events.MouseEvent;
  	import flash.geom.Point;
  	
  	import mx.containers.TitleWindow;
  	import mx.controls.LinkButton;
  	import mx.controls.Spacer;
  	import mx.core.Application;
  	import mx.core.UIComponent;
  	
  	import basecom.sjd.utils.Constant;
  	import basecom.sjd.utils.CursorUtils;
  	 [Event(nama="restore")]
  	 [Event(nama="maximize")]

	[Style(name="newminUpSkin", type="Class", inherit="no")]
	[Style(name="newminDownSkin", type="Class", inherit="no")]
	[Style(name="newmaxUpSkin", type="Class", inherit="no")]
	[Style(name="newmaxDownSkin", type="Class", inherit="no")]
    public class PreResizeWindow extends TitleWindow { 	
   	[Bindable]
	public var myTitleBar:UIComponent;  	
   	private var state:int=0;
   	public var btStateUp:LinkButton;
   	public var btStateDown:LinkButton;
   	private var spa:Spacer;
   	[Embed("../assets/min.png")]
   	private var buttonUpIcon:Class;
   	[Embed("../assets/max.png")]
   	private var buttonDownIcon:Class;
   	[Embed("../assets/mindown.png")]
   	 private var maxIcon:Class;
   	[Embed("../assets/maxdown.png")]
   	private var minIcon:Class;
 	    private static var resizeObj:Object;
		private static var mouseState:Number = 0;
		private static var mouseMargin:Number = 1		
		private var oWidth:Number = 0;
		private var oHeight:Number = 0;
		private var oX:Number = 0;
		private var oY:Number = 0;
		private var oPoint:Point = new Point();	
		private var _showWindowButtons:Boolean = false;
		private var _windowMinSize:Number = 50;
		// Add the creationCOmplete event handler.
		public function PreResizeWindow()
		{
			super();	
					
			this.addEventListener(MouseEvent.MOUSE_MOVE, oMouseMove);
			this.addEventListener(MouseEvent.MOUSE_OUT, oMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, oMouseDown);
			/**
			* 不能加这个东西 要不会是垃圾回收无效，是的此控件与root相关联。
			*/			
			//Application.application.parent.addEventListener(MouseEvent.MOUSE_UP, oMouseUp);
			///Application.application.parent.addEventListener(MouseEvent.MOUSE_MOVE, oResize);
			
		}
		
		// Expose the title bar property for draggin and dropping.
	 
    private function setState(state:int):void
    {
    	this.state=state;
    	if(state==0){
    	this.dispatchEvent(new Event('restore'));
    	}
    	else
    	{
    	
    	this.dispatchEvent(new Event('maximize'));
    	
    	}
    }
  //can ues state.  
    	
    protected  override  function createChildren():void{
    	var  newcloseButtonDisabledSkin:Class=getStyle("newcloseButtonDisabledSkin");
    	var  newcloseButtonDownSkin:Class=getStyle("newcloseButtonDownSkin");
    	var  newcloseButtonOverSkin:Class=getStyle("newcloseButtonOverSkin");
    	var  newcloseButtonUpSkin:Class=getStyle("newcloseButtonUpSkin");
    	var  newminUpSkin:Class=getStyle("newminUpSkin");
    	var  newminDownSkin:Class=getStyle("newminDownSkin");
    	var newmaxUpSkin:Class=getStyle("newmaxUpSkin");
    	var newmaxDownSkin:Class=getStyle("newmaxDownSkin"); 
    	  	
    	
    	super.createChildren();
    	spa=new Spacer();
    	btStateUp=new LinkButton();
    	btStateDown=new LinkButton();
    	btStateUp.addEventListener("click",doMaximize);   	
        btStateDown.addEventListener("click",doRestore);
        btStateUp.setStyle("overIcon",newmaxUpSkin);
        btStateUp.setStyle("downIcon",newmaxDownSkin);
        btStateUp.setStyle("upIcon",newmaxUpSkin);
        btStateDown.setStyle("overIcon",newminUpSkin);
        btStateDown.setStyle("downIcon",newminUpSkin);
        btStateDown.setStyle("upIcon",newminDownSkin);
        btStateUp.visible =true;
        btStateDown.visible =false;
        rawChildren.addChild(btStateUp);
        rawChildren.addChild(btStateDown);     
    }

      //覆写 createChildren函数。以两个button作为放大缩小的按钮。  
		private static function initPosition(obj:Object):void{
			obj.oHeight = obj.height;
			obj.oWidth = obj.width;
			obj.oX = obj.x;
			obj.oY = obj.y;
		}
	   //下面是定义鼠标改变窗口大小的函数。	
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
		private var myRestoreHeight:Number;
		private var myRestoreWidth:Number;
		//下面是最大化时的大小。状态。和x.y坐标	
	   public function doMaximize(event:Event):void{
	   	setState(1);
	   	myRestoreHeight = height;
	   	myRestoreWidth=width;	
	    btStateUp.visible= false;
	    btStateDown.visible= true;
	    x=0;
		y=0;
		width=this.parent.width  ;;
		height=this.parent.height ;
	   
	   
	   }
	   
	    //下面还原时的大小。状态和。、x.y坐标。
	   public function doRestore(event:Event) :void{
	   setState(0);        
	   btStateUp.visible= true;
	   btStateDown.visible= false;    
	   width=myRestoreWidth;
	   height=myRestoreHeight;
	   x = this.parent.width / 2 - this.width / 2;
	   y = this.parent.height / 2 - this.height / 2;   
	  
	   }
	   private function changeSize(event:MouseEvent):void
	    {   
	    	if(this.btStateDown.visible==true)
	    	{
	    	
	    	this.width=myRestoreWidth;
	    	this.height=myRestoreHeight;
	    	this.btStateDown.visible=false;
	    	this.btStateUp.visible=true;
	    	this.x = this.parent.width / 2 - this.width / 2;
	        this.y = this.parent.height / 2 - this.height / 2;   
	     }
	    	else
	    	{
	    	
	    	this.x=0;
	    	this.y=0;
	    	myRestoreHeight = height;
	    	myRestoreWidth=width;	
	    	this.width=mx.core.Application.application.width;
	    	this.height=mx.core.Application.application.height;;
	    	this.btStateDown.visible=true;
	    	this.btStateUp.visible=false;}
	    	
	    }
	   protected override function updateDisplayList(unscaledWidth: Number, 
	    unscaledHeight:Number):void {
	     super.updateDisplayList(unscaledWidth, unscaledHeight);
	    if(unscaledWidth > 0){
	    this.visible= true;
	     } 
	     else {
	    this.visible= false;
	     }
	    
	  // var upAsset:DisplayObject = btStateUp.getChildByName("upIcon");
	  //  var downAsset:DisplayObject = btStateDown.getChildByName("downIcon");
	    var margin:int = 4;
	    this.titleBar.addEventListener(MouseEvent.DOUBLE_CLICK,changeSize);
	    titleBar.doubleClickEnabled=true;   
	    btStateUp.setActualSize(15,15);
	    btStateDown.setActualSize(15, 15);
	    var pixelsFromTop:int = 1;
	    var pixelsFromRight:int = 10;
	    var buttonWidth:int=btStateUp.width;
	    var x:Number = unscaledWidth - buttonWidth - pixelsFromRight; 
	    var y:Number = pixelsFromTop;
	    btStateDown.move(x-41, y+1);
	    btStateUp.move(x-41, y+1);
	     }
  	
	}
}