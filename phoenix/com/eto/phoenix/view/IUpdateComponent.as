package com.eto.phoenix.view
{
	import com.eto.phoenix.vo.request.UpdateConditions;
	
	/**
	 * 所有用于Update操作的界面view请实现此接口方法
	 * @author riyco
	 * 
	 */	
	public interface IUpdateComponent
	{
		function sumbit():void
		/**
		 * 获取当前传递的UpdateConditions 
		 * @return 
		 * 
		 */		
		function getUpdateConidtions():UpdateConditions
		
		/**
		 *	清空用户输入。  
		 */		
		function clearConidtions():void
		
		/**
		 *  注销此组件，例如添加的窗口实现此接口在logout方式中可以实行PopUpManager.removePopUp(...); 
		 * 
		 */		
		function logout():void
	}
}