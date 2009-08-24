package org.flowDesign.data
{
	public class NodeProperty implements IProperty
	{
		
		public var node_title:String="";
		public var remark:String="";
		public function getXml():String
		{
			
			var str:String=AssemblyResult.PROPERTY_START;
				str += AssemblyResult.getProperty("node_title","text",node_title);
				str += AssemblyResult.getProperty("remark","text",remark);
				str += AssemblyResult.PROPERTY_END;
				return str;
		}
		
		public function setProValue(id:String,value:String):void
		{
			this[id] = value;
		}
		
	}
}