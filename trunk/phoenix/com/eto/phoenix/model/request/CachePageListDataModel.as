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
	import mx.controls.Alert;
	
	/**
	 * 
	 * @author riyco
	 * 本地翻页的model
	 * 说明：，将方法返回数据保存为本地数据，并实现本地翻页功能算法
	 * 所有需要本地翻页的功能模块Model均继承该模块。
	 */	
	public class CachePageListDataModel extends PageListDataModel
	{
		/**
		 *  每次向服务器请求多少页 
		 */		
		public var localPage:Number = 10;
		
		/**
		 * 向服务器请求的开始行，结束行由计算得出
		 **/
		private var questNumber:uint=1;
		
		//----------------------------------------------
		//		localList
		//----------------------------------------------
		
		/**
		 * @private
		 * 数据源，在页面上绑定该变量
		 * **/
		private var _localList:XMLList;
		
		/*** 
		 * @private
		 */		
		protected function set localList(list:XMLList):void
		{
			_localList = list;
		}
		
		/*** 
		 * @private
		 */	
		protected function get localList():XMLList
		{
			return _localList;
		}
		//----------------------------------------------
		//		localList
		//--------------------------------
		
		private var _rowRequestCountt:uint = 0;
		/**
		 * 设置请求的条数
		 * @defult 30
		 **/
		override public function set rowRequestCount(dispAmount:uint):void
		{
			_rowRequestCountt = dispAmount*localPage;
		}
		override public function get rowRequestCount():uint
		{
			return _rowRequestCountt;
		}
		/**
		 * @private
		 */ 
		
		//----------------------------------------------
		//		Constructor
		//----------------------------------------------
		
		/**
		 * Constructor
		 * @param localPage
		 */		
		public function CachePageListDataModel(serverCall:Function, dispAmount:Number=30 ,localPage:Number = 10)
		{
			super(serverCall, dispAmount);
			this.localPage = localPage;
		}
		
		//----------------------------------------------
		//		override
		//----------------------------------------------
		
		/**
		 * @private
		 * 重写set resultList方法 将服务器返回的记录加载到localList,并执行本地翻页查询
		 * @param list 服务返回的list
		 * 
		 */		
		override public function set resultList(list:XMLList):void
		{
			_localList = list;
			localSearch(lastRequestPage)
		}
		
		[Bindable]
		override public function get resultList():XMLList
		{
			return super.resultList
		}
		
		/**
		 * @private
		 * 
		 */		
		override public function refresh():void
		{
			super.excuteRequest(1);
		}
		
		/**
		 * @private 
		 */		
		private var passlastNum:uint = 0;//用于计算到翻页页数距离的局部变量
		
		/**
		 * @private 
		 */	
		private var passthisNum:uint = 0;//用于计算到翻页页数距离的局部变量
		
		/**
		 * 在重写excuteRequest方法中，加入了判断，判断当前执行的请求是执行本地查询还是
		 * 向服务器请求新的数据。
		 * @param requstPage 当前请求的页
		 * @private
		 */		
		override protected function excuteRequest(requstPage:Number):void
		{
			passlastNum = lastRequestPage % localPage;
			passthisNum = requstPage % localPage;
			if(passlastNum == 0)
			{
				passlastNum = localPage;
			}
			if(passthisNum == 0)
			{
				passthisNum = localPage;
			}
			
			var bla:Boolean = (requstPage > (localPage + lastRequestPage - (passlastNum)));
			var blb:Boolean = (Math.abs(requstPage - lastRequestPage) >= passlastNum);
			
			var useRequest:Boolean = false;
			
			if(bla)
			{
				useRequest = true;
				super.excuteRequest(requstPage);
			}
			else if(blb)
			{
				if(requstPage < lastRequestPage)
				{
					useRequest = true;
					//var tempPage:int = requstPage - passthisNum
					super.excuteRequest(requstPage);
				}
			}
			
			if(!useRequest)
				localSearch(requstPage)//执行本地查询 */
			
		}
		
		/**
		 * @private
		 * @param requstPage 当前请求第几页
		 * @return 请求开始行
		 */		
		override protected function getStartIndex(requstPage:int):int
		{
			var num:Number = requstPage % localPage;
			if(num == 0)
			{
				num = localPage;
			}
			var index:Number = (requstPage - num )* rowDisplayAmount + 1;
			//mx.controls.Alert.show(num+":"+index);
			return index;
		}
		
		/**
		 * @private 
		 * @param requstPage 当前请求第几页
		 * @return 请求结束行
		 */
		override protected function getEndIndex(requstPage:int):int
		{
			var num:Number = requstPage % localPage;
			if(num == 0)
			{
				num = localPage;
			}
			var index:Number = (requstPage - num + localPage) * rowDisplayAmount;
			return index;
		}
		
		//----------------------------------------------
		//		private
		//----------------------------------------------
		
		/**
		 * @private
		 * 执行本地查询翻页 
		 */		
		private function localSearch(requstPage:Number):void
		{
			var startInt:int = ((requstPage-1)% localPage) * rowDisplayAmount
		 	var endInt:int = ((requstPage-1)% localPage) * rowDisplayAmount + rowDisplayAmount
		 	
		 	if(endInt>localList.length()) //当返回数据长度小于加载数据长度时候，
		 	{							  //将结束行设为返回数据长度，以避免空对象错误
		 		endInt = localList.length()
		 	}
		 	
		 	//记录本次请求的页数
		 	lastRequestPage = requstPage;
		 	
		 	//以下为list赋值
		 	super.resultList = null;
		 	
		 	var tempList:XMLList = new XMLList();
		 	for(var i:int=startInt;i<endInt;i++)
		 	{
		 		tempList += localList[i]
		 	}
		 	super.resultList = tempList;
		 	
		 	//将页面显示的页设置为本次请求的页
		 	setCurrentPage(requstPage);
		}
	}
}