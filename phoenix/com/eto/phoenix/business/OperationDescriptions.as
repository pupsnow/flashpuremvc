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
	import com.eto.phoenix.managers.RequestStateManager;
	
	/**
	 * this class record some userful info. about operations of service;
	 * @author riyco
	 * 
	 */	
	public class OperationDescriptions
	{
		/**
		* Constructor
		*/
		public function OperationDescriptions()
		{
			
		}
		
		/**
		 * Add operationName and description in RequestStateManager;
		 * well,you can add some custom method to add more userful info. about operations of service;
		 * @param operationName
		 * @param description 
		 * 
		 * @see com.eto.phoenix.model.request.RequestStateManager;
		 */		
		public function addDescription(operationName:String,description:String):void
		{
			RequestStateManager.getInstance().addDescription(operationName,description);
		}
	}
}