////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.model.request
{
	public interface IListDataModel
	{
		//-----------------------------------------------------
		//   rowDisplayAmount
		//-----------------------------------------------------
		
		/**
		 * @private
		 */ 
//		private var _rowDisplayAmount:uint = 0;
		/**
		 * 设置每页显示的条数
		 * @defult 30
		 **/
		 function set rowRequestCount(count:uint):void
		
		/**
		 * @private
		 */ 
		 function get rowRequestCount():uint
		function setResultList(result:XMLList,count:int):void
		
		function refresh():void
	}
}