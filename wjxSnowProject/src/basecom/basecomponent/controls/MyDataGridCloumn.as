package  basecom.basecomponent.controls
{
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import basecom.render.DataGridClounmRenderer;

	public class MyDataGridCloumn extends DataGridColumn
	{
		public function MyDataGridCloumn(columnName:String=null)
		{
			super(columnName);
			this.itemRenderer=new ClassFactory(DataGridClounmRenderer);
		}
	}
}