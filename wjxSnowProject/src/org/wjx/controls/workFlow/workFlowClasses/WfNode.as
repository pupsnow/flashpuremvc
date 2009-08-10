package org.wjx.controls.workFlow.workFlowClasses
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 *节点图标 
	 *
	 * 
	 */	
	public class WfNode extends  DrogButton
	{
		import flash.events.FocusEvent;
		import flash.ui.ContextMenu;
		import flash.ui.ContextMenuItem;
		import flash.events.ContextMenuEvent;
		import org.wjx.controls.workFlow.workFlowEvent.NodeEvent;
		import org.wjx.controls.workFlow.workFlowClasses.nodeStateConstants;
		import mx.events.*;
		import mx.controls.Alert;
		[Embed("../images/start.gif")]
		[Bindable]
		public var start:Class;

		[Embed("../images/end.gif")]
		[Bindable]
		public var end:Class;

		[Embed("../images/automatism.gif")]
		[Bindable]
		public var automatism:Class;

		[Embed("../images/manual.gif")]
		[Bindable]
		public var manual:Class;

		[Embed("../images/child.png")]
		[Bindable]
		public var child:Class;
		[Event (name="mouseRight", type="flash.events.Event")]
		
		public function WfNode(){
	    	super();
	    	this.addEventListener(MouseEvent.MOUSE_DOWN,nodeMouseDown);
	    	this.addEventListener(MouseEvent.MOUSE_UP,nodeMouseUp);
	    	this.addEventListener(FocusEvent.FOCUS_OUT,nodeFocusOut);
	    	this.addEventListener(FlexEvent.CREATION_COMPLETE,nodeCreationComplete);
	    	initMenu();
	    	
	    }
	     private var	deleteMenuItem:ContextMenuItem;
	     private var nodePropertyMenuItem:ContextMenuItem;
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
	     	if(this.nodeState==null || this.nodeState==nodeStateConstants.defaultState){
	     		if(this.isSelect){
	     			deleteMenuItem.enabled=true;
	     			nodePropertyMenuItem.enabled=true;
	        		this.dispatchEvent(new NodeEvent(NodeEvent.rightClick));
	     		}else{
	     			deleteMenuItem.enabled=false;
	     			nodePropertyMenuItem.enabled=false;
	     		}
	     	}else{
	     		deleteMenuItem.visible=false;
	     		nodePropertyMenuItem.visible=false;
	     	}
	     }
	     /**
	      * //删除事件 右键 
	      * @param event
	      * @return 
	      * 
	      */	     
	     
	     public function nodeDeleteClick(event:ContextMenuEvent):void{
	     	this.dispatchEvent(new NodeEvent(NodeEvent.deleteClick));
	     }
	     /**
	      * //属性事件 右键
	      * @param event
	      * @return 
	      * 
	      */	     
	     
	     public function nodePropertyClick(event:ContextMenuEvent):void{
	     	this.dispatchEvent(new NodeEvent(NodeEvent.propertyClick));
	     }
         	
         	
         		
		/**
		 * 属性设置
		 * 节点状态
		 **/
		 
		private var _nodeSate:String=null;
		public function set nodeState(value:String):void{
			this._nodeSate=value;
		}
		public function get nodeState():String{
			return this._nodeSate;
		}
		
		/**
		 * //是否选择
		 */		
		private var _nodeSelect:Boolean=false;
		
		public function set nodeSelect(select:Boolean):void{
			this._nodeSelect=select;
			this.selected=select;
		}
		
		public function get nodeSelect():Boolean{
			return this._nodeSelect;
		}
		
		
		/**
		 * 节点类型
		 */		
		private var _type:String;
		 public function set type(type:String):void{
			this.setStyle("icon",this.getNodeIcon(type));
			this._type=type;
		}
		public function get type():String{
			return this._type;
		}
		
		
		/**
		 *是否可以选择
		 */
		private var _isSelect:Boolean=true;
		
		public function set isSelect(value:Boolean):void{
			this._isSelect=value;
			
		}
		public function get isSelect():Boolean{
		   return this._isSelect;
		}
		
		
		/**
		 * 判断是否可能拖动
		 */		
		private var _isDrage:Boolean=false;
		public function set isDrage(value:Boolean):void{
			this._isDrage=value;
		}
		public function get isDrage():Boolean{
			return this._isDrage;
		}
		
		/**
		 * 方法 失去焦点
		 * */
		public function nodeFocusOut(event:FocusEvent):void
		{
			this.nodeSelect=false;
			event.stopPropagation();
		}
		/**
		 *鼠标按下 
		 * @param event
		 * 
		 */		
		public function nodeMouseDown(event:MouseEvent):void
		{
			if(this.isSelect){
				 if(!this.nodeSelect){
					this.nodeSelect=true;
				} 
				if(this.nodeSelect){
					this.isDrage=true;
					var childNumber:int=this.parent.numChildren;
					this.parent.setChildIndex(this,childNumber-1);
					if(this.nodeState==null || this.nodeState==nodeStateConstants.defaultState){
						this.dispatchEvent(new NodeEvent(NodeEvent.nodeStartDrage));
						this.startDrag();
					}
					
				}
				//event.stopPropagation();
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
			if(this.isSelect){
				if(this.nodeSelect){
					this.isDrage=false;
					if(this.nodeState==null || this.nodeState==nodeStateConstants.defaultState){
						this.dispatchEvent(new NodeEvent(NodeEvent.nodeStopDrage));
						this.stopDrag();
					}
				}
				//event.stopPropagation();	
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
		 if(this.nodeState==null){
		 	this.styleName=nodeStateConstants.defaultState;
		 }
		 if(this.nodeState==nodeStateConstants.complete){
		 	this.styleName=nodeStateConstants.complete;
		 }
		if(this.nodeState==nodeStateConstants.execute){
		 	this.styleName=nodeStateConstants.execute;
		 }
		 if(this.nodeState==nodeStateConstants.noExecute){
		 	this.styleName=nodeStateConstants.noExecute;
		 } 
		}
		
		
		/**
		 *判断节点类型
		 * @param nodeType
		 * @return 
		 * 
		 */		
		private function getNodeIcon(nodeType:String):Class{
			if(nodeType=="start-启动活动"){
				return start;
			}else if(nodeType=="end-结束活动"){
				return end;
			}else if(nodeType=="human-人工活动"){
				return manual;
			}else if(nodeType=="tool-自动活动"){
				return automatism;
			}else if(nodeType=="sub_process-子流程"){
				return child;
			}else{
			return null;
			}
		}
		
		
		
		
		
		
		
		
		
	}
}