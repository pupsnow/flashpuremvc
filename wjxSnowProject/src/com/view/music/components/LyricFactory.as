package  com.view.music.components
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	[Event(name="complete")]
	public class LyricFactory extends EventDispatcher
	{
		
		private static var fac:LyricFactory;
		
		public static function getInstace():LyricFactory
		{
			if(fac==null)
			fac=new LyricFactory();
			return fac;
			
		}
		public function LyricFactory():void
		{
			super();
		}
		public  function create(lyric:String):LyricModel{
			var ly:LyricModel = new LyricModel();
			var itemRegex:RegExp =
			 /\[([0-9]{1,2}:[0-9]{1,2}(\.[0-9]{0,3})?)\](\[([0-9]{1,2}:[0-9]{1,2}(\.[0-9]{0,3})?)\](\[([0-9]{1,2}:[0-9]{1,2}(\.[0-9]{0,3})\]))?)?(.*)?/g;
			
			var matchItems:Array = lyric.match(itemRegex);
			// trace(matchItems.toString());
			for(var i:int=0;i<matchItems.length;i++){
				trace(matchItems[i] as String);
				var t1:String = (matchItems[i] as String).replace(itemRegex,'$1');
				 trace(t1);
				var t2:String = (matchItems[i] as String).replace(itemRegex,'$4');
				trace(t2);
				var t3:String = (matchItems[i] as String).replace(itemRegex,'$6');
				 trace(t3);
				var txt:String = (matchItems[i] as String).replace(itemRegex,'$9');
				trace(txt);
				var item:LyricItemModel = new LyricItemModel();
				//var date:Date = new Date()
				item.time = LyricFactory._parseTime(t1);
				item.text = txt;
				ly.items.push(item);
				if(t2!=null&&t2!=''){
					item = new LyricItemModel();
					item.time = LyricFactory._parseTime(t2);
					item.text = txt;
					ly.items.push(item);
				}
				
			}
			
			var func_sort:Function = function(a:LyricItemModel,b:LyricItemModel):int{
				if(a.time>b.time)
					return 1
				else(a.time<b.time)
					return -1;
				
				return 0;
			}
			
			ly.items.sort(func_sort);
			dispatch();
			return ly
		}
		
		private static function _parseTime(time:String):Number{ //00:57.13
			var min:int = int(time.split(':')[0]);
			var sec:int = int((time.split(':')[1] as String).split('.')[0]);
			var miSec:int = int((time.split(':')[1] as String).split('.')[1]);
			return min*60*1000+sec*1000+miSec;
		}
	private function dispatch():void
	{
		this.dispatchEvent(new Event("complete"));
	}
		
	}
}