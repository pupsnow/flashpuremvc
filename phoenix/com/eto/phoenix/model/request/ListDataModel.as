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
	import com.eto.phoenix.vo.request.QueryConditions;
	
	/**
	 * 注册一个和List型数据有关的model,哪么至少应高包含下面几个参数
	 * @author riyco
	 */	
	public class ListDataModel implements IListDataModel
	{
		
		/**
		 * Constructor.
		 * @param serverCall 向服务器请求的方法(可选); 
		 */	
		function ListDataModel(serverCall:Function = null)
		{
			if(serverCall != null)
				this.serverCall = serverCall;
		}
		
		/**
		 *  向服务器请求的方法
		 */
		public var serverCall:Function =null;
		
		/**
		 *  当前查询条件 
		 */	
		[Bindable]	
		public var currentQueryConditons:QueryConditions
		
		/**
		 * 查询条件显示 
		 */
		[Bindable]
		public var queryClew:String = "";
		
		//-----------------------------------------------------
		//   rowDisplayAmount
		//-----------------------------------------------------
		
		/**
		 * @private
		 */ 
		private var _rowRequestCountt:uint = 0;
		
		/**
		 * 设置请求的条数
		 * @defult 30
		 **/
		public function set rowRequestCount(dispAmount:uint):void
		{
			_rowRequestCountt = dispAmount;
		}
		
		/**
		 * @private
		 */ 
		public function get rowRequestCount():uint
		{
			return _rowRequestCountt;
		} 
		
				
		/**
		 *  返回的结果
		 */
		private var _resultList:XMLList;
		
		
		public function set resultList(list:XMLList):void
		{
			_resultList = list;
		}
		
		[Bindable]
		public function get resultList():XMLList
		{
			return _resultList;
		}
		
		/**
		 *  总记录数 
		 */
		[Bindable] 
		public var totalRecord:int = 0;
		
		public function refresh():void
		{
			serverCall();
		}
		
		public function setResultList(result:XMLList,count:int):void
		{
			resultList = result;
			totalRecord = count;
			if(currentQueryConditons)
				queryClew = currentQueryConditons.getClew();
		}
	}
}