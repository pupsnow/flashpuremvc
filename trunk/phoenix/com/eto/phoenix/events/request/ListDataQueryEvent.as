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
	import com.eto.phoenix.model.request.ListDataModel;
	
	/**
	 * 
	 * @author riyco
	 * @see com.eto.phoenix.model.request.ListDataModel
	 */	
	public class ListDataQueryEvent extends AbstractRequestEvent
	{
		/**
		 * 	ListDataModel
		 */		
		public var listModel:ListDataModel
		
		/**
		 *	本event默认的type 
		 */		
		public static const LISTDATAQUERY:String = "ListDataQuery";
		
		public function ListDataQueryEvent(type:String = "ListDataQuery",oprationName:String = null)
		{
			super(type, oprationName);
		}
		
	}
}