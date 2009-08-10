package  components.roguedevelopment.objecthandles
{
       import flash.events.Event;
       import flash.display.BitmapData;
       import flash.display.Bitmap;
       import flash.events.IOErrorEvent;
       import mx.controls.Image;

       public class ImageHandle extends Handle
       {

               public var _source:String = "";

               private var _ldr:Image;
               private var _bitmapData:BitmapData;

               public function ImageHandle(src:String)
               {
                       super();
                       _source = src;
                       load();
               }

               private function load():void{

                       _ldr = new Image();
                       _ldr.autoLoad = false;
                       _ldr.source = _source;
                       _ldr.addEventListener(Event.COMPLETE, finishedLoading);
                       _ldr.addEventListener(IOErrorEvent.IO_ERROR, errorLoading);
                       _ldr.load();

               }

               private function finishedLoading(event:Event):void{

                       _bitmapData = (_ldr.content as Bitmap).bitmapData.clone();
                       draw();
               }

               private function errorLoading(event:Event):void{
                       super.draw();
               }

               protected override function draw():void{

                       if(_bitmapData != null){

                               width = _bitmapData.width;
                               height = _bitmapData.height;

                               graphics.clear();
                               graphics.beginBitmapFill(_bitmapData);
                               graphics.drawRect(0,0, _bitmapData.width, _bitmapData.height);

                       }

               }

       }
}