package     basecom.basecomponent.progress //修改为你放这个类的文件夹。。。
{   import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

import mx.events.*;
import mx.preloaders.*;
    
    public class Progress extends Sprite implements IPreloaderDisplay {
        // Define a Loader control to load the IMAGE；
           private var Internal:flash.display.Loader;//内框导入图片
           private var External:flash.display.Loader;//外框导入图片
           private var txt:TextField = new TextField();  //放文字 
           private var External_img:Sprite= new Sprite(); //外部图片   
           private var Internal_img:Sprite= new Sprite();//内部图片
           private var a:String;// 记录下载的百分比
          private  var preloader1:Sprite;
           /* 函数构造器 */
           public function Progress():void
           {    
            super();        
           }
        
        // Specify the event listeners. 事件监听
        public function set preloader(preloader:Sprite):void {
            // Listen for the relevant events
            preloader.addEventListener(ProgressEvent.PROGRESS,handleProgress);    
            //this.preloader1=preloader;
            preloader.addEventListener(Event.COMPLETE, handleComplete);
            preloader.addEventListener(FlexEvent.INIT_PROGRESS,handleInitProgress);
            preloader.addEventListener(FlexEvent.INIT_COMPLETE,handleInitComplete);
        }
        
       
        public function initialize():void {
           
           
            External = new flash.display.Loader();        
            External.contentLoaderInfo.addEventListener(Event.INIT,loader_completeHandler1);
            External.load(new URLRequest("images/beijin.gif"));
                     
        }
        
        private function loader_completeHandler1(e:Event):void
        {
        	 /* 上面是导入内部图片  下面是导入外部框 */
            Internal = new flash.display.Loader();        
            Internal.contentLoaderInfo.addEventListener(Event.INIT,loader_completeHandler);
            Internal.load(new URLRequest("images/progress.gif")); 
        }
        
        // After the SWF file loads, set the size of the Loader control.
        private function loader_completeHandler(event:Event):void {
            //导入结束后给2个定义长和宽。以及定义他们的坐标
            Internal.width = 500;
            Internal.height=15;
            External.width = 500;
            External.height=18;
            addChild(Internal_img);      
            Internal_img.addChild(Internal); 
            addChild(External_img);
            External_img.addChild(External);
            External_img.addChild(txt);
            txt.x=250;
            txt.y=0;
            //外部框架一出来就要全显示  所以不设他的可见行为假。。。
            External_img.x=(this.parent.parent.width-500)/2-1;
            External_img.y=this.parent.parent.height/2-1;
          
            //设置内部图片的可见性为假~~ 就是为了不要它出来就显示~ 要让他随着下载的量显示出来 
            //从而表现出在走动的画面。
            //Internal_img.visible=false; 
            Internal_img.x=(this.parent.parent.width-500)/2;
            Internal_img.y=this.parent.parent.height/2; 
            
            
           /*    var timer2:Timer=new Timer(100,100);
           timer2.addEventListener(TimerEvent.TIMER, ad);
           timer2.addEventListener(TimerEvent.TIMER_COMPLETE,handleInitComplete)
           timer2.start()   */
            
          }
          
          
           private function ad(evt:TimerEvent):void
		     { 
		     	a=int( evt.target.currentCount/100*500)+"%";
            Internal_img.scaleX= evt.target.currentCount/100;
            txt.text = "加载"+a;  
		     	
		     }
		 private function handleProgress(e:ProgressEvent):void {
 
          a=(int(e.bytesLoaded/e.bytesTotal*100))+"%";
            Internal_img.scaleX=e.bytesLoaded/e.bytesTotal;
            txt.text = "加载"+a;   
        }
        
        private function handleComplete(event:Event):void {
        	
        }
        
        private function handleInitProgress(event:Event):void {
        
        }
        
        private function handleInitComplete(event:Event):void {

            var timer:Timer = new Timer(1000,1);
            timer.addEventListener(TimerEvent.TIMER, dispatchComplete);
            timer.start();        
        }
    
        private function dispatchComplete(event:TimerEvent):void         {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        // Implement IPreloaderDisplay interface
        public function get backgroundColor():uint {
            return 0;
        }
        
        public function set backgroundColor(value:uint):void {
        }
        
        public function get backgroundAlpha():Number {
            return 0;
        }
        
        public function set backgroundAlpha(value:Number):void {
        }
        
        public function get backgroundImage():Object {
            return undefined;
        }
        
        public function set backgroundImage(value:Object):void {
        }
        
        public function get backgroundSize():String {
            return "";
        }
        
        public function set backgroundSize(value:String):void {
        }
    
        public function get stageWidth():Number {
            return 200;
        }
        
        public function set stageWidth(value:Number):void {
        }
        
        public function get stageHeight():Number {
            return 200;
        }
        
        public function set stageHeight(value:Number):void {
        }
    }
}
