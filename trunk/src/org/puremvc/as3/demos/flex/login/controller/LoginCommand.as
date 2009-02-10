package org.puremvc.as3.demos.flex.login.controller
{
	import org.puremvc.as3.demos.flex.login.model.proxy.BaseConnectProxy;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.observer.*;
    
    /**
     * Create and register <code>Proxy</code>s with the <code>Model</code>.
     */
    public class LoginCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
            var loginproxy:BaseConnectProxy = facade.retrieveProxy(BaseConnectProxy.NAME) as BaseConnectProxy;
            	loginproxy.connectservice();
        }
    }
}