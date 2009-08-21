package org.flowDesign.data
{
	import mx.utils.StringUtil;
	
	public class AssemblyResult
	{
		
		public static const PROPERTY_START:String="<property>"
		public static const PROPERTY_END:String="</property>"
		public static function getProperty(id:String,property:String,value:String):String
		{
			if(id==null||property==null||value==null)
			throw new Error("在构造数据时候不允许为空。");
			else
			return StringUtil.substitute("<property id=\"{0}\" property=\"{1}\" value=\"{2}\"/>",id,property,value);
		}

	}
}