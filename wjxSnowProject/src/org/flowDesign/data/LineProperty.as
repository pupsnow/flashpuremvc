package org.flowDesign.data
{
	public class LineProperty implements IProperty
	{
		
		public var lineTitle:String="";
		public var lineRemark:String="";
		public function getXml():String
		{
			
			var str:String=AssemblyResult.PROPERTY_START;
				str += AssemblyResult.getProperty("line_title","text",lineTitle);
				str += AssemblyResult.getProperty("line_remark","text",lineRemark);
				str += AssemblyResult.PROPERTY_END;
				return str;
		}
		
	}
}