package org.puremvc.as3.demos.flex.login.model.proxy
{
	
	import org.puremvc.as3.demos.flex.login.model.DataSource;
	import org.puremvc.as3.demos.flex.login.model.IServiceConnect;
	import org.puremvc.as3.demos.flex.login.model.ServiceDelegate;
	import org.puremvc.as3.interfaces.IProxy;
	public class BaseConnectProxy extends ServiceDelegate implements IProxy,IServiceConnect
	{
		public static const NAME:String = "BaseConnectProxy";
        public function BaseConnectProxy(data:Object=null)
		{
			super(NAME,data);
		}
		
		public function connectservice():void
		{
			this.connectService("FirstJavaClassRemoteObject.sayHello");
			this.serverCall("nihao");
		}
     	override  public function result(rs:Object):void
		{
			trace(rs is Array);
			var a:Array = rs as Array;
			DataSource.getInstance().testdata = a.length.toString() ;
		}
		override public function fault(fl:Object):void
		{
			trace("error");
			
		}

 }
}

