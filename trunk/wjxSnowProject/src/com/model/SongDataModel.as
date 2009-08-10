package  com.model
{
	import mx.collections.ArrayCollection;
	
	public class SongDataModel
	{
		
		
		[Bindable]
		public var songlrcurl:String="";
		private static var Songmodel:SongDataModel;
		
		public static function getInstance():SongDataModel
		{
			if(Songmodel==null)
			Songmodel=new SongDataModel();
			return Songmodel;
			
		}
		function SongDataModel():void
		{
		
		}
		[Bindable]
		public var songlist:ArrayCollection=new ArrayCollection([
		{label:"吻别",person:"张学友",url:"http://127.0.0.1/TalkBook_asp/mp3/吻别.mp3"},
		{label:"十年",person:"陈奕迅",url:"http://127.0.0.1/TalkBook_asp/mp3/十年.mp3"},
		{label:"勇气",person:"梁静茹",url:"http://127.0.0.1/TalkBook_asp/mp3/勇气.mp3"},
		{label:"隐形的翅膀",person:"张韶涵",url:"http://127.0.0.1/TalkBook_asp/mp3/隐形的翅膀.mp3"}
		]);
		
	}
}