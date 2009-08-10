package com.view.map.components.controls
{
	import mx.core.UIComponent;
	
	[ExcludeClass]
	
	dynamic public class Area extends   UIComponent
	{
		public function  Area():void{
			super();
		}
		public var href:String;//链接的url
		public var alt:String;//tooltip提示显示的文字信息
		public var coords:String;//店铺的形状
		public var target_num:String;//弹出页面的数据
		public var shape:String;//店铺形状的类型。
		public var target_name:Class;//弹出框的路径
		public var open:String;//右键打开
		public var target:String;//链接网页的打开方式
		
		
	
	}
}