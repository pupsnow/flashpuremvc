package org.puremvc.as3.demos.flex.login.model.proxy
{
	import org.puremvc.as3.demos.flex.login.model.DataSource;
	import org.puremvc.as3.demos.flex.login.model.IServiceConnect;
	import org.puremvc.as3.demos.flex.login.model.ServiceDelegate;
	import org.puremvc.as3.interfaces.IProxy;
	public class BaseConnectProxy extends ServiceDelegate implements IProxy,IServiceConnect
	{
		private static const NAME:String = "BaseConnectProxy";
        public function BaseConnectProxy(data:Object=null)
		{
			super(NAME,data);
			this.connectService("FirstJavaClassRemoteObject.sayHello");
			this.serverCall("nihao");
		}
     	override  public function result(rs:Object):void
		{
			trace("ok2");
			DataSource.getInstance().testdata = rs.toString();
		}
		override public function fault(fl:Object):void
		{
			trace("error");
			
		}

 }
}

