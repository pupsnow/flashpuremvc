////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.components.controls
{
	import com.eto.phoenix.managers.SharedObjectManager;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.controls.List;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.events.ListEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	
	/**
	 *  RecordList的样式 
	 */
	[Style(name="recordListStyleName", type="String", inherit="no")]
	
	/**
	 *
	 * 可以记录一些本地数据的输入框
	 * @author riyco
	 * @version 1.0
	 * @note:
	 * 
	 */
	public class RecordInput extends TextInput
	{
		
		/**
		 * 本地数据model
		 */
		private var model:SharedObjectManager
		
		/**
		 *  Constructor.
		 */
		public function RecordInput()
		{
			super();
			model = SharedObjectManager.getInstance("searchCondition")
		}
		
		/**
		 * @private
		 * popUpList
		 */
		private var recordList:List;
		
		/**
		 * @private
		 * recordList是否是否弹出的标识
		 */
		private var isopen:Boolean=false;
		
		/**
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			recordList = new List();
			recordList.labelField = "label";
			recordList.styleName=getStyle("recordListStyleName");
			recordList.addEventListener(MenuEvent.ITEM_CLICK,recordListClickHandle);
			recordList.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,recordListMouseOusideHandle);
			recordList.addEventListener(KeyboardEvent.KEY_DOWN,recordListKeyboardHandle)
			
			addEventListener(Event.CHANGE,inputChangeHandle);
			addEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandle);
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandle);
			
			
		}
		
		/**
		 * @private
		 * creationCompleteHandle
		 */
		private function creationCompleteHandle(event:FlexEvent):void
		{
			measureComponent();
		}
		
		/**
		 * @private
		 * 设定组件的位置和尺寸
		 */ 
		private function measureComponent():void
		{
			recordList.width = this.width;
		}
		
		//--------------------------------------------------------
		//  以下是输入框一些响应执行事件
		//--------------------------------------------------------
		
		/**
		 * @private
		 * 输入框文本改变时候
		 */
		private function inputChangeHandle(event:Event):void
		{
			var obj:Object = {label:text}
	    	var index:int = model.getIndex(obj)
	    	if(index == -1)//当有数据时候显示列表
	    	{
	    		popUpClose()
	    	}
	    	else
	    	{
	    		if(!isopen)//当下拉列表已拉出时，不再显示下拉动画
	    		{
	    			popUpOpen();
	    		}
	    		setListDataProvider(text);
	    	}
		}
		
		/**
		 * @private
		 * 输入框接收键盘事件
		 * 用户在输入数据显示下拉列表时，直接点向下按钮就可以选择到列表
		 */
		private function inputKeyDownHandle(event:KeyboardEvent):void 
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				inputEnterHandle()
			}
			if(event.keyCode == Keyboard.DOWN)
			{
				inputKeyDown_DownHandle()
			}
			if(event.keyCode == Keyboard.ESCAPE)
			{
				inputEscapeHandle()
			} 
			
		}
		
		/**
		 * @private
		 * 输入框回车事件
		 */
		private function inputEnterHandle():void
		{
			var saveData:Object={label:text}
			model.addItem(saveData);
		}
		
		/**
		 * @private
		 * 键盘向下按钮执行
		 */ 
		private function inputKeyDown_DownHandle():void
		{
			if(isopen)
	    	{
	    		if(recordList.selectedItem == null)
	    		{
	    			this.recordList.selectedIndex = 0;
	    		}
	    		recordList.setFocus();
	    	}
		}
		
		/**
		 * 
		 */
		private function inputEscapeHandle():void
		{
			if(isopen)
				displayPopUp(false);
		}
		
		//--------------------------------------------------------
		//  以下是记录数据的recordList一些响应执行事件
		//--------------------------------------------------------
		
		/**
		 * @private
		 * 菜单列表选择点击事件
		 */
		private function recordListClickHandle(event:ListEvent):void
		{
			var conditionstr:String = event.target.selectedItem.label;
				passSelectRecordToInput(conditionstr);
		}
		
		/**
		 * @private
		 * 响应弹出列表回车事件
		 * 回车后将选择的数据加入并显示到输入框中。
		 */
		private function recordListKeyboardHandle(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				var conditionstr:String = event.target.selectedItem.label;
				passSelectRecordToInput(conditionstr);
			}
		}
		
		/**
		 * @private
		 * 将选择的数据加入并显示到输入框中,并关闭记录列表
		 */
		private function passSelectRecordToInput(conditionstr:String):void
		{
			text = conditionstr;
			setFocus();
			var selectionNum:Number=conditionstr.length;
			setSelection(selectionNum,selectionNum);//设置光标的位置
			displayPopUp(false);
		}
		
		/**
		 * @private
		 * 点击菜单列表以外区域执行事件
		 * 主要是把菜单关闭
		 */
		private function recordListMouseOusideHandle(event:FlexMouseEvent):void
		{
			popUpClose()
		}
		
		
		//------------------------------------------
		//
		//------------------------------------------ 
		
		/**
		 * @private
		 * 打开列表菜单
		 */
		private function popUpOpen():void
		{
			if(!isopen)
			displayPopUp(true)
		}
		
		/**
		 * @private
		 * 关闭列表菜单
		 */
		private function popUpClose():void
		{
			if(isopen)
			displayPopUp(false)
			
		}
		
		/**
		 * @private
		 * displayPopUp
		 */
		private function displayPopUp(show:Boolean):void
		{
			if(show)
			{
				var point:Point = new Point(x,y);
				point = localToGlobal(point);
				
				PopUpManager.addPopUp(recordList,this,false);
				recordList.x = point.x;
				recordList.y = point.y + this.height
								+Number(this.getStyle("borderThickness"));//加入边框的距离
			}
			else
			{
				PopUpManager.removePopUp(recordList);
			}
			isopen = show;
		} 
		
		/**
		 * @private
		 * 为列表赋值
		 */
		private function setListDataProvider(str:String):void
	    {
	    	recordList.dataProvider = model.getFilterCondition(str);
	    }
	}
}