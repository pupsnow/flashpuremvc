package com.eto.phoenix.events.request
{
	import com.eto.phoenix.model.request.ListDataModel;
	import com.eto.phoenix.view.IUpdateComponent;
	
	public class ListDataUpdateEvent extends UpdateEvent
	{
		public var listModel:ListDataModel;
		
		public var updateComponent:IUpdateComponent = null;
		
		public static const LISTDATAUPDATE:String = "ListDataUpdate";
		
		public function ListDataUpdateEvent(type:String = "ListDataUpdate", oprationName:String=null)
		{
			super(type, oprationName);
		}
		
	}
}