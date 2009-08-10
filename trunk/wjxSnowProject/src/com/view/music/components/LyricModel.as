package com.view.music.components
{   [Bindable]
	public class LyricModel
	{
		public var title:String;
		public var artist:String;
		public var album:String;
		public var publish:String;
		public var language:String;		
		public var items:Array=new Array();; //typeof: LyricItemModel
		
		/* private var model:LyricModel;
		public static function getInstance():LyricModel
		{
			if(model==null)
			model=new LyricModel();
			return model;
			
		} */
		public function LyricModel():void{
			this.items = new Array();	
		}
	}
}