package  basecom.sjd.containers
{
	public class BottomBarAdvanceTab extends AdvanceTabNavigator
	{
		
		import flash.display.DisplayObject;
		import flash.events.Event;
		import flash.events.FocusEvent;
		import flash.events.KeyboardEvent;
		import mx.controls.Button;
		import mx.controls.TabBar;
		import mx.core.Container;
		import mx.core.EdgeMetrics;
		import mx.core.FlexVersion;
		import mx.core.IFlexDisplayObject;
		import mx.core.IInvalidating;
		import mx.core.IProgrammaticSkin;
		import mx.core.IUIComponent;
		import mx.core.mx_internal;
		import mx.events.ItemClickEvent;
		import mx.managers.IFocusManagerComponent;
		import mx.styles.StyleProxy;
		
		use namespace mx_internal;
		public function BottomBarAdvanceTab()
		{
			super();
		}
		override protected function updateDisplayList(unscaledWidth:Number,
	                                                  unscaledHeight:Number):void
	    {
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	
	        var bm:EdgeMetrics = borderMetrics;
	        var vm:EdgeMetrics = viewMetrics;
	        var w:Number = unscaledWidth - vm.left - vm.right;
	
	        var th:Number = tabBarHeight + bm.top;
	        var pw:Number = tabBar.getExplicitOrMeasuredWidth();
	        tabBar.setActualSize(Math.min(w, pw), th);
	        var leftOffset:Number = getStyle("tabOffset");
	
	        switch (getStyle("horizontalAlign"))
	        {
	        case "left":
	            tabBar.move(0 + leftOffset, tabBar.y);
	            break;
	        case "right":
	            tabBar.move(unscaledWidth - tabBar.width + leftOffset, tabBar.y);
	            break;
	        case "center":
	            tabBar.move((unscaledWidth - tabBar.width) / 2 + leftOffset, tabBar.y);
	        }
	    }
		
	}
}