package  com.view.map.eunite.control
{
	import eunite.model.Product;
	
	import flash.events.Event;

	public class ProductionListEvent extends Event
	{
		
		public static const ADD_PRODUCT:String = "addProduct";
	    public static const DUPLICATE_PRODUCT:String = "duplicateProduct";
	    public static const REMOVE_PRODUCT:String = "removeProduct";
	    public static const PRODUCT_QTY_CHANGE:String = "productQtyChange";
	        public var product:Product;
		public function ProductionListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}