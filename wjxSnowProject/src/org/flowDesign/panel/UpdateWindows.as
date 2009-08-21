package org.flowDesign.panel
{
	import mx.containers.TitleWindow;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.flowDesign.data.IProperty;

	public class UpdateWindows extends TitleWindow implements IUpdateComponent
	{
		public function UpdateWindows()
		{
			this.showCloseButton = true;
			this.addEventListener(CloseEvent.CLOSE,Executelogout);
		}
		
		private function Executelogout(e:CloseEvent):void
		{
			logout();
		}
		public function sumbit():void
		{
		}
		
		public function getUpdateConidtions():IProperty
		{
			return null;
		}
		
		public function clearConidtions():void
		{
		}
		
		public function logout():void
		{
			PopUpManager.removePopUp(this);
		}
		
	}
}