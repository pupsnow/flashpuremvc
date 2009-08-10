package   com.model
{
	import mx.containers.TitleWindow;
	
	public class ContentModel
	{
		private static var model:ContentModel;
		public static function getInstance():ContentModel
		{
			if(model==null)
			model=new ContentModel();
			return model;
		}
		function ContentModel():void
		{
			
		}
		/*  留言*/
		[Bindable]
		public var xml:XML;
		[Bindable]
		public var username:String;
		[Bindable]
		public var sex:String;
		[Bindable]
		public var email:String;
		[Bindable]
		public var content:String;
		[Bindable]
		public var isadminsee:String;
		
		/*回复字段  */
		[Bindable]
		public var reply:String;
		[Bindable]
		public var replydate:String;
		[Bindable]
		public var time:String;
		[Bindable]
		public var selectindex:int=0;
		/* 登陆 */
		[Bindable]
		public var namecode:String;
		[Bindable]
		public var password:String;
		[Bindable]
		public var loginLevel:String="0";
		[Bindable]
		public var longstrin:TitleWindow;
		[Bindable]
		public var closelogin:Function;
		[Bindable]
		public var ip:String;
		/* qqshow */
		[Bindable]
		public var qqshowData:Array=new Array();
		
		
	}
}