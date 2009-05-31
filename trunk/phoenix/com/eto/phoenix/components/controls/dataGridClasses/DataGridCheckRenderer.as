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
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.events.FlexEvent;
    
    /**
	 * @author riyco
	 * @version 1.0
	 * @note:
	 * 拥有选择框的DataGrid ItemRenderer
	 * 本类同时适用与itemRenderer和headerItemRenderer，同时要和DataGridChooseColumn配套使用
	 * implements:ILayoutManagerClient, IListItemRenderer, IStyleClient,IDataRenderer,IDropInListItemRenderer
	 * @see com.eto.phoenix.component.controls.dataGridClasses.DataGridChooseColumn
	 */
	
	public class DataGridCheckRenderer extends HBox implements IDropInListItemRenderer
	{
		
		//-----------------------------------------
		//   Constructor
		//-----------------------------------------
		
		/**
		 *  Constructor.
		 */
		function DataGridCheckRenderer()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandle);
		}
		
		//-----------------------------------------
		//   CheckBox and selected
		//-----------------------------------------
		
		/**
		 * @private
		 * 选择框
		 */ 
		protected var checkBox:CheckBox
		
		/**
		 * 设置当前是否选择
		 */ 
		public function set selected(bn:Boolean):void
		{
			checkBox.selected = bn;
		}
		
		/**
		 * 获取当前是否选择
		 */ 
		public function get selected():Boolean
		{
			return checkBox.selected
		}
		
		//-----------------------------------------
		//   listData
		//-----------------------------------------
		
		/**
		 * @private
		 */
		private var _listData:DataGridListData;
		
		/**
		 *  The implementation of the <code>listData</code> property as 
		 *  defined by the IDropInListItemRenderer interface.
		 *  The text of the renderer is set to the <code>label</code>
		 *  property of the listData.
		 *
		 *  @see mx.controls.listClasses.IDropInListItemRenderer
		 */
		public function set listData(value:BaseListData):void
		{
			_listData=DataGridListData(value);
			
		}
		
		/**
		 *  @private
		 */
		public function get listData():BaseListData
		{
			return _listData;
		}
		
		//--------------------------------------------------
		//  creationComplete
		//--------------------------------------------------
		
		/**
		 * @private
		 */ 
		private function creationCompleteHandle(event:FlexEvent):void
		{
			var chooseClumn:DataGridChooseColumn;
			
			if(data is DataGridChooseColumn)
			{
				//当这个Render用于headRenderer的时候监听ItemRenderer中的checkBox点击事件
				chooseClumn = DataGridChooseColumn(data);
				chooseClumn.addEventListener("itemRendererClick",itemRendererClickHander)
			}
			else
			{
				//当这个Render用于itemRenderer的时候监听对chooseIndices的设置,本设置可以存在与heanderRender
				//也可以是外部调用设置
				var dg:DataGrid = DataGrid(listData.owner);
				chooseClumn = dg.columns[listData.columnIndex];
				chooseClumn.addEventListener("chooseIndicesChange",setSelected)
			}
		}
		
		//---------------------------------------------------
		//   override
		//---------------------------------------------------
		
		/**
		 * @private
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
			
			setStyle("horizontalAlign","center");	
		    
		    checkBox=new CheckBox();
		    checkBox.buttonMode=true;
		    checkBox.addEventListener(MouseEvent.CLICK,checkBoxClickHandle);
		    addChild(checkBox);
		}
		
		
		//---------------------------------------------------
		//   event_handle
		//---------------------------------------------------
		
		/**
		 * @private
		 * checkBox点击事件
		 * 当用于itemRenderer时将从DataGridChooseColumn的chooseIndices移除/添加选择的index;
		 * 当用于headerItemRenderer时设置chooseIndices同时触发DataGridChooseColumn.chooseIndicesChange;
		 * @see com.eto.phoenix.component.controls.dataGridClasses.DataGridChooseColumn
		 */ 
		protected function checkBoxClickHandle(event:MouseEvent):void
		{
			if(data is DataGridChooseColumn)
			{
				var indices:Array
				
				if(selected == true)
				{
					//获取列表长度并创建索引数组
					var len:int = DataGrid(listData.owner).dataProvider.length
					indices =new Array(len);
					for(var i:int = 0;i<len;i++)
					{
						indices.push(i);
					}
				}
				else
				{
					indices = []
				}
				
				DataGridChooseColumn(data).chooseIndices = indices;
			}
			else 
			{
				var dg:DataGrid = DataGrid(listData.owner);
				var chooseClumn:DataGridChooseColumn = dg.columns[listData.columnIndex];
				
				chooseClumn.chooseChange(listData.rowIndex,selected);
			}
		}
		
		//---------------------------------------------------
		//   other
		//---------------------------------------------------
		
		/**
		 * @private
		 * 响应DataGridChooseColumn中的CairngormEvent("chooseIndicesChange")事件;
		 * 本事件仅在本render用于itemRenderer的时候才会触发;
		 * @see com.eto.phoenix.component.controls.dataGridClasses.DataGridChooseColumn
		 */
		private function setSelected(event:CairngormEvent):void
		{
			if(event.data)
			{
				var indices:Array = event.data;
				for(var i:int = 0;i<indices.length;i++)
				{
					if(indices[i] == listData.rowIndex)
					{
						selected = true;
						return;
					}
				}
			}
			selected = false;
		}
		
		/**
		 * @private
		 * 响应DataGridChooseColumn中的CairngormEvent("itemRendererClick")事件;
		 * 本事件仅在本render用于headerItemRenderer的时候才会触发
		 */
		private function itemRendererClickHander(event:CairngormEvent):void
		{
			if(selected)
				selected = false;
		} 	
	}
}