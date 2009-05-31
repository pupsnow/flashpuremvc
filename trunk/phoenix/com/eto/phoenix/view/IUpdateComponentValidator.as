package com.eto.phoenix.view
{
	public interface IUpdateComponentValidator extends IUpdateComponent
	{
		/**
		 * 验证组件内容 比如：输入框不能为空；
		 */		
		function validator():void
	}
}