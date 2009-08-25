package org.flowDesign.data
{
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.StringUtil;
	
	public class StartNodeProperty extends NodeProperty
	{
		public var remark:String="";
		override public function getXml():String
		{
			
			var str:String=StringUtil.substitute(AssemblyResult.PROPERTY_START,getQualifiedClassName(this));;
				str += AssemblyResult.getProperty("node_title","text",node_title);
				str += AssemblyResult.getProperty("remark","text",remark);
				str += AssemblyResult.PROPERTY_END;
				return str;
		}
		override public function setProValue(id:String,value:String):void
		{
			this[id] = value;
		}
		
	}
}