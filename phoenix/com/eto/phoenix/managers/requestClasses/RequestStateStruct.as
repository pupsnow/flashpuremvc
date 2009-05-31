////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.managers.requestClasses
{
	/**
	 * 
	 * @author riyco
	 * 请求状态的结构
	 */	
	public class RequestStateStruct
	{
		/**
		 * 接口名称
		 */ 
		public var operationName:String;
		
		/**
		 * 请求描述
		 */ 
		public var description:String;
		
		/**
		 *  Constructor.
		 */	
		function RequestStateStruct(operationName:String,description:String="")
		{
			this.operationName=operationName;
			this.description=description;
		}
	}
}