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
	/**
	 * 
	 * @author riyco
	 * 
	 */	
	public class QueryConditions extends RequestConditions implements IQueryConditions
	{
		
		/**
		 *  Constructor.
		 */
		public function QueryConditions()
		{
			//do nothing 
		}
		
		/** 
		 * @private
		 * IQueryConditions.format();
		 * @return null; 
		 */		
		override public function format():String
		{
			//do nothing 
			return null;
		}
		
		/**
		 * @private
		 */
		private var _startIndex:Number = 0; 
		
		/**
		 * @private
		 * IQueryConditions.set startIndex();
		 */
		public function set startIndex(index:Number):void
		{
			_startIndex = index;
		}
		
		/**
		 * 获取请求开始行
		 * IQueryConditions.get startIndex();
		 * @return 0;
		 */
		public function get startIndex():Number
		{
			return _startIndex;
		}
		
		/**
		 * @private
		 */
		private var _endIndex:Number = 0;
		
		/**
		 * @private
		 * IQueryConditions.set endIndex();
		 */
		public function set endIndex(index:Number):void
		{
			_endIndex = index;
		}
		
		/**
		 * 获取请求结束行
		 * IQueryConditions.get endIndex();
		 * @return 0;
		 */
		public function get endIndex():Number
		{
			return _endIndex;
		}
		
		/**
		 * 获取查询条件的提示
		 */
		public function getClew():String
		{
			return null;
		}
	}
}