package  com.view.map.eunite.model
{  
		[Bindable]
	public class Production
	{
		
		private static var model:Production;
		public static function getInstance():Production
        {
            if (model == null)
                model = new Production(); 
            return model;
       	}
		public function Production()
		{
		}

	}
}