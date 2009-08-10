package sjd.preloading
{
 import mx.preloaders.DownloadProgressBar;
 import flash.display.Sprite;
import flash.events.ProgressEvent
import flash.events.* 
import flash.text.TextField;
import  mx.events.*;
 public class PreDownload extends DownloadProgressBar
 {
  public var msg:TextField;

  public function PreDownload()
  {
   super();  
   msg=new TextField()
   msg.x=200
   msg.y=200
  addChild(msg)
  }
  override public function set preloader(s:Sprite):void{
  s.addEventListener(ProgressEvent.PROGRESS,prog)
  s.addEventListener(Event.COMPLETE,ecom)
  s.addEventListener(FlexEvent.INIT_COMPLETE,flInC)
 s.addEventListener(FlexEvent.INIT_PROGRESS,flIn)
  }
private function prog(e:ProgressEvent):void{
msg.text=String(int(e.bytesLoaded/e.bytesTotal*100))+" %";
}
private function ecom(e:Event):void{
msg.text="完成了！！！！"
}
private function flInC(e:FlexEvent):void{
msg.text="初始化完毕！"//初始完后要派遣 Complete 事件，不然会停在这里，不会进入程序画面的
dispatchEvent(new Event(Event.COMPLETE))
}
private function flIn(e:FlexEvent):void{
msg.text="开始初始化程序"
}
 }
}