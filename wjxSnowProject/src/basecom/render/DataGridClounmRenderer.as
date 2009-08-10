package basecom.render
{
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridListData;

	public class DataGridClounmRenderer extends Text
	{
		public function DataGridClounmRenderer()
		{
			super();
			//this.enabled=true;
		}
		
		override public function set data(value:Object):void
		{
			super.data=value;
			if(value!=null)
			{
				this.text=value[DataGridListData(listData).dataField]
			}
			
			super.invalidateProperties();
		}
		
	}
}