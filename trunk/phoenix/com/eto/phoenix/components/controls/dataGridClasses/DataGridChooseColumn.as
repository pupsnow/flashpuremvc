////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.components.controls.dataGridClasses
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	//--------------------------------------------
	//    Event
	//--------------------------------------------
	
	/**
	 * 当choose发生改变时触发事件;
	 */ 
	[Event(name="chooseIndicesChange", type="com.adobe.cairngorm.control.CairngormEvent")]
	
	/**
	 * headerItemRender CheckBox点击事件
	 */
	[Event(name="itemRendererClick", type="com.adobe.cairngorm.control.CairngormEvent")]
	
	/**
	 *
	 * @author riyco
	 * @version 1.0
	 * @note:
	 * 
	 */
	 
	public class DataGridChooseColumn extends DataGridColumn
	{
		
		/**
		 *  Constructor.
		 */
		public function DataGridChooseColumn(columnName:String=null)
		{
			super(columnName);
			
			itemRenderer = null;
			sortable = false;
			//headerRenderer = null;
		}
		
		//--------------------------------------------
		//    showCheckHeader
		//--------------------------------------------
		
		private var _showCheckHeader:Boolean = false;
		
		[Inspectable(category="General", enumeration="false,true", defaultValue="false")]
		
		/**
		 * 设置当前是否在表头使用CheckBox选择框
		 * 表头的CheckBox选择框将拥有"全选"和"全不选"功能。
		 * 这个属性只有当chooseState = checkBox时才会生效。
		 */
		public function set showCheckHeader(show:Boolean):void
		{
			_showCheckHeader = show;
			headerRenderer = null;
		}
		
		/**
		 * @private
		 */ 
		public function get showCheckHeader():Boolean
		{
			return _showCheckHeader;
		}
		
		//--------------------------------------------
		//    chooseState
		//--------------------------------------------
		
		/**
		 * @private
		 */
		private static const CHECKBOX_STATE:String = "checkBox";
		
		/**
		 * @private
		 */
		private static const RADIOBOX_STATE:String = "radioBox";
		
		/**
		 * @private
		 * Storage for the chooseState property.
		 */		
		private var _chooseState:String = CHECKBOX_STATE;
		
		
		
		[Inspectable(category="General", enumeration="checkBox,radioBox", defaultValue="checkBox")]
		
		/**
		 *  set chooseState
		 *  包含两种状态：checkBox:radioBox
		 */
		public function set chooseState(state:String):void
		{
			_chooseState = state;
			itemRenderer = null;
		}
		
		/**
		 * <p>The default chooseState is the "checkBox",
     	 *  which control the item renderer as CheckBox. </p>
		 */
		public function get chooseState():String
		{
			return _chooseState;
		}
		
		//--------------------------------------------
		//    chooseIndices
		//--------------------------------------------
		
		/**
		 *  @private 
		 */		
		private var _chooseIndices:Array = new Array();
		
		/**
	     *  被选择的索引列表数组
	     *  @default [ ]
	     */
		public function get chooseIndices():Array
		{
			return _chooseIndices;
		}
		
		/**
		 * 设置那些选择框被选择
		 * indices:索引数组
		 * 当chooseIndices被改变时，列表中ItemRenderer中的CheckBox/RadioButton会做出响应的改变
		 */
		public function set chooseIndices(indices:Array):void
		{
			_chooseIndices = indices;
			var event:CairngormEvent = new CairngormEvent("chooseIndicesChange");
			event.data = indices;
			dispatchEvent(event);
		} 
		
		//--------------------------------------------
		//    override
		//--------------------------------------------
		
		/**
		 * @private
		 */ 				
		override public function set itemRenderer(value:IFactory):void
		{
			if(chooseState == CHECKBOX_STATE)
				super.itemRenderer = new ClassFactory(DataGridCheckRenderer);
			if(chooseState == RADIOBOX_STATE)
				super.itemRenderer = new ClassFactory(DataGridRadioRenderer);
		}
		
		/**
		 * @private
		 */
		override public function set headerRenderer(value:IFactory):void
		{
			if(chooseState == CHECKBOX_STATE && showCheckHeader)
			{
				super.headerRenderer = new ClassFactory(DataGridCheckRenderer);
			}
		}
		
		//--------------------------------------------
		//    other
		//--------------------------------------------
		
		/**
		 * 当ItemRenderer中的CheckBox/RadionButton点击时执行,修改chooseIndices;
		 * 当chooseState == CHECKBOX_STATE时同时派送CairngormEvent("itemRendererClick"),
		 * 且DataGridCheckRenderer用于headerItemRenderer时中会响应此事件;
		 * 在本方法执行中不会触发chooseIndicesChange事件，要想触发chooseIndicesChange事件，
		 * 请执行 set chooseIndices(...);
		 * 
		 * @param rowIndex Current selected rowIndex.
		 * @param choose Selected or no ，在RADIOBOX_STATE模式下该参数无效.
		 * 
		 * @See com.eto.phoenix.component.controls.dataGridClasses.DataGridCheckRenderer
		 */ 	
		public function chooseChange(rowIndex:int,choose:Boolean = true):void
		{
			if(chooseState == CHECKBOX_STATE)
			{
				//这个先于修改chooseIndices执行
				var event:CairngormEvent = new CairngormEvent("itemRendererClick");
				dispatchEvent(event);
				
				//以下为修改chooseIndices
				if(choose)
					chooseIndices.push(rowIndex);
				else
				{
					for(var i:int = 0;i<chooseIndices.length;i++)
					{
						if(chooseIndices[i] == rowIndex)
						{
							chooseIndices.splice(i,1);
							return ;
						}
					}
				}
			}
			else if(chooseState == RADIOBOX_STATE)
			{
				chooseIndices[0] = rowIndex;
			}
		}
	}
}