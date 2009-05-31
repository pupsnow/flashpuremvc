////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.vo.request
{
	public interface IQueryConditions extends IConditions
	{		
		function set startIndex(index:Number):void
		
		function get startIndex():Number
		
		function set endIndex(index:Number):void
		
		function get endIndex():Number
	}
}