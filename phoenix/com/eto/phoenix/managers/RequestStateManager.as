////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.managers
{
	import com.eto.phoenix.managers.requestClasses.RequestStateStruct;
	
	import flash.system.System;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * @author riyco
	 * @version 1.0
	 * @note:
	 * 保存服务器远程方法描述的类
	 * 使用addDescription()记录描述，其中包括请求方法名oprantionName和description请求描述。
	 * 使用描述可用于在向服务器请求时显示当前请求的内容。
	 */
	public class RequestStateManager
	{
		/**
		 * @private
		 */ 
		private static var source:RequestStateManager
		
		public static function getInstance():RequestStateManager
		{
			if(source==null)
				source=new RequestStateManager();
			return source;
		}
		
		//--------------------------------------------------------
		//   以下是保存请求描述相关
		//--------------------------------------------------------
		
		/**
		 * @private
		 * 保存请求描述的数据字典
		 */  
		private var descriptions:Dictionary = new Dictionary();
		
		/**
		 * 添加描述
		 */ 
		public function addDescription(operationName:String,description:String):void
		{
			if(descriptions[operationName] == null)
				descriptions[operationName]=description;
		}
		
		/**
		 * 获取远程方法描述
		 */
		public function getDescription(operationName:String):String
		{
			if(descriptions[operationName] == null)
			{
				return "未知的请求";
			}
			return descriptions[operationName];
		}
		
		//--------------------------------------------------------
		//
		//    以下为请求列表相关
		//
		//--------------------------------------------------------
		
		/**
		 * @private
		 * 记录当前正在执行的请求列表
		 * */
		private var currentRequests:ArrayCollection = new ArrayCollection();
		
		/**
		 * 当前请求的内容描述,界面可绑定此变量
		 * */
		[Bindable]
		public var currentDescription:String = "";
	
		/**
		 * 是否正在请求
		 * @defult false
		 * 当前请求的状态文字显示,界面可绑定此变量
		 * */
		[Bindable]
		public var isRequestSending:Boolean = false;

		/**
		 * 添加请求状态
		 */
		public function addRequestState(stateStruct:RequestStateStruct):void
		{
			currentRequests.addItem(stateStruct);
			
			currentDescription=stateStruct.description;
			
			if(!isRequestSending)
				isRequestSending=true;
		}
		
		/**
		 * 移除请求状态
		 */
		public function removeReqestState(stateStruct:RequestStateStruct):void
		{
			currentDescription=stateStruct.description;
			
			for(var i:int=0; i<currentRequests.length; i++)
			{
				var saveStateStruct:RequestStateStruct=RequestStateStruct(currentRequests[i])
				
				if(saveStateStruct.operationName == stateStruct.operationName)
				{
					currentRequests.removeItemAt(i);
					break;
				}
			}
			
			//当请求状态中没有请求时候，将状态设为false;
			//还存在请求时候，默认状态显示为最前一此请求;
			if(currentRequests.length == 0)
				isRequestSending = false;
			else
				currentDescription = RequestStateStruct(currentRequests[0]).description;
			
			//释放内存	
//			MemoryRelease.excute();
			System.gc();
		}
	}
}