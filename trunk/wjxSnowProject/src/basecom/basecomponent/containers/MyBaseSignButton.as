package basecom.basecomponent.containers
{
	import basecom.basecomponent.controls.MyImage;
	import basecom.basecomponent.controls.MyLabel;
	import basecom.basecomponent.effects.MyGlow;
	import basecom.basecomponent.effects.MyParallel;
	import basecom.basecomponent.effects.MyZoom;
	import basecom.sjd.containers.PopResizeWindow;
	import basecom.sjd.controls.SuperTabbuttonBar;
	import basecom.sjd.events.CloseEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Box;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;


	/********************************************************************
	* 定义事件 Event
	*********************************************************************/		
	
	/**
	*当点击最小化按钮时候派发 
	*/		
	[Event(name="min",type="basecom.sjd.events.CloseEvent")]
	public class MyBaseSignButton extends Box
	{
		
		
		/********************************************************************
		* 定义属性 
		*********************************************************************/		
		/**
		 * image的路径。
		 */		
		private var _imageUrl:String;
		
		public function set imageUrl(value:String):void
		{
			if(_imageUrl == value)  return;
			  _imageUrl = value;
		}
		
		public function get imageUrl():String
		{
			return _imageUrl;
		}
		/**
		 * 标识类别
		 */		
		private var _signName:String;
		
		public function set signName(value:String):void
		{
			if(_signName == value) return;
				_signName = value;
		}
		public function get signName():String
		{
			return _signName;
		}
		/**
		 * 打开的内容
		 */		
		private var _targetName:Class;
		
		public function set targetName(value:Class):void
		{
			if(_targetName == value) return;
				_targetName = value;
		}
		public function get targetName():Class
		{
			return _targetName;
		}
		/**
		 *状态栏 
		 */		
		private var _tabbar:SuperTabbuttonBar;
		
		public function set tabbar(value:SuperTabbuttonBar):void
		{
			if(_tabbar == value) return;
			_tabbar = value;
		}
		public function get tabbar():SuperTabbuttonBar
		{
			return _tabbar;
		}
		/**
		 * 
		 */		
		 
		private var _dataProvider:ArrayCollection; 
		public function set dataProvider(value:ArrayCollection):void
		{
			if(_dataProvider == value) return;
			_dataProvider = value;
		}
		public function get dataProvicer():ArrayCollection
		{
			return _dataProvider;
		}
		/**************************************************************
		 * 定义效果
		 ***************************************************************/
		
		private var duration:int = 300;
		private var par:MyParallel;
		private var zoomout:MyZoom;
		private var zoomin:MyZoom;
		private var glowout:MyGlow;
		
		/**
		 * 生成效果
		 */		
		public function createEffect():void
		{
			
			/**
			* 放大
			*/
			zoomout = new MyZoom();
			zoomout.zoomWidthFrom=1.0; 	
			zoomout.zoomWidthTo=1.12;
			zoomout.zoomHeightFrom=1.0;  
			zoomout.zoomHeightTo=1.12;
			
			/**
			* 缩小
			*/
			zoomin = new MyZoom();
			zoomin.zoomWidthFrom=1.12; 	
			zoomin.zoomWidthTo=1.0;
			zoomin.zoomHeightFrom=1.12;  
			zoomin.zoomHeightTo=1.0;
			zoomin.duration = 0;
			zoomin.addEventListener(EffectEvent.EFFECT_END,zoominEndHandler);
			/**
			*模糊
			*/			
			glowout = new MyGlow();
			glowout.alphaFrom=1.0;
			glowout.alphaTo=0.3;
        	glowout.blurXFrom=0.0; 
        	glowout.blurXTo=30.0;
        	glowout.blurYFrom=0.0; 
        	glowout.blurYTo=30.0;
        	glowout.color=0xFFFFFF; 
			
			/**
			* 复合效果
			*/			
			par = new MyParallel();
			par.addChild(zoomout);
			par.addChild(glowout);
			par.duration = this.duration;

		}
		
		
		/**
		 * 
		 * 清除效果
		 */		
		public function removeEffect():void
		{
			zoomout.stop()
			zoomout.target = null;
			glowout.stop();
			glowout.target = null;
			zoomin.removeEventListener(EffectEvent.EFFECT_END,zoominEndHandler);
			zoomin.target = null;
			zoomin.stop();
			par.stop();
			par.target = null;
			zoomout = null;
			zoomin = null;
			par = null;
			glowout = null;
		}
		
		/**
		 * 清除效果 内存回收
		 * */
		public function zoominEndHandler(e:EffectEvent):void
		{
			removeEffect();
			System.gc();
		}
		
		
		
		/**
		 *构造函数，默认方向是  vertical；
		 * 
		 */		
		public function MyBaseSignButton()
		{
			super();
			this.useHandCursor=true;
			this.buttonMode=true;
			this.mouseChildren=false;
			this.doubleClickEnabled = true;
			this.direction = "vertical";	
			this.setStyle("horizontalAlign","center");	
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHander);		
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUpHander);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHander);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.addEventListener(MouseEvent.DOUBLE_CLICK,mouseDoubleClickHander);
			
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			var img:MyImage = new MyImage();
				
				 img.width=66;
				 img.height=53;
			var lab:MyLabel = new MyLabel();
				lab.setStyle("color",0xffffff);
				img.source = this.imageUrl;
				lab.text = this.signName;
				this.addChild(img);
				this.addChild(lab);
		}
		
		
		
		
		/**
		 * 创建并执行效果 
		 * @param event
		 * 
		 */		
		public function mouseOverHander(event:MouseEvent):void
		{
			   createEffect();
			   par.target = this;
			   par.play();
			
		}
		
		/**
		 **停止拖动
		 **/
		public function mouseUpHander(event:MouseEvent):void
		{
			this.stopDrag();
		}
		
		/**
		 * 清楚效果 垃圾回收 
		 * @param event
		 * 
		 */		
		public function mouseOutHander(event:MouseEvent):void
		{
			zoomin.target = this;
			zoomin.play();
			/**内部关系 不需要移出也能回收 只需要把此控件 与 外界孤立起来再设置成 null
			this.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHander);
			this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHander);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK,mouseDoubleClickHander); */
		}
		
		
		/**
		 **开始拖动 并且跑到最上面
		 **/
		private function mouseDownHandler(e:MouseEvent):void
		{
			//Alert.show("down");
			 if(e.target==this)
			  {
				  this.startDrag();
				  this.parent.setChildIndex(this,this.parent.numChildren-1);
			  }
		}
		
		
