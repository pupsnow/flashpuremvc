package   com.view.map.eunite.util
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class UserLocale {
				
		public static const locale:Array = ["zh_CN","en_US","zh_HK"];		
		public static const LOCALE_ZH_CN:int = 0;
		public static const LOCALE_EN_US:int = 1;	
		public static const LOCALE_ZH_HK:int = 2;		
		private static var localePointer:int = LOCALE_ZH_CN;		
		private static var XMLLoader:Array = new Array(locale.length);
		public static var obj:UserLocale = new UserLocale();
		[Bindable]
		public var i18n:XML;		

		public function UserLocale(){
						
			for(var i:int=0; i < locale.length; i++){
				var url:String = "assets/locale/LabelMsg_" + locale[i] + ".xml";
				var requestURL:URLRequest = new URLRequest(url);
				XMLLoader[i] = new URLLoader(requestURL);
				XMLLoader[i].addEventListener("complete", localeXMLLoaded);	
			}
			
		}
						
		public function localeXMLLoaded(evtObj:Event):void { 			
        	trace(evtObj);
        	if(XMLLoader[localePointer].data != null){
        		obj.i18n = XML(XMLLoader[localePointer].data);
        	}
		} 
			
		static public function setLocale(idx:int):void {						
			if(localePointer == idx){
				return ; 
			}
			localePointer = idx;
			obj.i18n = XML(XMLLoader[idx].data);
			return;										
		}    				
			
		static public function getLocale():int{			
			return localePointer;			
		}	
								
	}
}