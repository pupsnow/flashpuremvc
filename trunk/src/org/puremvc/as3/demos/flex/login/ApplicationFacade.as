package org.puremvc.as3.demos.flex.login
{
	import org.puremvc.as3.demos.flex.login.controller.StartUpCommand;
	import org.puremvc.as3.demos.flex.login.model.emu.Notification;
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade implements IFacade
	{
		/**
		 * Singleton Application Facade Method. 
		 */
		 public static function getInstance():ApplicationFacade{
		 	if( instance == null )instance = new ApplicationFacade();
		 	return instance as ApplicationFacade;
		 }
		
		/**
		 * Login 
		 */
		 public function startUp(app:MyTest):void{
		 	sendNotification( Notification.STARTUP, app );
		 }
		 /**
		 * 
		 */
		 override protected function initializeController():void{
		 	super.initializeController();
		 	registerCommand( Notification.STARTUP,StartUpCommand );
		 }
	}
}