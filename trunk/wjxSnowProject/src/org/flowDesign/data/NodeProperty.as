package org.flowDesign.data
{
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.StringUtil;
	
	public class NodeProperty implements IProperty
	{
		
		public var node_title:String="";
		
		public function getXml():String
		{
			var str:String=StringUtil.substitute(AssemblyResult.PROPERTY_START,getQualifiedClassName(this));
				str +=AssemblyResult.getProperty("node_title","text",node_title);
				str += AssemblyResult.PROPERTY_END;
				return str;
		}
		
		public function setProValue(id:String,value:String):void
		{
			this[id] = value;
		}
		
	}
}