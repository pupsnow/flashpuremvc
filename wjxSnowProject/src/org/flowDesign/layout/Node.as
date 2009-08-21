package org.flowDesign.layout
{
		import flash.events.ContextMenuEvent;
		import flash.events.Event;
		import flash.events.FocusEvent;
		import flash.events.MouseEvent;
		import flash.ui.ContextMenu;
		import flash.ui.ContextMenuItem;
		
		import mx.events.FlexEvent;
		
		import org.flowDesign.event.NodeEvent;
		import org.flowDesign.source.NodeStyleSource;
		
		
		public class Node extends  DrogButton implements IFlowUI
		{
		
		[Event (name="mouseRight", type="flash.events.Event")]
		/**
		 * 属性设置
		 * 节点状态
		 **/
		 
		private var _nodeSate:String=null;
		public function set nodeState(value:String):void
		{
			this._nodeSate=value;
		}
		public function get nodeState():String
		{
			return this._nodeSate;
		}
		
		/**
		 * 是否选择
		 */		
		private var _uiSelect:Boolean=false;
		
		public function set uiSelect(value:Boolean):void
		{
			this._uiSelect=value;
			this.selected=value;
			if(value)
			{
				if(this.glow1!=null)
				{
				this.glow1.target = this;
				this.glow1.repeatCount = 0;
				this.glow1.end();
				this.glow1.play();
				}
			}
			else
			{
				if(this.glow1!=null)
				{
				this.glow1.target = null;
				this.glow1.end(); 
				}
			}
		}
		
		public function get uiSelect():Boolean
		{
			return this._uiSelect;
		}
		
		
		/**
		 * 节点类型
		 */		
		 private var _type:String;
		 public function set type(type:String):void
		 {
			this.setStyle("icon",this.getNodeIcon(type));
			this._type=type;
		}
		public function get type():String
		{
			return this._type;
		}
		/**
		 *是否可以选择
		 */
		private var _isSelect:Boolean=true;
		
		public function set isSelect(value:Boolean):void
		{
			this._isSelect=value;
			
		}
		public function get isSelect():Boolean
		{
		   return this._isSelect;
		}
		
		
		/**
		 * 判断是否可能拖动
		 */		
		private var _isDrage:Boolean=false;
		public function set isDrage(value:Boolean):void
		{
			this._isDrage=value;
		}
		public function get isDrage():Boolean
		{
			return this._isDrage;
		}

		public function Node()
		{
	    	super();
	    	this.addEventListener(MouseEvent.MOUSE_DOWN,nodeMouseDown);
	    	this.addEventListener(MouseEvent.MOUSE_UP,nodeMouseUp);
	    	this.addEventListener(FocusEvent.FOCUS_OUT,nodeFocusOut);
	    	this.addEventListener(Event.REMOVED_FROM_STAGE,removedH);
	    	this.addEventListener(FlexEvent.CREATION_COMPLETE,nodeCreationComplete);
	    	initMenu();
	    	
	    }
	    
	    private function removedH(e:Event):void
	    {
	    	this.removeEventListener(MouseEvent.MOUSE_DOWN,nodeMouseDown);
	    	this.removeEventListener(MouseEvent.MOUSE_UP,nodeMouseUp);
	    	this.removeEventListener(FocusEvent.FOCUS_OUT,nodeFocusOut);
	    	this.removeEventListener(Event.REMOVED_FROM_STAGE,removedH);
	    	this.removeEventListener(FlexEvent.CREATION_COMPLETE,nodeCreationComplete);
	    	glow1.stop();
	    	glow1.target = null
	    	glow1 = null;
	    	this.contextMenu  = null;
	    }
	     private var deleteMenuItem:ContextMenuItem;
	     private var nodePropertyMenuItem:ContextMenuItem;
	     
	     private var setCurrentStep:ContextMenuItem;
	     private var completeCurrentStep:ContextMenuItem;
	     private var passCurrentStep:ContextMenuItem;
	     
         /**
          *右键菜单 
          * @return 
          * 
          */         
         public function initMenu():void
         {
	    	var contextMenu:ContextMenu = new ContextMenu();
	    	contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,mouseRightClick);
	    	contextMenu.hideBuiltInItems(); /**隐藏一些内建的鼠标右键菜单项*/
			deleteMenuItem = new ContextMenuItem("删除");
			deleteMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,nodeDeleteClick);
			contextMenu.customItems.push(deleteMenuItem);
			
			nodePropertyMenuItem= new ContextMenuItem("属性");
			nodePropertyMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,nodePropertyClick);
			contextMenu.customItems.push(nodePropertyMenuItem);
			
			
			setCurrentStep= new ContextMenuItem("设置为当前环节");
			setCurrentStep.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,setCurrentClick);
			contextMenu.customItems.push(setCurrentStep);
			
			completeCurrentStep= new ContextMenuItem("当前环节已完成");
			completeCurrentStep.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,completeCurrentClick);
			contextMenu.customItems.push(completeCurrentStep);
			
			passCurrentStep= new ContextMenuItem("跳过当前环节");
			passCurrentStep.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,passCurrentClick);
			contextMenu.customItems.push(passCurrentStep);
			this.contextMenu = contextMenu;/** 这里的this为Application对象*/
                      
	    } 
	     /**
	      * //右键事件
	      * @param event
	      * @return 
	      * 
	      */	    
	    
	     public function mouseRightClick(event:ContextMenuEvent):void
	     {
	     	if(this.nodeState==null || this.nodeState==NodeStyleSource.defaultState)
	     	{
	     		if(this.isSelect)
	     		{
	     			deleteMenuItem.enabled=true;
	     			nodePropertyMenuItem.enabled=true;
	        		this.dispatchEvent(new NodeEvent(NodeEvent.RIGHT_CLICK));
	     		}
	     		else
	     		{
	     			deleteMenuItem.enabled=false;
	     			nodePropertyMenuItem.enabled=false;
	     		}
	     	}
	     	else
	     	{
	     		deleteMenuItem.visible=false;
	     		nodePropertyMenuItem.visible=false;
	     	}
	     }
	     /**
	      * 删除事件 右键 
	      * @param event
	      * @return 
	      * 
	      */	     
	     
	     public function nodeDeleteClick(event:ContextMenuEvent):void
	     {
	     	this.dispatchEvent(new NodeEvent(NodeEvent.DELETE_CLICK));
	     }
	     /**
	      * 属性事件 右键
	      * @param event
	      * @return 
	      * 
	      */	     
	     
	     public function nodePropertyClick(event:ContextMenuEvent):void
	     {
	     	this.dispatchEvent(new NodeEvent(NodeEvent.PROPERTY_CLICK));
	     }
         	
         	
        
         /**
	      * 设置为当前 右键 
	      * @param event
	      * @return 
	      * 
	      */	     
	     
	     public function setCurrentClick(event:ContextMenuEvent):void
	     {
	     	this.dispatchEvent(new NodeEvent(NodeEvent.SETCURRENT_CLICK));
	     }
	     /**
	      * 当前环节完成 右键
	      * @param event
	      * @return 
	      * 
	      */	     
	     
	     public function completeCurrentClick(event:ContextMenuEvent):void
	     {
	     	this.dispatchEvent(new NodeEvent(NodeEvent.COMPLETECURRENT_CLICK));
	     }		
		
		
		/**
	      * 跳过当前环节完成 右键
	      * @param event
	      * @return 
	      * 
	      */	     
	     
	     public function passCurrentClick(event:ContextMenuEvent):void
	     {
	     	this.dispatchEvent(new NodeEvent(NodeEvent.PASSCURRENT_CLICK));
	     }		
		
		/**
		 * 方法 失去焦点
		 */
		public function nodeFocusOut(event:FocusEvent):void
		{
			this.uiSelect=false;
			event.stopPropagation();
		}
		/**
		 * 鼠标按下 
		 * @param event
		 * 
		 */		
		public function nodeMouseDown(event:MouseEvent):void
		{
			if(this.isSelect)
			{
				 if(!this.uiSelect)
				 {
					this.uiSelect=true;
				 } 
				if(this.uiSelect)
				{
					this.isDrage=true;
					var childNumber:int=this.parent.numChildren;
					this.parent.setChildIndex(this,childNumber-1);
					if(this.nodeState==null || this.nodeState==NodeStyleSource.defaultState)
					{
						this.dispatchEvent(new NodeEvent(NodeEvent.NODESTART_DRAGE));
						this.startDrag();
					}
					
				}
			}
			
		}
		/**
		 *鼠标放开 
		 * @param event
		 * @return 
		 * 
		 */
		public function nodeMouseUp(event:MouseEvent):void
		{
			if(this.isSelect)
			{
				if(this.uiSelect)
				{
					this.isDrage=false;
					if(this.nodeState==null || this.nodeState==NodeStyleSource.defaultState)
					{
						this.dispatchEvent(new NodeEvent(NodeEvent.NODESTOP_DRAGE));
						this.stopDrag();
					}
				}
			}
		}
		/**
		 * 设置属性
		 * @param event
		 * @return 
		 * 
		 */		
		public function nodeCreationComplete(event:FlexEvent):void
		{
		//设置节点的样式名称
		 if(this.nodeState==null)
		 {
		 	this.styleName=NodeStyleSource.defaultState;
		 }
		 if(this.nodeState==NodeStyleSource.complete)
		 {
		 	this.styleName=NodeStyleSource.complete;
		 }
		 if(this.nodeState==NodeStyleSource.execute)
		 {
		 	this.styleName=NodeStyleSource.execute;
		 }
		 if(this.nodeState==NodeStyleSource.noExecute)
		 {
		 	this.styleName=NodeStyleSource.noExecute;
		 } 

		}
		
		
		/**
		 * 判断节点类型
		 * @param nodeType
		 * @return 
		 * 
		 */		
		private function getNodeIcon(nodeType:String):Class
		{
			return NodeStyleSource.getInstace().getIcon(nodeType);
		}	
	}
}