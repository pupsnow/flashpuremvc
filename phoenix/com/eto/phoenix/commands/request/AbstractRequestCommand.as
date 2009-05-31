////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.commands.request
{
	
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.ddnetwork.base.components.ErrorWindow;
	import com.eto.phoenix.events.request.AbstractRequestEvent;
	
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	/**
	 *
	 * @author riyco
	 * @version 1.0
	 * @note:所有服务器请求的父类。
	 * 本类实现执行服务器方法的验证，以及对服务器返回（成功/失败）的验证
	 *  
	 */ 
	public class AbstractRequestCommand implements Command,IResponder
	{
		/**
		 * @private
		 * 开始执行请求命令
		 */
		public function execute(event:CairngormEvent):void
		{
			if(checkExecute(event))//验证
			{
				var requestEvent:AbstractRequestEvent=AbstractRequestEvent(event);
				overExecute(requestEvent);
			}
		}
		
		/**
		 * 验证请求,在这里没有具体执行方法，默认返回true，由子类实现。
		 * @default true 
		 */
		protected function checkExecute(event:CairngormEvent):Boolean
		{
			return true;
		}
		
		/**
		 * 验证成功后执行,本方法没有具体实现执行方法，由子类重写实现
		 */
	    protected function overExecute(event:AbstractRequestEvent):void
		{
			//do nothing,rewriting by child-class;
		}
		
		/**
		 * @private
		 * 服务返回回调函数
		 */
		public function result(data:Object):void
		{
			try
			{				
 				var revent:ResultEvent = data as ResultEvent;
 				var xml:XML=new XML(revent.result);
 				trace(xml.toXMLString());
 				if(checkResult(xml))//验证:当XML返回总记录为-1时执行overFault
 				{
 					overResult(xml);
 				}
 				else
 				{
 					overFault(xml)
 				}
 			}
 			catch(exception:Error)
			{
	    		var pop:ErrorWindow=new ErrorWindow();
	    		pop.title ="数据格式错误:"+exception.message;
 				pop.pErrorInfo="@name:"+exception.getStackTrace()+"\n@view_mes"+data.result.toString();
 				PopUpManager.addPopUp(pop,DisplayObject(Application.application),true);
 				PopUpManager.centerPopUp(pop);
 				TryError();
 			}
		}
		
		/**
		 * @default true
		 * 验证返回数据
		 */
		protected function checkResult(xml:XML):Boolean
		{
			return true;
		}
		
		/**
		 * 返回验证是有效数据后执行
		 */
		protected function overResult(xml:XML):void
		{
			//do nothing rewriting by child-class;
		}
		
		/**
		 * 服务器抛出异常回调函数
		 */
		public function fault(data:Object):void
		{
			var fevent:FaultEvent = data as FaultEvent;
			overFault(fevent)
			//Alert.show(fevent.fault.faultString,"服务器连接出错");
		}
		
		/**
		 * @private
		 * 服务器返回错误信息后报错方法,由子类重写实现
		 */
		protected function overFault(data:*):void
		{
			//do nothing rewriting by child-class;
		}
		
		/**
		* catch 报错调函数 由子类重写实现
		*/	
		
		protected function TryError():void
		{
			//do nothing rewriting by child-class;
		}
	}
}