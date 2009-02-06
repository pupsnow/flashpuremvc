package org.puremvc.as3.demos.flex.login.model
{
	import flash.events.AsyncErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class ServiceDelegate extends Proxy implements IProxy,IServiceConnect
	{
		private var gateWayUrl:String = "http://192.168.1.158:8080/DemoWeb/messagebroker/amf";
        private var remotingNc:NetConnection;
		private var operationName:String;
		public function ServiceDelegate(proxyName:String=null,data:Object=null)
		{
			super(proxyName,data);
		}
		
		public function connectService(operationName:String=null):void
		{
			remotingNc = new NetConnection();
            remotingNc.connect(gateWayUrl);
            remotingNc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,fault);
            this.operationName = operationName;
		}
		
		public function result(rs:Object):void
		{
			
		}
		public function fault(fl:Object):void  
		{
			
		}
		/**
		 * @param args 发送请求的参数.
		 * 向服务器发送请求
		 */
		public function serverCall(... args:Array):void
		{
			 remotingNc.call(operationName,//"FirstJavaClassRemoteObject.sayHello"
              new Responder(result),args[0]);
		}
	}
}