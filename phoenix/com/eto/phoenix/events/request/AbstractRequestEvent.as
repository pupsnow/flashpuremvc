////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.events.request
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	/**
	 * 执行远程调用的Event;
	 * @author riyco  
	 * @see com.adobe.cairngorm.control.CairngormEvent;
	 * @see com.eto.phoenix.commands.request.AbstractRequestCommand;
	 */	
	public class AbstractRequestEvent extends CairngormEvent
	{
		/**
		 * 调用的远程方法名
		 */
		public var operationName:String;
		
		public var resultHandler:Function;
		/**
		 * Constructor 
		 * @param type CairngormEvent.type
		 * @param oprationName 调用远程方法名，当然这个参数并不是必须的,
		 * 你也可以使用其他方法实现为Command指定需要调用的远程方法 
		 */		
		function AbstractRequestEvent(type:String,oprationName:String = null)
		{
			if(oprationName != null)
				this.operationName = oprationName;
				
			super(type);
		}
	}
}