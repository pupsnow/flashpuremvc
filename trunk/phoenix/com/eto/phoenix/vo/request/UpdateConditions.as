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
	public class UpdateConditions extends RequestConditions implements IUpdateConditions
	{
		
		
		public function UpdateConditions(state:String)
		{
			updateState = state;
			super();
		}
		//--------------------------------------------------
		//		voState
		//--------------------------------------------------
		
		public static const ADD:String = "add";
		
		public static const EDIT:String = "edit";
		
		public static const DELETE:String = "delete"
		
		public static const REPORTAGAIN:String="report";
		
		/**
		 *	@private  
		 */		  
		private var _updateState:String = null;
		
		/**
		 *	设置updateState  
		 */
		public function set updateState(value:String):void
		{
			_updateState = value;
		}
		
		/**
		 *	获取updateState   
		 */
		public function get updateState():String
		{
			return _updateState;
		}
		
		/**		  
		 * @return by updateState;
		 */		  
		override public function format():String
		{
			if(updateState == ADD)
				return formatAdd();
			else if(updateState == EDIT)
				return formatEdit();
			else
				return formatDelete();
				
			return null;
		}
		
		/**
		 *  @private 
		 */		
		protected function formatAdd():String
		{
			return null;
		}
		
		/**
		 *  @private 
		 */
		protected function formatEdit():String
		{
			return null;
		}
		
		/**
		 *  @private 
		 */
		protected function formatDelete():String
		{
			return null;
		}
	}
}