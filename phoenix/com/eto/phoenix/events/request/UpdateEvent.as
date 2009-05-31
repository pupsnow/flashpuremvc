package com.eto.phoenix.events.request
{
	import com.eto.phoenix.vo.request.UpdateConditions;
	
	public class UpdateEvent extends AbstractRequestEvent
	{
		public var updateConidtions:UpdateConditions
		
		public static const UPDATE:String = "Update";
		
		public function UpdateEvent(type:String = "Update", oprationName:String=null)
		{
			super(type, oprationName);
		}
		
	}
}