////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.business
{
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.AbstractService;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	/**
	 * 
	 *
	 * @author riyco
	 * @version 1.1
	 * @note:基础调用Server委派类,原ServerDelegate。
	 * version-1.1:
	 *      *增加_service,移除了operationName;
	 * 		*改进了serverCall中传递参数的方式;
	 * 		-移除getOperation中指定返回operation,现在operation中将只返回空对象，由子类实现。
	 */
	 
	public class AbstractRequestDelegate
	{
		/**
		 * @private
		 * IResponder接口类
		 * */
		protected var _responder:IResponder
		
		/**
		 * @private
		 * 供调用的AbstractService
		 * */
		protected var _service:AbstractService
		
		/**
		 * Constructor.
		 * @param service 调用的AbstractService
		 * @param responder 实现IResponder的类.在本框架中,请继承AbstractRequestCommand or RequestCommand
		 * 
		 * @see com.eto.phoenix.commands.request.AbstractRequestCommand;
		 * @see com.eto.phoenix.commands.request.RequestCommand;
		 * */	
		public function AbstractRequestDelegate(service:AbstractService,responder :IResponder)
		{
			_responder = responder;
			_service = service;
		}
		
		/**
		 * 获取service.operation.请继承实现;
		 * @return null;
		 */
		public function getOperation(operationName:String):AbstractOperation
		{
			return null;
		}
		
		/**
		 * @param args 发送请求的参数.
		 * 向服务器发送请求
		 */
		public function serverCall(operationName:String , ... args:Array):void
		{
			var operation:AbstractOperation = getOperation(operationName);
			
			var token:AsyncToken = null;
			
			if (args && args.length > 0)
			{
				//这里必须要用.apply
			    token = operation.send.apply(null,args);		
			}
			else
			{
				token = operation.send();
			}
			token.addResponder(_responder);		
		}
	}
}