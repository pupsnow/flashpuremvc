package    
{
import basecom.sjd.controls.NoTruncationUITextField;

import flash.display.DisplayObject;
import flash.text.TextLineMetrics;

import mx.controls.Button;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.events.FlexEvent;
use namespace mx_internal;

public class MultilineButton extends Button
{
     private var lastUnscaledWidth:Number = NaN;
     private var widthChanged:Boolean = true;
	 public function MultilineButton()
	 {
	  	super();
	    addEventListener(FlexEvent.UPDATE_COMPLETE, updateCompleteHandler);
	 }

	 override protected function createChildren():void
	 {
		  if (!textField)
		  {
			   textField = new NoTruncationUITextField();
			   textField.multiline = true;
		  	   textField.wordWrap = true;
			   textField.styleName = this;
			   addChild(DisplayObject(textField));
		  }
		  
	 }
	   private function isSpecialCase():Boolean
	    {
	        var left:Number = getStyle("left");
	        var right:Number = getStyle("right");
	        
	        return (!isNaN(percentWidth) || (!isNaN(left) && !isNaN(right))) &&
	               isNaN(explicitHeight) &&
	               isNaN(percentHeight);
	    }
	 private function measureUsingWidth(w:Number):void
	    {
	        var paddingLeft:Number = getStyle("paddingLeft");
	        var paddingTop:Number = getStyle("paddingTop");
	        var paddingRight:Number = getStyle("paddingRight");
	        var paddingBottom:Number = getStyle("paddingBottom");
	        
	        // Ensure that the proper CSS styles get applied
	        // to the textField before measuring text.
	        // Otherwise the callLater(validateNow) in UITextField's
	        // styleChanged() method can apply the CSS styles too late.
	        textField.validateNow();
	        textField.autoSize = "left";
	
	        // If we know what width to use for word wrapping,
	        // determine the height by wordwrapping to that width.
	        if (!isNaN(w))
	        {
	            textField.width = w - paddingLeft - paddingRight;
	            measuredWidth = Math.ceil(textField.textWidth) + UITextField.TEXT_WIDTH_PADDING;
	            measuredHeight = Math.ceil(textField.textHeight) + UITextField.TEXT_HEIGHT_PADDING;
	            // Round up because embedded fonts can produce fractional values;
	            // if a parent container rounds a component's actual width or height
	            // down, the component may not be wide enough to display the text.
	        }
	
	        // If we don't know what width to use for word wrapping,
	        // determine the measured width and height
	        // from the explicit line breaks such as "\n" and "<br>".
	        else
	        {
	         var oldWordWrap:Boolean = textField.wordWrap;
	            textField.wordWrap = false;
	            
	            measuredWidth = Math.ceil(textField.textWidth) + UITextField.TEXT_WIDTH_PADDING;
	            measuredHeight = Math.ceil(textField.textHeight) + UITextField.TEXT_HEIGHT_PADDING;
	            // Round up because embedded fonts can produce fractional values;
	            // if a parent container rounds a component's actual width or height
	            // down, the component may not be wide enough to display the text.
	            
	            textField.wordWrap = oldWordWrap;
	        }
	        
	        textField.autoSize = "none";
	
	        // Add in the padding.
	        measuredWidth += paddingLeft + paddingRight;
	        measuredHeight += paddingTop + paddingBottom;
	
	        if (isNaN(explicitWidth))
	        {
	            // it could be any size
	            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
	            measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
	        }
	        else
	        {
	            // lock in the content area
	            measuredMinWidth = measuredWidth;
	            measuredMinHeight = measuredHeight;
	        }
	
	    }
	override protected function measure():void
	    {
	        if (isSpecialCase())
	        {
	            if (!isNaN(lastUnscaledWidth))
	            {
	                measureUsingWidth(lastUnscaledWidth);
	            }
	            else
	            {
	                measuredWidth = 0;
	                measuredHeight = 0;
	            }
	            return;
	        }
	
	        measureUsingWidth(explicitWidth);
	        
	    }
	    
	
	    override public function measureText(s:String):TextLineMetrics
	 	{
			  textField.text = s;
			  var lineMetrics:TextLineMetrics = textField.getLineMetrics(0);
			  lineMetrics.width = textField.textWidth + 4;
			  lineMetrics.height = textField.textHeight + 4;
		  return lineMetrics;
		 }
	   private function updateCompleteHandler(event:FlexEvent):void
	    {
	        lastUnscaledWidth = NaN;
	    }
	    override protected function commitProperties():void
		 {
		  super.commitProperties();
		  // if explicitWidth or percentWidth changed, we want to set
		  // wordWrap appropriately before measuring()
		  if (widthChanged)
		  {
		   textField.wordWrap = !isNaN(percentWidth) || !isNaN(explicitWidth);
		   widthChanged = false;
		   this.invalidateDisplayList();
		  }
	 }
	}

}


