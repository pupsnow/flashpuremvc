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
	import flash.events.Event;
	
	import mx.containers.HBox;
	import mx.controls.DataGrid;
	import mx.controls.RadioButton;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	
	/**
	 * @author riyco
	 * @version 1.0
	 * @note:
	 * 拥有单选框的DataGrid ItemRenderer
	 * 本类同时要和DataGridChooseColumn配套使用
	 * implements:ILayoutManagerClient, IListItemRenderer, IStyleClient,IDataRenderer,IDropInListItemRenderer
	 * @see com.eto.phoenix.component.controls.dataGridClasses.DataGridChooseColumn
	 */
	public class DataGridRadioRenderer extends HBox implements IDropInListItemRenderer
	{
		
		//-----------------------------------------
		//   Constructor
		//-----------------------------------------
		
		/**
		 *  Constructor.
		 */
		function DataGridRadioRenderer()
		{
			super();
		}
		
		//-----------------------------------------
		//   radioButton and selected
		//-----------------------------------------
		
		/**
		 * @private
		 * 选择框
		 */ 
		private var radioButton:RadioButton
		
		/**
		 * @private
		 * @return radioButton.selected 
		 */		
		public function get selected():Boolean
		{
			return radioButton.selected;
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
			_listData = DataGridListData(value);
		}
		
		/**
		 *  @private
		 */
		public function get listData():BaseListData
		{
			return _listData;
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
		    
		    radioButton=new RadioButton();
		    radioButton.buttonMode=true;
		    
		    radioButton.addEventListener(Event.CHANGE,radioButtonChangeHandle);
		    
		    addChild(radioButton);
		}
		
		//---------------------------------------------------
		//   event_handle
		//---------------------------------------------------
		
		/**
		 * @private
		 */
		protected function radioButtonChangeHandle(event:Event):void
		{
			var dg:DataGrid = DataGrid(listData.owner);
				var chooseClumn:DataGridChooseColumn = dg.columns[listData.columnIndex];
				
				chooseClumn.chooseChange(listData.rowIndex);
		}
	}
}