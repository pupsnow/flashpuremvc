////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.components.skins
{
	import mx.skins.Border;
	import mx.skins.halo.HaloColors;
	
	/**
	 * 
	 * @author riyco
	 * 一个什么都没有的皮肤
	 */	
	public class NullSkin extends Border
	{
		public function NullSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w,h);
			switch (name)
			{
				case "overSkin":
					drawRoundRect(0, 0, w, h, 0,0xffffff,0.00001,verticalGradientMatrix(0, 0, w, h)); 
					break;					
				case "downSkin":
					drawRoundRect(0, 0, w, h, 0,0xffffff,0.00001,verticalGradientMatrix(0, 0, w, h)); 
					break;
				case "disabledSkin"://do nothing
				default : break;
			
			}
		}
	}
}