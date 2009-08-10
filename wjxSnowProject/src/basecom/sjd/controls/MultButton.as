package  basecom.sjd.controls
/**
 * 可以换行的button
 * 并且在双击的时候可以编辑上面的显示文字**/
{
	import flash.display.DisplayObject;
	
	import mx.controls.Button;
	import mx.controls.Text;
	import mx.core.UITextField;

	public class MultButton extends Button
	{
	
	private var text:Text;
	private var texte:String="";
	 public function get textee():String
    {
        return texte;
    }

    /**
     *  @private
     */
		public function set textee(value:String):void
		{
		      texte = value;    
		}
		public function MultButton()
		{	
			//TODO: implement function
			super();
		}
		 protected  override  function createChildren():void
		 {
		 	
	    	super.createChildren();
	    	text=new Text();
	        this.addChildAt(text,0);     
	       /*  if (!textField)
			{
			textField = new UITextField();
			textField.styleName = this;
		    this.addChild(DisplayObject(textField));
			} 
			
			super.textField.multiline = true;
			super.textField.wordWrap = true;
			super.createChildren(); */
			 
          } 
          
		 protected override function updateDisplayList(unscaledWidth: Number, 
				unscaledHeight:Number):void 
				{
						
				 super.updateDisplayList(unscaledWidth, unscaledHeight);
				 text.setActualSize(unscaledWidth,unscaledHeight);
				 //super.textField.setActualSize(unscaledWidth,unscaledHeight);
				// super.textField.move(x,y);
				//text.move(x, y);

    			 }
      	override protected function commitProperties():void
	        { 
			  super.commitProperties();
			  // removeChild(DisplayObject(textField));
			 // super.textField.wordWrap=true;
			 // super.textField.multiline=true;
		     this.text.text=texte;
		      }
	}
}
