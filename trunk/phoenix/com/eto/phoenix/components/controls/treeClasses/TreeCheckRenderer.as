package com.eto.phoenix.components.controls.treeClasses
{
    import mx.controls.treeClasses.*;
    import mx.controls.CheckBox
    import flash.events.MouseEvent
    import flash.events.Event;
    
	/**
	 * 标题：Tree选择框Render
	 * 编写：riyco
	 * 编写日期：2006-11-13
	 * 版本号：1.0
	 * -------------------------------------------------------------------
	 * 
	 **/
    public class TreeCheckRenderer extends TreeItemRenderer {
    	
    	/**
		 * CheckBox对象
		 **/
		protected var check:CheckBox
		
		/**
		 * 父级构造方法
		 **/
	    public function TreeCheckRenderer() {
	        super();
	    }
	    
	    /**
		 * 创建CheckBox实例
		 **/
	    override protected function createChildren():void
		{
	    	super.createChildren();
	    	if(check==null)
	    	{
		    	check=new CheckBox()
		    	check.addEventListener(MouseEvent.CLICK,setChecBoxValue);
				addChild(check)
	    	}
		}
		
		/**
		 * 父级set data方法重写：设置ListData
		 **/
		override public function set data(value:Object):void {
			if(value!=null)
			{
		        super.data = value;
		        if(TreeListData(super.listData).hasChildren) {
		            setStyle("fontWeight", 'bold');
		        }
		        else {
		            setStyle("fontWeight", 'normal');
		        } 
		        
		    } 
	    }
	    
	    /**
		 * 父级commitProperties方法重写：修改组件，该方法在组件创建完毕后仅执行一次
		 **/
		override protected function commitProperties():void
		{
			if(super.listData!=null)
			{
				super.commitProperties();
				if(TreeListData(super.listData).item.@select=="true")
				{
					check.selected=true
				}
				else
				{
					check.selected=false
				}
			}
		}  
		
		/**
		 * 父级updateDisplayList方法重写：组建动态更新，该方法在组件创建完毕后将多次执行
		 **/   
	   override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void {
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	        var startx:Number = super.data?(icon.x+icon.width) : 0;
	        if(super.data) {
	        	check.x=startx
	        	check.setActualSize(20, measuredHeight);
				super.label.x = check.x + check.width;
	        	super.label.y = check.y;
	        	
	        	super.label.text=TreeListData(super.listData).label
	        	//super.label.visible=false;
	            if(TreeListData(super.listData).hasChildren) 
	            {
	                var tmp:XMLList =new XMLList(TreeListData(super.listData).item);
	                var myStr:int = tmp[0].children().length();
	                super.label.text=super.label.text+"(" + myStr + ")";
	            }
	            //check.label=super.label.text;
	            
	        }
	    }
	    
	    /**
		 * CheckBox点击事件
		 **/ 
	    protected function setChecBoxValue(event:Event):void
	    {
	    	if(event.target == check)
	    	{
				  var selectListdata:Object=TreeListData(super.listData).item 
				  if(check.selected)
				  {
				  	selectListdata.@select = "true";
				  	
				  }
				  else
				  {
				  	selectListdata.@select = "false";
				  }
				  var parentXML:XML = selectListdata.parent();
				  if(selectListdata.children())
				  childrenSelected(selectListdata.children(),selectListdata.@select);
		  		  if(parentXML)
		  		  parentSelected(parentXML,selectListdata.@select);
	  		 }
	  		 event.stopImmediatePropagation();
	   	}
	   	
	   	/**
		 * CheckBox点击事件中TreeListData子项数据更改
		 **/ 	
	   	protected function childrenSelected(childXmlList:XMLList,select:String):void
	   	{
			for(var i:Number=0;i<childXmlList.length();i++)
			{
				childXmlList[i].@select=select;
				if(childXmlList[i].hasChildren)
				childrenSelected(childXmlList[i].children(),select);
			}
		}
		
		/**
		 * CheckBox点击事件中TreeListData父项数据更改
		 **/ 
		protected function parentSelected(parentXmlList:XML,select:String):void
		{ 
			if(select=="true")
			{
				parentXmlList.@select=select;
			}
			if(select=="false")
			{
				for(var i:Number=0;i<parentXmlList.children().length();i++)
				{
					if(parentXmlList.children()[i].@select=="true")
					return;
				}
				parentXmlList.@select=select
			}
			if(parentXmlList.parent())
			parentSelected(parentXmlList.parent(),select);
		}
   	}
}

