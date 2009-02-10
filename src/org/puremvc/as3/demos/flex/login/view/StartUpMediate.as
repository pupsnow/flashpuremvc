package org.puremvc.as3.demos.flex.login.view
{
	import fl.controls.TextInput;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.puremvc.as3.demos.flex.login.model.DataSource;
	import org.puremvc.as3.demos.flex.login.model.emu.Notification;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class StartUpMediate extends Mediator implements IMediator
	{
		public static const NAME:String = 'StartUpMediator';
		public var _mybt:SimpleButton;
		public var _myha:MyMovie;
		private var i:int = 0;
		[Bindable]
		private var data:DataSource = DataSource.getInstance();
		public function StartUpMediate(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_mybt = viewComponent.getChildByName("btn") as SimpleButton;
			_myha = viewComponent.getChildByName("myha") as MyMovie;
			_mybt.addEventListener(MouseEvent.CLICK,clickHandler);
			
		}
		private function clickHandler(e:MouseEvent):void
		{
			var a:TextField = new TextField();
			var name_txt:TextInput = _myha.getChildByName("name_txt") as TextInput ;
			var sex_txt:TextInput = _myha.getChildByName("sex_txt") as TextInput ;
			a.text = name_txt.text + sex_txt.text + data.testdata;
			a.x = 30;
			a.y = 10*i+30;
			e.target.parent.addChild(a);
			i++;
			
			this.sendNotification(Notification.STARTCONNECT);
			
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
					var name_txt:TextInput = _myha.getChildByName("name_txt") as TextInput ;
					name_txt.text = data.testdata;
					break;
            }
        }
		 protected function get view():MyTest
		{
            return viewComponent as MyTest;
        }
	}
}