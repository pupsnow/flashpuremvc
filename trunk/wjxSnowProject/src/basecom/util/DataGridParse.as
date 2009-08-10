package basecom.util
{
	import mx.controls.dataGridClasses.DataGridColumn;
	
	public class DataGridParse
	{
		/**
		 * 判断列表中选择行数,返回0则表示没有选中行
		 * */
		public static function getSelectColumn(dataSource:Object):int
		{
			var checkstate:int=0;
			if(dataSource==null)
			return checkstate;
			for(var i:int=0;i<dataSource.length;i++)
			{
				if(dataSource[i]["select"]=="true")
				{
					checkstate++
				}
			}
			return checkstate;
		}
		/**
		 * 获取选择的多个行对象，以数组的形式返回
		 * */
		public static function getSelectItems(data:Object):Array
		{
			var items:Array=new Array()
			for(var i:int=0;i<data.length;i++)
			{
				if(data[i]["select"].toString()=="true")
				{
					items.push(data[i]);
				}
			}
			return items;
		}
		
		/**
		 * 获取选择的多个列行象指定列的数据，以数组的形式返回
		 * */
		public static function getSelectItem(data:Object,columname:String):Array
		{
			var items:Array=new Array()
			for(var i:int=0;i<data.length;i++)
			{
				if(data[i]["select"].toString()=="true")
				{
					items.push(data[i][columname]);
				}
			}
			return items;
		}
		
		/**
		 * 全选
		 * */
		 public static function selectAll(data:Object):void
		 {
		 	for(var i:int=0;i<data.length;i++)
			{
				if(data[i]["select"].toString()!="true")
				{
					
					data[i]["select"]="true";
				}
			}
		 }
		 /**
		 * 反选
		 * */
		 public static function selectBy(data:Object):void
		 {
		 	for(var i:int=0;i<data.length;i++)
			{
				if(data[i]["select"].toString()=="true")
				{
					data[i]["select"]="false";
				}
				else
				{
					data[i]["select"]="true";
				}
			}
		 }
		 /**
		 * 不选
		 * */
		 public static function selectNone(data:Object):void
		 {
		 	for(var i:int=0;i<data.length;i++)
			{
				if(data[i]["select"].toString()=="true")
				{
					data[i]["select"]="false";
				}
			}
		 }
		 /**
		 * 通过valueList设置列表选择哪几项;
		 * */
		 public static function setSelect(data:Object,columname:String,valueList:Array):void
		 {
		 	for(var i:int=0;i<data.length;i++)
			{
				data[i]["select"]="false";
				for(var ii:int=0;ii<valueList.length;ii++)
				{
					if(data[i][columname].toString()==valueList[ii])
					{
						data[i]["select"]="true";
					}
				}
			}
		 }
		 
		 public static function getHeadText(filed:String,col:Array):String
		 {
		 	
		 	for(var i:int=0;i<col.length;i++)
		 	{
		 		var coll:DataGridColumn=col[i] as DataGridColumn;
		 		if(coll.dataField.toString()==filed)
		 		{
		 			return coll.headerText;
		 		}
		 	}
		 	return "";
		 }
		 /**
		 * 返回固定列为特定值的行
		 * */
		 public static function getSpecialItems(data:Object,columname:String,value:String):Array
		{
			var items:Array=new Array()
			for(var i:int=0;i<data.length;i++)
			{
				if(data[i][columname].toString()==value)
				{
					items.push(data[i]);
				}
			}
			return items;
		}
			/**
		 * 符合特殊字段特殊值条件全选
		 * */
		 public static function selectSpecialAll(data:Object,value:String,columname:String):void
		 {
		 	for(var i:int=0;i<data.length;i++)
			{
			 if(data[i][columname].toString()==value)
				 {
					if(data[i]["select"].toString()!="true")
					{
						
						data[i]["select"]="true";
					}
				}
			}
		 }
		 /**
		 *符合殊字段特殊值条件 反选
		 * */
		 public static function selectSpecialBy(data:Object,value:String,columname:String):void
		 {
		 	for(var i:int=0;i<data.length;i++)
			{
				 if(data[i][columname].toString()==value)
				 {
					if(data[i]["select"].toString()=="true")
					{
						data[i]["select"]="false";
					}
					else
					{
						data[i]["select"]="true";
					}
				 }
			}
		 }
	}
}