//		private var mycomputer:PopResizeWindow
		public function mouseDoubleClickHander(event:MouseEvent):void
		{
			
				
				var mycomputer:PopResizeWindow = new targetName();
     			mycomputer.x=(this.parent.width-mycomputer.width)/2;
     			mycomputer.y=(this.parent.height-mycomputer.height)/2;
     			mycomputer.title=signName;
     			this.parent.addChild(mycomputer);
     			var closelisten:Function=function(e:mx.events.CloseEvent):void
				{
					/**
				    * *自身窗口关闭事件，关闭时先把自己从父窗口中移出，同时移出TabBar的dataprivoder中对应的数据，
				    * *从而下面的显示栏也少了与其对应的按钮；
				    **/
				     mycomputer.removeEventListener("min",minstate);
			 		 mycomputer.removeEventListener(mx.events.CloseEvent.CLOSE,closelisten);
			 		 mycomputer.removeEventListener("SelectChild",SelectChild);
					 PopResizeWindow(e.target).parent.removeChild(DisplayObject(mycomputer));
				     dataProvicer.removeItemAt(SelectIndex(e.target.name));
				     mycomputer=null;
				}
     			mycomputer.addEventListener("min",minstate);
     			mycomputer.addEventListener(mx.events.CloseEvent.CLOSE,closelisten);
     			mycomputer.addEventListener("SelectChild",SelectChild);
     			dataProvicer.addItem({label:signName,data:mycomputer.name});
     		    tabbar.addEventListener(FlexEvent.UPDATE_COMPLETE,selectid); 
			
			
		}
		
		/**
		 **此函数作用是 实现本窗口被选中后，与其对应的下面的按钮也要处于选中状态
		 **/
		   private function SelectChild(e:MouseEvent):void
		   {
		   	selected(SelectIndex(e.target.name));
		   }
		
		

		/**
	      **次函数主要是返回与name相同的字符的位置，
	      **/
	     private function SelectIndex(name:String):int
	     {
	     	for(var num:Number=0;num<dataProvicer.length;num++)
		     {
			 	if(dataProvicer[num]['data']==name)
			 	{  
			 	  break;//强行退出函数
			 	 }
		     }
	     	return num;
	     }
		/**
		 **在点“我的电脑”按钮的时候，会生成对应的按钮在 tabbar中，这个函数主要是让这个按钮处于选中状态
		 **同时还要他的 selectindex也对应，这样当选者其它按钮时这个按钮才会弹起来，要不是不会弹起来的，
		 **再移出他的监听器
		 **/
		private function selectid(e:FlexEvent):void
		{
			selected(dataProvicer.length-1);
			tabbar.removeEventListener(FlexEvent.UPDATE_COMPLETE,selectid); 
		}
		/**
		 **此函数主要是用来使tabbar对应的项被选中，并且点其它项的时候还能够弹出来。
		 * */
		private function selected(num:int):void
		{
			tabbar.selectedIndex=num;
		}
		/**
		 **使本窗口最小化~ 然后派发事件让其父监听，同时带有参数  name_str;本窗口的id
		 **/
		private function minstate(e:CloseEvent):void
		{
			var ev:basecom.sjd.events.CloseEvent=new basecom.sjd.events.CloseEvent("min");
			 ev.name_str=e.target.name;
			this.dispatchEvent(ev);
		}
		
	}
}