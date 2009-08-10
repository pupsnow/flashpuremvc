package basecom.sjd.controls.treeClasses
{    /*
	class AdvanceTreeItemRenderer
	 brief The ItemRenderer of AdvanceTree, add function calculateMaxPosition
	 */
	import mx.controls.treeClasses.TreeItemRenderer;
	import basecom.sjd.controls.AdvanceTree;
	import basecom.sjd.core.sjd_internal;	
	use namespace sjd_internal;
	public class AdvanceTreeItemRenderer extends TreeItemRenderer{
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//////////////////////////////////////////////////////////////////////////
			//let the label show all the text
			if(label){
				label.setActualSize(label.textWidth + 4, measuredHeight);
			}
			//////////////////////////////////////////////////////////////////////////
			
		}
		
		sjd_internal function calculateMaxPosition():void{
			if(label){
				//notify Tree's MaxHorizontalPoisition
				if(this.owner && this.owner is AdvanceTree){
					(this.owner as AdvanceTree).setMaxWidth(label.x + label.textWidth + 4);
				}
			}
		}
		
		
	}

}
