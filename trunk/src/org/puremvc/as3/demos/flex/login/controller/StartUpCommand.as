package org.puremvc.as3.demos.flex.login.controller
{
	import org.puremvc.as3.demos.flex.login.view.StartUpMediate;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class StartUpCommand extends SimpleCommand implements ICommand
	{
		public function StartUpCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var app:MyTest = notification.getBody() as MyTest;
		 	facade.registerMediator( new StartUpMediate( app ) );
		}
	}
}