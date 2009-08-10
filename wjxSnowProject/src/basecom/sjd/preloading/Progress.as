package  sjd.preloading//修改为你放这个类的文件夹。。。
{   import flash.display.*;
    import flash.utils.*;
    import flash.events.*;
    import flash.net.*;
    import mx.preloaders.*;    
    import mx.events.*;
    import flash.text.*;
    import flash.events.ProgressEvent;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import mx.graphics.RectangularDropShadow;
    
    public class Progress extends Sprite implements IPreloaderDisplay {
        // Define a Loader control to load the IMAGE；
           private var Internal:flash.display.Loader;//内框导入图片
           private var External:flash.display.Loader;//外框导入图片
           private var txt:TextField = new TextField();  //放文字 
           private var External_img:Sprite= new Sprite(); //外部图片   
           private var Internal_img:Sprite= new Sprite();//内部图片
           private var a:String;// 记录下载的百分比
           /* 函数构造器 */
           public function Progress():void
           {    
            super();        
           }
        
        // Specify the event listeners. 事件监听
        public function set preloader(preloader:Sprite):void {
            // Listen for the relevant events
            preloader.addEventListener(ProgressEvent.PROGRESS,handleProgress);    
            preloader.addEventListener(Event.COMPLETE, handleComplete);
            preloader.addEventListener(FlexEvent.INIT_PROGRESS,handleInitProgress);
            preloader.addEventListener(FlexEvent.INIT_COMPLETE,handleInitComplete);
        }
        
        // Initialize the Loader control in the override         // of IPreloaderDisplay.initialize().
        public function initialize():void {
            Internal = new flash.display.Loader();        
            Internal.contentLoaderInfo.addEventListener(Event.COMPLETE,loader_completeHandler);
           Internal.load(new URLRequest("../assets/min.png")); 
            /* 上面是导入内部图片  下面是导入外部框 */
            External = new flash.display.Loader();        
            External.contentLoaderInfo.addEventListener(Event.COMPLETE,loader_completeHandler);
            External.load(new URLRequest("../assets/min.png"));
                     
        }

        // After the SWF file loads, set the size of the Loader control.
        private function loader_completeHandler(event:Event):void {
            //导入结束后给2个定义长和宽。以及定义他们的坐标
            Internal.width = 500;
            Internal.height=15;
            External.width = 500;
            External.height=18;
            this.addChild(Internal_img);      
            Internal_img.addChild(Internal); 
            this.addChild(External_img);
            External_img.addChild(External);
            External_img.addChild(txt);
            txt.x=250;
            txt.y=0;
            //外部框架一出来就要全显示  所以不设他的可见行为假。。。
            External_img.x=(this.parent.parent.width-500)/2-1;
            External_img.y=this.parent.parent.height/2-1;
          
            //设置内部图片的可见性为假~~ 就是为了不要它出来就显示~ 要让他随着下载的量显示出来 
            //从而表现出在走动的画面。
           // Internal_img.visible=false; 
            Internal_img.x=(this.parent.parent.width-500)/2;
            Internal_img.y=this.parent.parent.height/2;
        }
        private function handleProgress(e:ProgressEvent):void {
         a=(int(e.bytesLoaded/e.bytesTotal*100))+" %"
          //a=int( evt.target.currentCount/1000*500);
        //Internal_img.visible=true;
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
