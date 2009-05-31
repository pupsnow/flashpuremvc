////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.components.controls
{
	import com.eto.phoenix.components.skins.NullSkin;
	
	import flash.events.MouseEvent;
	
	import mx.controls.LinkButton;
	import mx.skins.halo.ButtonSkin;
	
	/**
	 * @author riyco
	 * @version 1.0
	 * @note:
	 */
	 
	public class StyleLinkButton extends LinkButton
	{
		
		//-------------------------------------------------
		//   styleState
		//-------------------------------------------------
		
		private static const LIKEBUTTON_SKIN:String = "linkButtonSkin";
		private static const BUTTON_SKIN:String = "buttonSkin";
		private static const TEXT_UNDERLINE:String = "textUnderLine";
		
		/**
		 * @private
		 */ 
		private var _styleState:String = LIKEBUTTON_SKIN;
		
		[Inspectable(category="General", enumeration="linkButtonSkin,buttonSkin,textUnderLine", defaultValue="linkButtonSkin")]
		
		/**
		 * 设置当前LinkButton的样式状态
		 * @see styleStateChange();
		 */ 
		public function set styleState(value:String):void
		{
			_styleState = value;
			styleStateChange();
		}
		
		/**
		 * @private
		 */ 
		public function get styleState():String
		{
			return _styleState
		}
		
		//-------------------------------------------------
		//   Constructor
		//-------------------------------------------------
		
		/**
		 *  Constructor.
		 */
		public function StyleLinkButton()
		{
			super();
			styleStateChange();
		}
		
		//-------------------------------------------------
		//   override
		//-------------------------------------------------
		
		/**
		 * @private
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
		/**
		 * @private
		 */ 
		override protected function rollOverHandler(event:MouseEvent):void
		{
			 super.rollOverHandler(event);
			if(styleState == TEXT_UNDERLINE)
				setStyle("textDecoration","underline");
			
		}
		
		/**
		 * @private
		 */ 
		override protected function rollOutHandler(event:MouseEvent):void
		{
			super.rollOutHandler(event);
			if(styleState == TEXT_UNDERLINE)
					setStyle("textDecoration","none");
		}
		
		//-------------------------------------------------
		//   other
		//-------------------------------------------------
		
		/**
		 * @private
		 * styleState发生改变时执行
		 */ 
		private function styleStateChange():void
		{
			if(styleState == StyleLinkButton.LIKEBUTTON_SKIN)
			{

			}
			else if(styleState == StyleLinkButton.BUTTON_SKIN)
			{
				setStyle("overSkin" ,ButtonSkin);
				setStyle("downSkin" ,ButtonSkin);
				setStyle("selectedUpSkin" ,ButtonSkin);
				setStyle("selectedOverSkin" ,ButtonSkin);
				setStyle("selectedDownSkin" ,ButtonSkin);
			}
			else if(styleState == StyleLinkButton.TEXT_UNDERLINE)
			{
				setStyle("overSkin" ,NullSkin);  //要是要这个皮肤设为null后 那么鼠标放在左右边空白区点击是失效的-wen
				setStyle("downSkin" ,NullSkin);  //这个两个先留到 -riyco
				//如果不设置以下2个样式，到时候鼠标放在左右边空白区就会不停地抖动
				//setStyle("paddingLeft" ,0);
				//setStyle("paddingRight" ,0);
			}
		}
	}
}