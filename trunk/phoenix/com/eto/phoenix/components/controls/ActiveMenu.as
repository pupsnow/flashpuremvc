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
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	
	import mx.controls.Menu;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.menuClasses.IMenuItemRenderer;
	import mx.core.mx_internal;
	import mx.managers.PopUpManager;
	
	use namespace mx_internal;
	
	/**
	 *
	 * ActiveMenu
	 * @author riyco
	 * @version 1.0
	 * 目前提供了对选择的MenuItem.@type的判断，以确实是否在选择后关闭Menu;
	 * 本类不适用于PopUpButton;
	 * 
	 */
	public class ActiveMenu extends Menu
	{
		
		//-------------------------------------------
		//	Constructor
		//-------------------------------------------
		
		/**
		 *  Constructor.
		 */
		public function ActiveMenu()
		{
			super();
		}
		
		/**
		 * @private
		 * 重写的子Menu变量;
		 */
		private var subMenu:Menu;
		
		//-------------------------------------------
		//	needClose
		//-------------------------------------------
		
		/**
		 * @private
		 */
		private var _noCloseTypes:Array = null;
		
		/**
		 * 设置那些类型的Menu节点是不需要点击后立刻关闭的
		 * @defule ["check","radio"]
		 */
		public function set noCloseTypes(types:Array):void
		{
			_noCloseTypes = types;
		}
		
		/**
		 * @private
		 */
		public function get noCloseTypes():Array
		{
			if(_noCloseTypes)
				return _noCloseTypes;
				
			return ["check","radio"];
		}   
		
		/**
		 * @private
		 */
		private var needClose:Boolean = true;
		
		//-------------------------------------------
		//	override
		//-------------------------------------------
		
		/**
		 * @private
		 * 在mouseUp事件中增加对当前选择节点类型的判断，以确定是否在点击后关闭Menu;
		 */ 
		override protected function mouseUpHandler(event:MouseEvent):void
		{
			var row:IListItemRenderer = mouseEventToItemRenderer(event);

	        var item:Object;
	        if (row && row.data)
	        	item = row.data;
	        	
	        var type:String = dataDescriptor.getType(item);
	        for(var i:int=0;i<noCloseTypes.length;i++)
	        {
	        	if(type == noCloseTypes[i])
	        	{
	        		needClose = false;
	        		break;
	        	}
	        }
	        
	        super.mouseUpHandler(event);
		}
		
		/**
		 * @private
		 */ 
		override mx_internal function hideAllMenus():void
		{
			if(needClose)
				super.hideAllMenus();
			
			needClose = true;
		}
		
		/**
	     *	@private
	     * 	重写了openSubMenu,将subMenu实体设置为ActiveMenu;
	     */
	    override mx_internal function openSubMenu(row:IListItemRenderer):void
	    {
	        supposedToLoseFocus = true;
	
	        var r:Menu = getRootMenu();
	        var menu:Menu;

	        // check to see if the menu exists, if not create it
	        if (!IMenuItemRenderer(row).menu)
	        {
	            menu = new ActiveMenu();
	            menu.parentMenu = this;
	            menu.owner = this;
	            menu.showRoot = showRoot;
	            menu.dataDescriptor = r.dataDescriptor;
	            menu.styleName = r;
	            menu.labelField = r.labelField;
	            menu.labelFunction = r.labelFunction;
	            menu.iconField = r.iconField;
	            menu.iconFunction = r.iconFunction;
	            menu.itemRenderer = r.itemRenderer;
	            menu.rowHeight = r.rowHeight;
	            menu.scaleY = r.scaleY;
	            menu.scaleX = r.scaleX;
	
	            // if there's data and it has children then add the items
	            if (row.data && 
	                _dataDescriptor.isBranch(row.data) &&
	                _dataDescriptor.hasChildren(row.data))
	            {
	                menu.dataProvider = _dataDescriptor.getChildren(row.data);
	            }
	            menu.sourceMenuBar = sourceMenuBar;
	            menu.sourceMenuBarItem = sourceMenuBarItem;
	
	            IMenuItemRenderer(row).menu = menu;
	            PopUpManager.addPopUp(menu, r, false);
	        }
	        else
	        {
	            menu = IMenuItemRenderer(row).menu;
	        }
	
	        var _do:DisplayObject = DisplayObject(row);
	        var pt:Point = new Point(0,0);
	        pt = _do.localToGlobal(pt);
	        // when loadMovied, you may not be in global coordinates
	        if (_do.root)   //verify this is sufficient
	            pt = _do.root.globalToLocal(pt);
	        menu.show(pt.x + row.width, pt.y);
	        subMenu = menu;
	        clearInterval(openSubMenuTimer);
	        openSubMenuTimer = 0;
	    }
	}
}