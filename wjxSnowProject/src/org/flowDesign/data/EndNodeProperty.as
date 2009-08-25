package org.flowDesign.data
{
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.StringUtil;
	
	public class EndNodeProperty extends NodeProperty
	{
		public var remark:String="";
		public var condition:String="";// 字段必须和 window的id相同
		override public function getXml():String
		{
			
			var str:String=StringUtil.substitute(AssemblyResult.PROPERTY_START,getQualifiedClassName(this));;
				str += AssemblyResult.getProperty("node_title","text",node_title);
				str += AssemblyResult.getProperty("remark","text",remark);
				str += AssemblyResult.getProperty("condition","text",condition);
				str += AssemblyResult.PROPERTY_END;
				return str;
		}
		override public function setProValue(id:String,value:String):void
		{
			this[id] = value;
		}
	}
}