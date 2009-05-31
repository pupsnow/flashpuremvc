////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.components.containers
{
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.controls.listClasses.ListBase;
	import mx.core.Container;
	import mx.core.ContainerCreationPolicy;
	
	/**
	 * @author riyco
	 * @version 1.0
	 * @note:
	 */
	
	public class DataStateLayout extends Canvas
	{
		/**
		 *  Constructor.
		 */
		public function DataStateLayout()
		{
			super();
		}
		
		//---------------------------------
		//  state
		//---------------------------------
		
		///**
		 //* 没有返回结果的标识
		 //*/ 
		//public static const NO_RESULT:String = "noResult";
		
		//---------------------------------
		//  childrenComponent
		//---------------------------------
		
		/**
		 * 加载的列表组件
		 * 可以是List,DataGrid,Tree,等等...
		 */
		public var listView:ListBase;
		
		/**
		 * 当加载数据为空/返回结果为空时显示的页面.
		 * 这个页面必须是一个Container;
		 */
		public var noResultComponent:Container;
		
		//----------------------------------
	    //  dataProvider
	    //----------------------------------

    	[Bindable("collectionChange")]
    	[Inspectable(category="Data", defaultValue="undefined")]
    	
		/**
		 * 获取列表组件的dataProvider
		 * @default null
     	 * @see mx.collections.ICollectionView
		 */
		public function get dataProvider():Object
		{
			//当列表组件存在时候返回listView.dataProvider
			if(listView)
				return listView.dataProvider;
			return null;
		} 
		
		/**
		 * set 列表组件的 dataProvider
		 */
		public function set dataProvider(value:Object):void
		{
			if(listView)
				listView.dataProvider = value;
			dispatchEvent(new Event("collectionChange"));
			
			if(value)
			{
				if(value is XMLList)
				{
					if(XMLList(value).length() == 0)
					{
						setChildIndex(noResultComponent,numChildren -1)
					}
					else
					{
						setChildIndex(listView,numChildren -1)
					}
				}
			}
		}
		
		//----------------------------------------------
		//   creationPolicy
		//----------------------------------------------
		
		/**
		 * @private
		 * set creationPolicy to ContainerCreationPolicy.AUTO
		 * this attribute can not be changed.
		 */ 
		override public function set creationPolicy(value:String):void
		{
			super.creationPolicy = ContainerCreationPolicy.AUTO;
		}
		
		//----------------------------------------------
		//   override
		//----------------------------------------------
		
		/**
		 * @private
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
			if(noResultComponent)
				addChild(noResultComponent);
			if(listView)
				addChild(listView);
			
			setChildIndex(listView,numChildren -1)
			
		}
		
	}
}