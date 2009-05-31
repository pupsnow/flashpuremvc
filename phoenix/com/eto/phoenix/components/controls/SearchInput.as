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
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	import mx.utils.StringUtil;
	
	//--------------------------------------
	//  Styles
	//-------------------------------------- 
	
	/**
	 * 默认提示输入搜索条件时的字体颜色
	 * @defult 0xAAB3B3
	 */
	[Style(name="textdefultColor", type="uint", format="Color", inherit="no")]
	
	/**
	 * 输入搜索条件的字体颜色
	 * @defult 0x0B333C
	 */
	[Style(name="textColor", type="uint", format="Color", inherit="no")]
	
	/**
	 * 输入框的样式
	 */
	[Style(name="inputStyleName",type="String", inherit="no")]
	
	/**
	 *  清除按钮的样式 
	 *  clearButton
	 */
	[Style(name="clearButtonStyleName", type="String", inherit="no")]
	
	//--------------------------------------
	//  Event
	//-------------------------------------- 
	 
	/**
	 * Dispatched when the user want to search
	 * 执行查询事件
	 */
	[Event(name="excute", type="mx.events.FlexEvent")]

	/**
	 *
	 * 搜索框
	 * @author riyco
	 * @version 1.0
	 * @note:
	 * 
	 */
	 
	public class SearchInput extends Canvas
	{
		
		//--------------------------------------
		//  Constructor
		//-------------------------------------- 
		
		/**
		 *  Constructor.
		 */
		public function SearchInput()
		{
			super();
		}
		
		//--------------------------------------
		//  icon
		//-------------------------------------- 
		/**
		 * @private
		 * 图标源
		 */
		private var _icon:Class = null;
		
	    /**
	     *  @private
	     */
	    override public function set icon(value:Class):void
	    {
	    	if(value)
	    		_icon=value;
	    }
	    
	    /**
	    *  @private
	    *  图标实体
	    */
	    private var iconObject:DisplayObject=null;
	    
	    /**
	    * @private
	    * 图标容器
	    */
	   	private var iconContainer:UIComponent;//如果不使用UIComponent作为图标容器执行会报错
	   	
		//--------------------------------------------------
		//  以下设定默认样式
		//--------------------------------------------------
		
		/** 
		 * Flag for initializing the styles 
		 */
		private static var classConstructed:Boolean = classConstruct();
	
		/** 
		 * Initialize styles to default values 
		 */
		private static function classConstruct():Boolean
		{
			if ( !StyleManager.getStyleDeclaration( "SearchInput" ) )
			{
				// Set SearchInput的两个default style value;
				var newStyleDeclaration:CSSStyleDeclaration = new CSSStyleDeclaration();
				newStyleDeclaration.setStyle( "textdefultColor", 0xAAB3B3 );
				newStyleDeclaration.setStyle( "textColor", 0x0B333C );
				StyleManager.setStyleDeclaration( "SearchInput", newStyleDeclaration, true );
			}
			return true;
		}
		
		//------------------------------------------
		//  searchState
		//------------------------------------------
		
		/**
		 * 等待用户输入信息状态标识:Flag
		 */
		public static const WAITINGINPUT:String = "waitingInput";
		
		/**
		 * 已经输入状态标识
		 */
		public static const INPUTED:String = "inputed";
		
		/**
		 * @private
		 */
		private var _searchState:String = ""; 
		
		/**
		 * 搜索组件的状态，包含两种状态：
		 * 一种是等待用户输入信息状态，一种是已输入条件状态
		 */
		public function get searchState():String
		{
			return _searchState;
		}
		
		/**
		 * @private
		 * 设置输入状态
		 */ 
		private function setSearchState(value:String):void
		{
			_searchState = value;
			if(value == WAITINGINPUT)
			{
				input.text = _defaultClew;
				input.setStyle("color",getStyle("textdefultColor"));
				if(iconObject)
					iconObject.visible=true;
			}
			if(value == INPUTED)
			{
				//这里不需要设置输入框中的文字
				input.setStyle("color",getStyle("textColor"));
			}
		}
	
				
		public function originalState():void
		{
			if(searchState != WAITINGINPUT)
			{
				clearButton.visible = false;
				setSearchState(WAITINGINPUT);
			}
		}
		//-----------------------------------------------
		//  input
		//-----------------------------------------------
		
		/**
		 * @private
		 * 组件：输入框
		 */
		private var input:TextInput; 
		
		/**
		 * @private
		 * 输入框中默认显示的文字
		 */
		private var _defaultClew:String = "请输入您搜索的内容";
		
		public function set defaultClew(value:String):void
		{
			_defaultClew = value;
		}
		//------------------------------------------
		//  clearButton
		//------------------------------------------
		
		/**
		 * @private
		 * 组件：清除按钮
		 */
		private var clearButton:Button;
		
		//--------------------------------------
		//  useRecordInput
		//-------------------------------------- 
		
		/**
		 * @pirvate
		 * 搜索时是否使用保存搜索条件记录到本地
		 * @defult false;
		 */
		private var _useRecordInput:Boolean = false;
		
		[Inspectable(category="General", enumeration="true,false", defaultValue="true")]
		
		public function set useRecordInput(isUse:Boolean):void
		{
			_useRecordInput = isUse;
		}
		
		//--------------------------------------
		//	text
		//--------------------------------------
		
		/**
		 * @return text:String 
		 */		
		public function get text():String
		{
			if(this.searchState == WAITINGINPUT)
				return "";
			return input.text;
		}
		
		//-----------------------------------------
		//  override
		//-----------------------------------------
		
		/**
	     *  @private
	     *  Create components that are children of this Container.
	     */
		override protected function createChildren():void
		{
			super.createChildren();
			
			//创建存搜索记录的输入框or普通的输入框
			if(_useRecordInput)
				input = new RecordInput();
			else
				input = new TextInput();
				
			input.styleName=getStyle("inputStyleName")
			input.addEventListener(FocusEvent.FOCUS_IN,inputFocusInHandle);
			input.addEventListener(FocusEvent.FOCUS_OUT,inputFocusOutHandle);
			input.addEventListener(Event.CHANGE,inputChangeHandle);
			input.addEventListener(KeyboardEvent.KEY_DOWN,inputKey_DownHandle);
			addChild(input);
			
			//创建清除按钮
			clearButton = new Button();
			clearButton.visible=false;
			clearButton.styleName=getStyle("clearButtonStyleName");
			clearButton.addEventListener(MouseEvent.CLICK,clearButtonClickHandle);
			addChild(clearButton);
			
			//创建ICON容器
			iconContainer = new UIComponent();
			addChild(iconContainer);
			
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandle);
			
			//将组件状态设置为初始状态
			setSearchState(WAITINGINPUT);
		}
		
		/**
		 * @private
		 */ 
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (_icon)
            {
                var iconObj:Object = new _icon();
                iconObject = DisplayObject(iconObj);
                iconContainer.addChild(iconObject);
            }
		}
		
		/**
		 * @private
		 * creationCompleteHandle
		 */
		private function creationCompleteHandle(event:FlexEvent):void
		{
			measureComponent()
		}
		
		
		/**
		 * @private
		 * 设定组件的位置和尺寸
		 */ 
		private function measureComponent():void
		{
			//这里的大小设定方式还有待改进，例如要考虑设置cornerRadius时，
			//关闭按钮的位置应该相应发生变化，还有比如文字的pandingRight等
			var wt:Number=width;
			var ht:Number=height;
			
			input.width=wt;
			input.height=ht;
			
			clearButton.width = ht-8;
			clearButton.height = ht-8;
			
			clearButton.x = width-clearButton.width-8
			clearButton.y = ht*0.5 - clearButton.height*0.5
			if(iconObject)
			{
				iconObject.x=width - iconObject.width - 8;
	            iconObject.y=height*0.5 - iconObject.height*0.5;
	  		}
		}
		
		//-----------------------------------------
		//    event handle
		//-----------------------------------------
		
		/**
		 * @private
		 * 当输入框接收焦点时执行方法
		 */
		private function inputFocusInHandle(event:FocusEvent):void
		{
			if(_searchState == WAITINGINPUT)
			{
				input.text="";
				setSearchState(INPUTED)
			}
			else if(_searchState == INPUTED)
			{
				//当输入框中有文字时候将选择所有文字便于用户清除内容
				input.setSelection(0,input.text.length);
			}
		}
		
		/**
		 * @private
		 * 当输入框失去焦点时执行方法
		 */
		private function inputFocusOutHandle(event:FocusEvent):void
		{
			if(input.text == "")
			{
				setSearchState(WAITINGINPUT)
			}
		}
		
		/**
		 * @private
		 * 当输入框文本改变时执行方法
		 */
		private function inputChangeHandle(event:Event):void
		{
			if(input.text == "")
			{
				clearButton.visible = false;
				if(iconObject)
					iconObject.visible=true;
			}
			else
			{
				clearButton.visible = true;
				if(iconObject)
					iconObject.visible=false;
			}
		}
		
		/**
		 * @private
		 * 响应键盘按下事件
		 */
		private function inputKey_DownHandle(event:KeyboardEvent):void
		{
			var condis:String = StringUtil.trim(input.text);//去空格
			if( condis != "")
			{
				if(event.keyCode == Keyboard.ESCAPE)//取消键
					inputEscapeHandle()
				else if(event.keyCode == Keyboard.ENTER)//回车键
					inputEnterHandle()
			}
		}
		
		/**
		 * 响应取消键
		 */
		private function inputEscapeHandle():void
		{
			input.text = "";
			clearButton.visible = false;
			if(iconObject)
				iconObject.visible=true;
		}
		
		/**
		 * @private
		 * 搜索框回车执行事件
		 */ 
		private function inputEnterHandle():void
		{
			dispatchEvent(new FlexEvent("excute"));
		} 
		
		/**
		 * @private
		 * 清除按钮点击执行方法
		 */ 
		private function clearButtonClickHandle(event:MouseEvent):void
		{
			input.text = "";
			input.setFocus();
			clearButton.visible = false;
			if(iconObject)
				iconObject.visible=true;
		}
	}
}