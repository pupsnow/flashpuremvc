package org.flowDesign.data
{
	public class Completion implements IProperty
	{
		
		public var completion:String="";
		public var remark:String="";
		public function getXml():String
		{
			
			var str:String=AssemblyResult.PROPERTY_START;
				str += AssemblyResult.getProperty("completion","text",completion);
				str += AssemblyResult.getProperty("remark","text",remark);
				str += AssemblyResult.PROPERTY_END;
				return str;
		}
		
	}
}