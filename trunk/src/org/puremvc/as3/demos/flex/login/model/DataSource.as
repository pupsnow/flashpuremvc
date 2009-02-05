package org.puremvc.as3.demos.flex.login.model
{
	import org.puremvc.as3.demos.flex.login.model.emu.Notification;
	import org.puremvc.as3.patterns.observer.Notifier;
	
	public class DataSource extends Notifier 
	{
		private static var source:DataSource
		public static function getInstance():DataSource
		{
			if(source==null) source = new DataSource();
			return source;
		}
		public function DataSource()
		{
		}
	    private var _testdata:String= "test";
	    public function set testdata(value:String):void
	    {
	    	if(_testdata!=value)
	    	{
	    	_testdata = value;
	    	this.sendNotification(Notification.DATACHANGE);
	    	}
	    }
	    public function get testdata():String
	    {
	    	return _testdata;
	    }
	    
	}
}