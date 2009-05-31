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
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.managers.PopUpManager;
	
	//--------------------------------------------
	//    Style
	//--------------------------------------------
	
	/**
	 *  关闭按钮的样式 
	 *  closeButton
	 */
	[Style(name="closeButtonStyleName", type="String", inherit="no")]
	
	/**
	 *  缩放-最大化按钮的样式 
	 *  zoomButton
	 */
	[Style(name="zoomMaxButtonStyleName", type="String", inherit="no")]
	
	/**
	 *  缩放-还原按钮的样式 
	 *  zoomButton
	 */
	[Style(name="zoomOriginalButtonStyleName", type="String", inherit="no")]
	
	/**
	 *  最小化/隐藏按钮的样式 
	 *  hideButton
	 */
	[Style(name="hideButtonStyleName", type="String", inherit="no")]
	
	//--------------------------------------------
	//    Event
	//--------------------------------------------
	
	/**
	 *  Dispatched when the user selects the close button.
	 *
	 *  @eventType mx.events.CloseEvent.CLOSE
	 *  @tiptext close event
	 */
	[Event(name="close", type="mx.events.CloseEvent")]
	
	/**
	 * Dispatched when the user selects the hideButton.
	 * 窗口缩小/隐藏事件
	 */
	[Event(name="hideWindow", type="flash.events.MouseEvent")]
	
	/**
	 *
	 * Windows窗口样式的窗体
	 * @author riyco
	 * @version 1.0
	 * @note:提供窗体放大缩小按钮，实现放大功能，实现拖动窗体时画面流畅过渡
	 * 
	 */
	
	public class ActiveWindow extends Panel
	{
		
		//---------------------------------
		//    windowButtons
		//---------------------------------
		/**
		 * @private
		 *  关闭按钮
		 */
		private var closeButton:Button;
		
		/**
		 * @private
		 *  缩放按钮
		 */
		private var zoomButton:Button;
		
		/**
		 * @private
		 *  最小化按钮
		 */
		private var hideButton:Button;
		
		//---------------------------------
		//   isDragFluent
		//---------------------------------
		
		/**
		 * @private
		 * 是否在拖动时使用平滑拖动
		 */
		private var _isDragFluent:Boolean=true;
		
		[Inspectable(category="General")]
		
		/**
		 * @defult:true;
		 * 使用flex弹出窗口，当创建窗体过多时，拖动会相当不流畅。
		 * 当_isDragFluent设置为true时,窗体在拖动时将使用平滑拖动模式。
		 * 平滑拖动模式:当窗体被拖动时内部children组件将不可见，这样避免出现拖动窗体时候不流畅的情况发生。
		 */
		public function set isDragFluent(fluent:Boolean):void
		{
			_isDragFluent=fluent;
		}
		
		//---------------------------------
		//   showCloseButton
		//---------------------------------
		
		/**
		 * @private
		 * 是否显示关闭按钮
		 */
		private var _showCloseButton:Boolean=true;
		
		[Inspectable(category="General")]
		
		/**
		 * 设置是否显示关闭按钮
		 */
		public function set showCloseButton(show:Boolean):void
		{
			_showCloseButton = show;
		}
		
		//---------------------------------
		//   showActivityButton
		//---------------------------------
		
		/**
		 * @private
		 * 是否显示隐藏和最小化按钮
		 */
		private var _showActivityButton:Boolean=true;
		
		[Inspectable(category="General")]
		
		/**
		 * 设置是否显示隐藏和最小化按钮
		 * */
		public function set showActivityButton(show:Boolean):void
		{
			_showActivityButton=show;
		}
		
		//---------------------------------
		//   winodowState
		//---------------------------------
		
		/**
		 * @private
		 *  窗体原始状态时标识常量
		 */
		private static const ORIGINAL:String="original";
		
		/**
		 * @private
		 *  窗口最大化状态时标识常量
		 * */
		private static const MAX:String="MAX";
		
		/**
		 * @private
		 * @defult:"original"
		 * 缩放状态
		 */
		private var _winodowState:String=ORIGINAL;
		
		
		protected function set winodowState(value:String):void
		{
			_winodowState=value;
		}
		
		public function get winodowState():String
		{
			return _winodowState;
		}
		
		//-------------------------------------------------
		//  measure
		//------------------------------------------------
		
		/**
		 * @private
		 * 用于记录窗体被创建时候的高度，
		 * 在窗体被放大后，还原时的高度标准
		 * 
		 */
		private var _oheight:Number=100;
		
		/**
		 * @private
		 * 用于记录窗体被创建时候的宽度，
		 * 在窗体被放大后，还原时的宽度标准
		 */
		private var _owidth:uint=100;
		
		/**
		 * @private
		 */
		private var _maxwHight:uint=0;
		
		/**
		 * @private 
		 * 设置最大高度
		 */		
		public function set maxwHight(ht:uint):void
		{
			if(ht==0)
			{
				throw new Error("设定值超出有效范围");
				return;
			}
			_maxwHight=ht;
		}
		
		/**
		 * @private
		 */ 
		public function get maxwHight():uint
		{
			return _maxwHight
		}
		
		/**
		 * @private
		 */
		private var _maxwWidth:uint=0;
		
		/**
		 * 设置最大宽度
		 */
		public function set maxwWidth(wd:uint):void
		{
			if(wd==0)
			{
				throw new Error("设定值超出有效范围");
				return;
			}
			_maxwWidth=wd;
		}
		
		
		//--------------------------------------------
		//    createChildren
		//--------------------------------------------
		/**
		 * @private
		 * 创建children
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			if(_showCloseButton)
			{
				titleBar.doubleClickEnabled=true;
				titleBar.addEventListener(MouseEvent.DOUBLE_CLICK,zoomButtonHandle);
				
				//创建按钮是在FlexEvent.CREATION_COMPLETE事件中执行的
				addEventListener(FlexEvent.CREATION_COMPLETE, windowComplete);
			}
		}
		
		
		/**
		 * @private
		 * <code>FlexEvent.CREATION_COMPLETE</code>执行
		 */
		private function windowComplete(e:FlexEvent):void
		{
			initSize();
			addButton();
			layoutButton();
		}
		
		/**
		 * @private
		 * 初始化窗体尺寸
		 */
		private function initSize():void
		{
			if(this.height>_oheight)
				_oheight=this.height;
			else
				this.height=_oheight;
			if(this.width>_owidth)
				_owidth=this.width;
			else
				this.width=_owidth;
		}
		
		/**
		 * @private
		 * 创建按钮
		 */
		private function addButton():void
		{
			if(_showCloseButton)
			{
				if(closeButton==null)
				{
					closeButton=new Button();
					closeButton.width=17;
					closeButton.height=17;
					closeButton.focusEnabled=false;
					closeButton.styleName=getStyle("closeButtonStyleName");
					closeButton.addEventListener(MouseEvent.CLICK,closeButtonHandle)
					
					titleBar.addChild(closeButton);
					
				}
			}
			if(_showActivityButton)
			{
				if(zoomButton==null)
				{
					zoomButton=new Button();
					zoomButton.width=17;
					zoomButton.height=17;
					zoomButton.focusEnabled=false;
					zoomButton.styleName=getStyle("zoomMaxButtonStyleName");
					zoomButton.addEventListener(MouseEvent.CLICK,zoomButtonHandle)
					
					titleBar.addChild(zoomButton);
				}
				if(hideButton==null)
				{
					hideButton=new Button();
					hideButton.width=17;
					hideButton.height=17;
					hideButton.focusEnabled=false;
					titleBar.addChild(hideButton);
					hideButton.styleName=getStyle("hideButtonStyleName");
					
					hideButton.addEventListener(MouseEvent.CLICK,hideButtonHandle)
				}
			}
		}
		
		//--------------------------------------------
		//    eventHandle
		//--------------------------------------------
		
		/**
		 * @private
		 * dispatch close event.usually,We use <code>PopUpManger.RemovePopUp()<code>.
		 * But,at here,we don`t offer actualize this method.
		 */
		private function closeButtonHandle(e:MouseEvent):void
		{
			dispatchEvent(new CloseEvent("close"));
		}
		
		/**
		 * @private
		 * zoom event
		 */
		private function zoomButtonHandle(e:MouseEvent):void
		{
			if(_winodowState==ORIGINAL)
			{
				//设定最大化宽度
				if(_maxwWidth==0)
					this.width=Application.application.width;
				else
					this.width=_maxwWidth;
				//设定最大化高度
				if(_maxwHight==0)
					this.height=Application.application.height;
				else
					this.height=_maxwHight;
				layoutButton();
				this.x=0;
				this.y=0;
				_winodowState=MAX;
				zoomButton.styleName=this.getStyle("zoomOriginalButtonStyleName")
				return;
			}
			if(_winodowState==MAX)
			{
				this.height=_oheight;
				this.width=_owidth;
				PopUpManager.centerPopUp(this);
				layoutButton();
				_winodowState=ORIGINAL;
				zoomButton.styleName=this.getStyle("zoomMaxButtonStyleName")
				return;
			}
		}
		
		/**
		 * @private
		 * dispatch hideWindow event;
		 */
		private function hideButtonHandle(e:MouseEvent):void
		{
			dispatchEvent(new MouseEvent("hideWindow"));
		}
		
		/**
		 * @private
		 * 设置窗体中按钮的位置
		 */
		private function layoutButton():void
		{
			titleBar.width=this.width-6;
			if(hideButton != null)
			{
				hideButton.move(titleBar.width - 16*3 - 6 -2*2, (titleBar.height - 13) / 2);
			}
			if(zoomButton != null)
			{
				zoomButton.move(titleBar.width - 16*2 - 6 -2, (titleBar.height - 13) / 2);
			}
			if(closeButton != null)
			{
				closeButton.move(titleBar.width - 16 - 6, (titleBar.height - 13) / 2);
			}

		}
		
		/**
		 * @private
		 * 设置窗体内部组件是否可见
		 */
		private function setChildrenVisible(visible:Boolean):void
		{
			var childList:Array=getChildren();
			for(var i:int=0;i<childList.length;i++)
			{
				childList[i].visible=visible;
			}
		}
		
		
		//----------------------------
		//  以下是重写的方法
		//---------------------------------
		
		/**
		 * @private
		 * 当为true时表示窗体准备好可能要移动
		 */
		private var _readyToMove:Boolean=false;
		
		/**
		 * @private
		 * 重写开始执行拖动窗体事件
		 * 当_isDragFluent="true"时,当鼠标点击窗体头时候将_readyToMove设置为true
		 * 并为鼠标移动时间添加监听，当开始拖动窗体时，将内部子组件visible设为false;
		 */
		override protected function startDragging(event:MouseEvent):void
		{
			
			super.startDragging(event);
			if(_isDragFluent)
			{
				addEventListener(
						MoveEvent.MOVE, windowMoveHandler);
				_readyToMove=true;
			}
			
		}
		
		/**
		 * @private
		 * 重写结束执行拖动窗体事件
		 * 当_isDragFluent="true"时,在结束拖动窗体时，将内部子组件visible设为true;
		 */
		override protected function stopDragging():void
		{
			
			super.stopDragging();
			if(_isDragFluent)
			{
				setChildrenVisible(true);
				_readyToMove=false;
				removeEventListener(
            			MoveEvent.MOVE, windowMoveHandler, true);
   			}
		}
		
		/**
		 * @private
		 * 当_readyToMove为true鼠标移动时间添加的监听
		 * 当然，在移动过程中setChildrenVisible(false)只会执行一次
		 */
		private function windowMoveHandler(event:MoveEvent):void
		{
			if(_readyToMove)
			{
				setChildrenVisible(false);
				_readyToMove=false;
			}
		}
		
		
	}
}