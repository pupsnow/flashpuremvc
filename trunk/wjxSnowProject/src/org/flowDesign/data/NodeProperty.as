package org.flowDesign.data
{
	public class NodeProperty implements IProperty
	{
		
		public var nodeTitle:String="";
		public var remark:String="";
		public function getXml():String
		{
			
			var str:String=AssemblyResult.PROPERTY_START;
				str += AssemblyResult.getProperty("node_title","text",nodeTitle);
				str += AssemblyResult.getProperty("remark","text",remark);
				str += AssemblyResult.PROPERTY_END;
				return str;
		}
		
	}
}