package org.puremvc.as3.demos.flex.login.view
{
	import org.puremvc.as3.demos.flex.login.model.emu.Notification;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class LoadSwfMediate extends Mediator implements IMediator
	{
		public static const NAME:String = 'LoadSwfMediate';
		
		public function LoadSwfMediate(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function listNotificationInterests():Array 
        {
            return [ 
					Notification.DATACHANGE
					];
        }
        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case Notification.DATACHANGE:
					trace("change")
					break;
            }
        }
		 protected function get view():LoadSWF
		{
            return viewComponent as LoadSWF;
        }
	}
}