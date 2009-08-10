package  com.model
{
	import mx.collections.ArrayCollection;
	
	public class ManiModel
	{
		private static var model:ManiModel;
		public static function getInstance():ManiModel
        {
            if (model == null)
                model = new ManiModel(); 
            return model;
       	}
        
        function ManiModel() 
       	{

       	}
       	[Bindable]
       	public var arrayData:ArrayCollection=new ArrayCollection();
       	[Bindable]
       	public var num1:Number=0;//点击“我的电脑"一次 赠加1 当点击出来的弹出框全部关闭后 又回到0
       	
       	[Bindable]
       	public var num2:Number=0;//点击"网上邻居"一次 赠加1 当点击出来的弹出框全部关闭后 又回到0
       	
       	[Bindable]
       	public var num3:Number=0;//点击“浏览器”一次 赠加1 当点击出来的弹出框全部关闭后 又回到0
       	
	}
}