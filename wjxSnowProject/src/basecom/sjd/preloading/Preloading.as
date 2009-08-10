package sjd.preloading
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
    
    public class Preloading extends Sprite implements IPreloaderDisplay {
        // Define a Loader control to load the SWF file.
          private var dpbImageControl:flash.display.Loader;
           private var txt:TextField = new TextField();
           private  var mySprite:Sprite = new Sprite();
           private  var mySprite2:Sprite = new Sprite();
           private var label:Sprite= new Sprite();
           private var label2:Sprite= new Sprite();
           private var b:Sprite= new Sprite();
           private var a:int;
           private var c:Number;
            private var d:Number;
        public function Preloading()         {    
            super();        
        }
        
        // Specify the event listeners.
        public function set preloader(preloader:Sprite):void {
            // Listen for the relevant events
            preloader.addEventListener(ProgressEvent.PROGRESS,handleProgress);    
            preloader.addEventListener(Event.COMPLETE, handleComplete);
            preloader.addEventListener(FlexEvent.INIT_PROGRESS,handleInitProgress);
            preloader.addEventListener(FlexEvent.INIT_COMPLETE,handleInitComplete);
        }
        
        // Initialize the Loader control in the override         // of IPreloaderDisplay.initialize().
        public function initialize():void {
            dpbImageControl = new flash.display.Loader();        
            dpbImageControl.contentLoaderInfo.addEventListener(Event.COMPLETE,loader_completeHandler);
          // dpbImageControl.load(new URLRequest("beijin.gif")); 
                     
        }

        // After the SWF file loads, set the size of the Loader control.
        private function loader_completeHandler(event:Event):void {
            
            //dpbImageControl.width = 500;
            //dpbImageControl.height= 500;
            //dpbImageControl.x =100;
            //dpbImageControl.y = 50;
               
            this.addChild(mySprite2); 
            mySprite2.addChild(dpbImageControl); 
            mySprite2.width=500;
            mySprite2.height=500;
          mySprite2.x=(this.parent.parent.width-500)/2;
           mySprite2.y=(this.parent.parent.height-500)/2;
           
             label.x=mySprite2.x;
            label.y= mySprite2.y+500+10;
            label2.x= mySprite2.x;
            label2.y= mySprite2.y+500+10;
           
            addChild(label2);
            addChild(label);
            label.addChild(b);
            label2.addChild(txt);
            txt.x=240;
            txt.y=5;
           
            label2.graphics.beginFill(0xaaaaa1,0.5);
           
            label2.graphics.moveTo(0,0);
            label2.graphics.lineTo(500,0);
            label2.graphics.lineTo(500,8);
            label2.graphics.lineTo(0,8);
            label2.graphics.endFill();
            label.graphics.lineStyle(0.8,0xcccccc,1,false); 
            label.graphics.drawRoundRectComplex(0, 0, 500, 8,0,0,0,0);
            var ds:RectangularDropShadow = new RectangularDropShadow();
		    ds.color = 0x000000;
		    ds.angle =0;
		    ds.alpha =1;
		    ds.distance =1;
		    ds.tlRadius = ds.trRadius = ds.blRadius = ds.brRadius =0;
		    ds.drawShadow(label.graphics,0,0,500,8);
           //label.graphics.endFill();
          
           
           
            var timer2:Timer=new Timer(100,100);
           timer2.addEventListener(TimerEvent.TIMER, ad);
           timer2.addEventListener(TimerEvent.TIMER_COMPLETE,handleInitComplete)
           timer2.start()   
           
           
           }    
        
        // Define empty event listeners.
               
     private function ad(evt:TimerEvent):void
     {    
         a=int( evt.target.currentCount/100*500);
             txt.text = "加载"+(a/500)*100+"%";
          var colors:Array = [0x000000, 0xffffff];
            var  alphas :Array= [0.5, 0.85];
            var  ratios:Array = [125, 125];
            var  matri:Matrix = new Matrix();
               matri.createGradientBox(-5,-3,0,0,0 );
            var  spreadMethod:String =SpreadMethod.REPEAT   ;
            var interpolationMethod:String =InterpolationMethod.RGB;
            var  focalPointRatio:Number =0;
            //b.graphics.clear();
            b.graphics.beginGradientFill("linear", colors, alphas, ratios, matri, 
            spreadMethod, interpolationMethod, focalPointRatio);
            //b.graphics.lineStyle(0,0xffffff,0,false,"normal","ROUND","ROUND",1);
            b.graphics.drawRoundRectComplex(0,0,a,6,0,0,0,0);
          
           var rd:RectangularDropShadow = new RectangularDropShadow();
		    rd.color = 0x000001;
		    rd.angle =90;
		    rd.alpha = 1;
		    rd.distance =1;
		    rd.tlRadius = rd.trRadius = rd.blRadius = rd.brRadius =0;
		    rd.drawShadow(b.graphics,0,0,500,7);
          
          
                  }
        
        
        private function handleProgress(event:ProgressEvent):void {
      
          
            
        
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
