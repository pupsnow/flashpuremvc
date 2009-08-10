package  com.view.map.eunite.model
{
	import mx.collections.ArrayCollection;
	
	public class UserDataModel
	{
		
		private static var model:UserDataModel;
		[Bindable]
		public var userdata:ArrayCollection=new ArrayCollection([{username:"成都大东",x:200,y:200},
								   {username:"成都毅联",x:300,y:300},
																	])
		public static function getInstance():UserDataModel
		{
			if(model==null)
			 model=new UserDataModel();
			 return model;
			
		}
		
		public function UserDataModel()
		{
			
		}

	}
}