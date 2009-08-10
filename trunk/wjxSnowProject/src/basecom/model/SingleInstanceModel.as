package basecom.model
{
	import basecom.render.ListRepeaterRenderer;
	
	public class SingleInstanceModel
	{
		
		
		private static var instance:SingleInstanceModel;
		public static function getInstance():SingleInstanceModel
		{
			if(instance==null) instance = new SingleInstanceModel();
			return instance;
		}
		public function SingleInstanceModel()
		{
			
		}
		public var logic:ListRepeaterRenderer;
	}
}