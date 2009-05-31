package com.eto.phoenix.util
{ 
    import flash.net.LocalConnection; 
    public class MemoryRelease 
    { 
        public static function excute():void 
        { 
            try 
            { 
                var lc1:LocalConnection = new LocalConnection(); 
                var lc2:LocalConnection = new LocalConnection(); 
                lc1.connect('*&%&#&%('); 
                lc2.connect('(*^&^%&@@');
			} 
            catch (e:Error) 
            { 
            } 
        } 
    } 
}