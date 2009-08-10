package basecom.render
{
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridListData;

	public class DataGridRowNumRenderer extends Text
	{
		public function DataGridRowNumRenderer()
		{
			super();
			//this.enabled=true;
		}
		
		override public function set data(value:Object):void
		{
			super.data=value;
			
			this.text=String(DataGridListData(listData).rowIndex);
			super.invalidateProperties();
		}
		
	}
}