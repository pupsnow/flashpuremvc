////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.managers
{
	import com.adobe.cairngorm.model.IModelLocator;
	
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	
	/**
	 *
	 * 本地数据的输入框Model
	 * @author riyco
	 * @version 1.0
	 * @note:
	 * 
	 */ 
	public class SharedObjectManager implements IModelLocator
	{
		/**
		 */
		private static var model:SharedObjectManager
		
		/**
		 * @private
		 * 本地数据工程名称
		 */ 
		public static const project:String="eto";
		
		/**
		 * @private
		 * 本地数据工程中的数据类
		 */
		private var dataClass:String="";
		
		private var _currConidtionStr:String;
		
		/**
		 * 当前获取的数据列表
		 */
		public var conditonList:ArrayCollection
		
		/**
		 * SharedObject对象
		 */
		private var sObject:SharedObject
		
		static public function getInstance(dc:String):SharedObjectManager
		{
			if(model==null)
			{
				model=new SharedObjectManager(dc);
			}
			return model;
		}
		
		function SharedObjectManager(dc:String)
		{
			this.dataClass=dc;
			sObject=SharedObject.getLocal(project);
			conditonList=new ArrayCollection();
			if(sObject.data[dataClass]!=null)
			conditonList.source=sObject.data[dataClass];
		}
		
		/**
		 * 清除
		 */ 
		public function clear():void
		{
			sObject.clear();
			sObject.flush();
			conditonList.removeAll();
		}
		
		/**
		 * 添加查询记录
		 * */
		public function addItem(obj:Object):void
		{
			if(getIndex(obj)==-1)
			{
				if(obj["label"]!="")
				{
					conditonList.addItemAt(obj,0);
					sObject.data[dataClass]=conditonList.source;
					sObject.flush();
				}
			}
		}
		
		/**
		 * 获取数据框中输入的字符在列表中的位置
		 * */
		public function getIndex(obj:Object):int
		{
			if(obj["label"]==""||obj["label"]==null)
			{
				return -1;
			}
			for(var i:int=0;i<conditonList.length;i++)
			{
				
				if(conditonList[i]["label"].toString().indexOf(obj["label"])!=-1)
				{
					return i
				}
			}
			return -1;
		}
		
		/**
		 * 获取过滤后的查询数据列表
		 */ 
		public function getFilterCondition(conditionStr:String):Object
		{
			this._currConidtionStr=conditionStr;
			var filterArray:Array=conditonList.source.filter(filterCallBack);
			return filterArray.sortOn("label");
		}
		
		private function filterCallBack(element:*, index:int, arr:Array):Boolean
		{
        	return (String(element.label).indexOf(_currConidtionStr)== 0);
  		} 
	}
}