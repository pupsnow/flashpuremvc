package org.flowDesign.data
{
	public class LineProperty implements IProperty
	{
		
		public var line_title:String="";
		public var line_remark:String="";
		public function getXml():String
		{
			
			var str:String=AssemblyResult.LINE_PROPERTY_START;
				str += AssemblyResult.getProperty("line_title","text",line_title);
				str += AssemblyResult.getProperty("line_remark","text",line_remark);
				str += AssemblyResult.PROPERTY_END;
				return str;
		}
		
		public function setProValue(id:String,value:String):void
		{
			this[id] = value;
		}
		
	}
}