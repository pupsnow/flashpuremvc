package utils
{
	public class GBToUTF8
	{
		import flash.system.System;
		
	public static function ToUTF8(source:String):String
	{ 
			var target:String=""; 
			for(var i:Number=0;i<source.length;i++)
			{ 
			trace(source.charAt(i)+'\n'+source.charCodeAt(i))
				
				target+=escape(source.charAt(i));
			//target+=codeTohex(source.charCodeAt(i)); 
			} 
			trace(target);
			//System.useCodePage=true; 
			target=unescape(target); 
			//System.useCodePage=false; 
			return target; 
		} 
	private static function codeTohex(code:Number):String
	{ 
			var low:Number=code%16; 
			var high:Number=(code-low)/16; 
			return "%"+hex(high)+hex(low); 
	} 
	private static function hex(code:Number):String
	{ 
			switch(code)
			{ 
			case 10: 
			return "A"; 
			break; 
			case 11: 
			return "B"; 
			break; 
			case 12: 
			return "C"; 
			break; 
			case 13: 
			return "D"; 
			break; 
			case 14: 
			return "E"; 
			break; 
			case 15: 
			return "F"; 
			break; 
			default: 
			return String(code); 
			break; 
			} 
    }
    
    
		public static function ANSI2UTF(ANSI:String):String
		 {
		 var temp:Boolean=!(!System.useCodePage);
		 System.useCodePage = true;
		 var code:String = "";
		 for (var i:Number = 0; i<ANSI.length; i++) {
		   code += "%"+ANSI.charCodeAt(i).toString(16);
		 }
		 var result:String = unescape(code);
		 System.useCodePage = temp;
		 return result;
		}

		
	}
}