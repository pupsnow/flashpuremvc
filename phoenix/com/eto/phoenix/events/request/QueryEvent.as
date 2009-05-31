package com.eto.phoenix.events.request
{
	import com.eto.phoenix.vo.request.QueryConditions;

	public class QueryEvent extends AbstractRequestEvent
	{
		/**
		 *	查询条件的vo 
		 */		
		public var queryConditions:QueryConditions;
		
		public static const QUERY:String = "Query";
		
		public function QueryEvent(type:String = "Query", oprationName:String=null)
		{
			super(type, oprationName);
		}
		
	}
}