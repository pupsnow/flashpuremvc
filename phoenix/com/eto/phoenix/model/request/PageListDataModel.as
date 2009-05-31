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
	/**
	 * 
	 * @author riyco
	 * 翻页的model
	 */	
	public class PageListDataModel extends ListDataModel
	{
		/**
		 * Constructor.
		 * @param dispAmount 设置列表每页显示多少行，默认30; 
		 */		
		public function PageListDataModel(serverCall:Function ,dispAmount:Number = 40)
		{
			super(serverCall);
			rowDisplayAmount = dispAmount;
			rowRequestCount = dispAmount;
		}
		
		/**
		 *  是否正在请求 
		 */		
		[Bindable]
		public var isRequest:Boolean = false;
		
		
		public var rowDisplayAmount:int;
		//-----------------------------------------------------
		//   totalPage
		//-----------------------------------------------------
		
		/**
		 * 总页数
		 **/
		[Bindable]
		public var totalPage:uint = 0;
		
		
		//-----------------------------------------------------
		//   currentPage
		//-----------------------------------------------------
		
		/**
		 * 当前页，界面显示用
		 **/
		[Bindable]
		public var currentPage:uint = 1;
		
		/**
		 * @private
		 * 设置当前页
		 **/
		public function setCurrentPage(num:uint):void
		{
			currentPage = num;
		}
		
		//-----------------------------------------------------
		//   lastRequestPage
		//-----------------------------------------------------
		
		/**
		 * @private
		 * 之前请求页：请求时候保存当前请求页的变量。
		 * 当执行请求时更新此变量，当服务器返回数据后，界面显示的currentPage设置为此变量的值。
		 */
		private var _lastRequestPage:Number =1;
		
		/**
		 * @private
		 * @return lastRequestPage
		 */		
		protected function get lastRequestPage():Number
		{
			return _lastRequestPage;
		}
		
		/**
		 * @private
		 */		
		protected function set lastRequestPage(num:Number):void
		{
			_lastRequestPage = num;
		}
		
		//---------------------------------------------------
		//	turnpageMethod
		//---------------------------------------------------
		
		/**
		 * 刷新
		 */
		override public function refresh():void
		{
			excuteRequest(1);
		}
		
		/**
		 * 执行首页
		 */
		public function fristPage():Boolean
		{
			if(currentPage != 1)
			{
				excuteRequest(1);
				return true;
			}
			return false;
		}
		
		/**
		 * 上一页
		 */
		public function prePage():Boolean
		{
			if(currentPage > 1)
			{
				var nextNum:uint = currentPage - 1;
				excuteRequest(nextNum);
				return true;
			}
			return false;
		}
		
		/**
		 * 下一页
		 * 
		 */		
		public function nextPage():Boolean
		{
			if(currentPage < totalPage)
			{
				var nextNum:uint = currentPage+1;
					excuteRequest(nextNum);
				return true;
			}
			return false;
		}
		
		/**
		 * 尾页
		 */		
		public function lastPage():Boolean
		{
			if(currentPage != totalPage)
			{
				excuteRequest(totalPage);
				return true
			}
			return false;
		}
		
		/**
		 * 执行跳转
		 * @param turnTo 跳转到的页数;
		 * @param model PageQuerymodel;
		 * 
		 */		
		public function turnPage(turnTo:Number):Boolean
		{
			//当设置跳转的页数在1到总页数之间，且不等于当前页时执行跳转
			if(turnTo >= 1 && turnTo <= totalPage && turnTo != currentPage)
			{
				excuteRequest(turnTo);
				return true;
			}
			return false;
		}
		
		
		/**
		 * 执行请求;
		 * @param model
		 */		
		protected function excuteRequest(requstPage:Number):void
		{
			if(	currentQueryConditons)
			{
				currentQueryConditons.startIndex = getStartIndex(requstPage);
				currentQueryConditons.endIndex = getEndIndex(requstPage);
						
				if(serverCall != null)
				{
					_lastRequestPage = requstPage;
					serverCall();
					isRequest = true;
				}
				
			}
			else
			{
				throw new Error("未实例化currentQueryConditons")
			}
		}
		
		/**
		 * @private 
		 * @param requstPage 当前请求第几页
		 * @return 请求开始行
		 * 
		 */		
		protected function getStartIndex(requstPage:int):int
		{
			return (requstPage -1) * rowDisplayAmount +1;
		}
		
		/**
		 * @private 
		 * @param requstPage 当前请求第几页
		 * @return 请求结束行
		 * 
		 */
		protected function getEndIndex(requstPage:int):int
		{
			return requstPage * rowDisplayAmount;
		}
		
		//----------------------------------------------
		//		IListDataModel
		//----------------------------------------------
		
		/**
		 * @inherit
		 * 此方法中计算出了总页数
		 */		
		override public function setResultList(result:XMLList, count:int):void
		{
			super.setResultList(result,count);
			//以下计算出总页数
			totalPage = totalRecord/rowDisplayAmount;
		   	if((totalRecord%rowDisplayAmount)>0) //当余数大于0总页数+1
		   	{
			   totalPage = totalPage+1;
		   	}
		   	
		   	//以下将设置界面显示
		   	setCurrentPage(_lastRequestPage);
		   	isRequest = false;
		}
		
	}
}