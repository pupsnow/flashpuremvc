package basecom.render
{
	import mx.managers.ILayoutManagerClient;
	import mx.styles.IStyleClient;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.CheckBox;
	import mx.core.IDataRenderer;
	import flash.events.MouseEvent;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.containers.HBox;
	import flash.events.Event;
    [Event (name="CheckChange")]
	public class GridCheckRenderer extends HBox
	implements IDataRenderer,IDropInListItemRenderer, ILayoutManagerClient, IListItemRenderer, IStyleClient
	{
		private var _item:Object
		private var _listData:DataGridListData;
		protected var checkBox:CheckBox
		public var selected:String="false";
		[Bindable("dataChange")]
		
		public function GridCheckRenderer()
		{
			super();
			this.setStyle("horizontalAlign","center");	
		    this.setStyle("paddingLeft",10);
		    checkBox=new CheckBox();
		    checkBox.buttonMode=true;
		    this.addChild(checkBox);
		    checkBox.addEventListener(MouseEvent.CLICK,opSelected);
		   // checkBox.addEventListener(Event.CHANGE,CheckSelected);
		    this.addEventListener(MouseEvent.CLICK,chselect);
		}
		override public function initialize():void
		{
		    selected=checkBox.selected.toString();
		   
		}
		private function CheckSelected(e:Event):void
		{
			if(e.target==checkBox)
			{
			 this.parentDocument.dispatchEvent(new Event("CheckChange"));
			}
		}
		private function chselect(e:MouseEvent):void
		{
			/* if(e.target!=checkBox)
			{
				if(checkBox.selected==true)
				{
					checkBox.selected=false;
				}
				else if(checkBox.selected==false)
				{
					checkBox.selected=true;
				}
				_item["select"]=String(checkBox.selected);
			  
			} */
		}
		private function opSelected(e:MouseEvent):void
		{
		   _item["select"]=String(checkBox.selected);
		}
		
		override public function set data(value:Object):void
		{
			if(value!=null)
			{
				_item=value;
				if(_item["select"].toString()=="true")
				{
					checkBox.selected=true; 
				}
				else
				{
					checkBox.selected=false; 
				}
			}
		}
		
		override public function get data():Object
		{
			return _item;
		}
		
		public function set listData(value:BaseListData):void
		{
			_listData=DataGridListData(value);
		}
		
		public function get listData():BaseListData
		{
			return _listData;
		}
	}
}