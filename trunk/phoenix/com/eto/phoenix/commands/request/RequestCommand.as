////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.commands.request
{
	import com.ddnetwork.base.components.ErrorWindow;
	import com.eto.phoenix.events.request.AbstractRequestEvent;
	import com.eto.phoenix.managers.RequestStateManager;
	import com.eto.phoenix.managers.requestClasses.RequestStateStruct;
	
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	
	/**
	 * @author riyco
	 * @version 1.0
	 * @note:
	 * 向服务器发送命令类，此类新增添加当前正在执行的请求。
	 */
	public class RequestCommand extends AbstractRequestCommand
	{
		/**
		 * @privete
		 * 调用WebService方法名标识，用于存储当前正在进行的请求的标识
		 */
		protected var operationName:String;
		
		/**
		 * @private
		 */ 
		private var requestApprize:RequestStateManager 
										= RequestStateManager.getInstance();
		
		//----------------------------------------------------------
	    //		override
	    //----------------------------------------------------------
	    
		/**
		 * @private
		 * 执行函数，此方法将请求加入请求列表，没有具体指名发送命令，由子类实现
		 */
		override protected function overExecute(event:AbstractRequestEvent):void
		{
			this.operationName=event.operationName;
			
			//将请求加入请求列表
			requestApprize.addRequestState(getSendStateVo());
		}
		
		/**
		 * @private
		 * 返回执行，从请求列表中移除本次请求
		 */
		override protected function overResult(xml:XML):void
		{
			requestApprize.removeReqestState(getResultStateVo());
		}
		
	    /**
		 * @private
		 * 服务器返回错误信息后报错方法
		 */
	    override protected function overFault(data:*):void
	    {
	    	if(data is FaultEvent)
	    	{
	    		
	    		var fevent:FaultEvent=FaultEvent(data);	
	    		var pop:ErrorWindow=new ErrorWindow();
	    		pop.title ="连接失败:"
 				pop.pErrorInfo="服务器连接失败：\n\t请检查网络连接，稍侯请重新登陆。\n@name:"+fevent.fault.name+"\n@view_mes"+fevent.fault.message+"\n@server_mes:"+fevent.fault.faultString;
 				PopUpManager.addPopUp(pop,DisplayObject(Application.application),true);
 				PopUpManager.centerPopUp(pop);
	    	}
	    	//从请求列表中移除本次请求
			requestApprize.removeReqestState(getFaultStateVo());
	    }
	    
	    
	    
	  /**
	   *try失败的时候 也就是返回的xml格式不对的时候执行； 
	   * 
	   */	    
	  override  protected function TryError():void
	  {
	  	//从请求列表中移除本次请求
			requestApprize.removeReqestState(getFaultStateVo());
	  }
	    
	    
	    //----------------------------------------------------------
	    //		reuqestState
	    //----------------------------------------------------------
	    
	    /**
	     * @param description
	     * 当description为""的时候description使用默认RequestStateModel中保存的请求描述
	     * 在描述后面加了个"中...";
	     * @see com.eto.phoenix.model.request.RequestStateModel
	     */	    
	    protected function getSendStateVo(description:String = ""):RequestStateStruct
	    {
	    	if(description == "")
	    		description = requestApprize.getDescription(operationName)+"中...";
	    		
	    	var stateVo:RequestStateStruct=new RequestStateStruct(operationName,description);
	    	return stateVo;
	    }
	    
	     /**
	     * @param description
	     * 当description为""的时候description使用默认RequestStateModel中保存的请求描述
	     * 在描述后面加了个"成功";
	     * @see com.eto.phoenix.model.request.RequestStateModel
	     */
	    protected function getResultStateVo(description:String = ""):RequestStateStruct
	    {
	    	if(description == "")
	    		description = requestApprize.getDescription(operationName)+"成功";
	    		
	    	var stateVo:RequestStateStruct=new RequestStateStruct(operationName,description);
	    	return stateVo;
	    }
	    
	    /**
	     * @param description
	     * 当description为""的时候description使用默认RequestStateModel中保存的请求描述
	     * 在描述后面加了个"失败";
	     * @see com.eto.phoenix.model.request.RequestStateModel
	     */
	    protected function getFaultStateVo(description:String = ""):RequestStateStruct
	    {
	    	if(description == "")
	    			description = requestApprize.getDescription(operationName)+"失败";
	    			
	    	var stateVo:RequestStateStruct=new RequestStateStruct(operationName,description);
	    	return stateVo;
	    }
	}
}