////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.components.containers
{
	import com.eto.phoenix.components.skins.ButtonCanvasSkin;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.IFlexDisplayObject;
	import mx.core.IProgrammaticSkin;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.styles.ISimpleStyleClient;
	
	//--------------------------------------------------------
	//    style
	//--------------------------------------------------------
		
	/**
	 *  Radius of component corners for buttonSkin..
	 *  @default 0.
	 */
	 
	[Style(name="buttonFillAlphas", type="Array", arrayType="Number", inherit="no")]
	
	/**
	 *  Colors used to tint the buttonSkin of the control.
	 *  Pass the same color for both values for a flat-looking control.
	 *  
	 *  @default [ 0xFFFFFF, 0xCCCCCC ]
	 */
	[Style(name="buttonFillColors", type="Array", arrayType="uint", format="Color", inherit="no")]
	
	/**
	 *  Alpha transparencies used for the highlight fill of controls.
	 *  The first value specifies the transparency of the top of the 
	 *  highlight and the second value specifies the transparency 
	 *  of the bottom of the highlight. The highlight covers the top half of the skin.
	 *  
	 *  @default [ 0.3, 0.0 ]
	 */
	[Style(name="buttonHighlightAlphas", type="Array", arrayType="Number", inherit="no")]

	/**
	 *  用于指名Button样式的皮肤的类名称
	 *  @default "mx.skins.halo.ButtonSkin"
	 */
	[Style(name="buttonSkin", type="Class", inherit="no")]
	

	/**
	 * @author riyco
	 * @version 1.0
	 * @note:
	 */
	
	public class ButtonCanvas extends Canvas
	{
		 
		/**
		 *  Constructor.
		 */
		public function ButtonCanvas()
		{
			super();

			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        	addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
        	addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
        	
        	buttonMode = true;
		}
		
		//--------------------------------------------------------
		//    skin
		//--------------------------------------------------------
		
		/**
	     *  @private
	     *  A reference to the current skin.
	     *  Set by viewSkin().
	     */
		private var currentSkin:IFlexDisplayObject;
		
		/**
		 * @private
		 * A Sprite to lay the buttonSkin
		 */ 
		private var skinContainer:UIComponent;
		
		//--------------------------------------------------------
		//    override
		//--------------------------------------------------------
		
		/**
		 *  @private
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!skinContainer)
			{
				skinContainer = new UIComponent();
				skinContainer.styleName = this;
				addChild(skinContainer);
			}
		}
		
		/**
	     *  @private
	     */
	    override protected function commitProperties():void
	    {
	        super.commitProperties();
	        
	        if(!skinContainer)
			{
				skinContainer = new UIComponent();
				skinContainer.styleName = this;
				addChild(skinContainer);
			}
	    }
	    
	    //--------------------------------------------------------
		//    eventHandler
		//--------------------------------------------------------
		
	    /**
	    * private
	    * 鼠标移动到ButtonCanvas上时,显示Button样式皮肤
	    */
		private function rollOverHandler(event:MouseEvent):void
		{
			viewSkin()
		}
		
		/**
	    * private
	    * 鼠标移移出ButtonCanvas上时,取消Button样式皮肤
	    */
		private function rollOutHandler(event:MouseEvent):void
		{
			skinContainer.removeChild(DisplayObject(currentSkin));
		}
		
		//--------------------------------------------------------
		//    viewSkin
		//--------------------------------------------------------
		
		private function viewSkin():void
		{
			var newSkinClass:Class = Class(getStyle("buttonSkin"));

			if (!newSkinClass)
       		{
       			newSkinClass =ButtonCanvasSkin;
       		}
       		currentSkin = IFlexDisplayObject(new newSkinClass())
        	currentSkin.setActualSize(width ,height);
        	currentSkin.name="overSkin";
        	
        	var styleableSkin:ISimpleStyleClient = currentSkin as ISimpleStyleClient;
                if (styleableSkin)
                    styleableSkin.styleName = this;
                 
        	currentSkin.visible=true;
        	
        	skinContainer.addChild(DisplayObject(currentSkin));
        	IProgrammaticSkin(currentSkin).validateDisplayList();
 
        	setChildIndex(skinContainer, 0);
        	
		}
		
		//--------------------------------------------------------
		//    other
		//--------------------------------------------------------
		/**
		 * @private
		 */ 
		private function creationComplete(event:FlexEvent):void
		{
			setChildIndex(skinContainer, 0);
		}
		
	}
}