package  basecom.sjd.controls
{
	/*
	class HtmlToolTip
	brief A ToolTip that supports html text.
	 */
	import mx.controls.ToolTip;
	public class HtmlToolTip extends ToolTip
	{
		override protected function commitProperties():void
		{
			super.commitProperties();
	
			textField.htmlText = text
		}
	}
}