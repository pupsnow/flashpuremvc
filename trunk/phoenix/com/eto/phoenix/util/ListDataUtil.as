////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2008 eto studio 
//
//  we are the champion!
//  
//
////////////////////////////////////////////////////////////////////////////////
package com.eto.phoenix.util
{
	import mx.collections.ListCollectionView;
	
	/**
	 * 解析列表数据
	 * @author riyco
	 * 
	 */	
	public class ListDataUtil
	{
		public function ListDataUtil()
		{
		}
		
		/**
		 * 通过列表数据item中的某个property的值获取item的index
		 * @param dataSource 组件的dataProvider
		 * @param property 需要匹配的的item property
		 * @param value value of property
		 * @return index;
		 * 
		 */		
		public static function getItemIndexByProperty(dataSource:Object,property:String,value:String):int
		{
			if(dataSource && value)
			{
				var len:int = 0;
				if(dataSource is XMLList)
					len = dataSource.length();
				if(dataSource is ListCollectionView ||dataSource is Array)
					len = dataSource.length;
					
				for(var i:int=0; i<=len-1; i++)
				{
					if(dataSource[i][property].toString() == value)
					{						
						return i;
					}
				}
			}
			return -1;
		}
	}
}