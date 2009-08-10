package basecom.basecomponent.skin
{
	import flash.display.Graphics;
	
	import mx.skins.RectangularBorder;

	public class ContainNewSkin extends RectangularBorder
	{
		public function ContainNewSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var gOne:Graphics = this.graphics;
			var gTwo:Graphics = this.graphics;
			var bgColor:uint = this.getStyle("backgroundColor");
			 // gOne.beginFill(bgColor,1.0); 
		      gOne.lineStyle(2,0x157BBB,1); 
		      gOne.drawRoundRectComplex(0,0,unscaledWidth,unscaledHeight,5,5,5,5);       
		      gOne.endFill(); 
		      
		      
		      gTwo.lineStyle(2,0xcccccc,1); 
		      gTwo.drawRoundRectComplex(2,2,unscaledWidth-4,unscaledHeight-4,5,5,5,5); 
		      gTwo.endFill(); 
		      gTwo.beginFill(0x00ABE2,1); 
		      gTwo.lineStyle(2,0x157BBB,1); 
		      gTwo.drawRoundRectComplex(4,4,unscaledWidth-8,unscaledHeight-8,5,5,5,5); 
		      gTwo.endFill();     

		}
		
	}
}