package selfdesizenUI
{
	import flash.display.*;  
	import fl.core.UIComponent;
    //命名空间;  
    use namespace klstudio_internal;  
      
    //设置组件图标;  
    [IconFile("StringUtilIcon.png")]  
      
    public class StringUtilComponent extends Sprite{  
        //定义组件显示框;  
        //组件里已有的显示元素必须用命名空间作开头;  
        klstudio_internal var boundingBox_mc:MovieClip;  
        //定义LRC解析器;  
        private var util:StringUtil;  
        public function StringUtilComponent(){            
            //移除组件显示框;  
            boundingBox_mc.visible = false;  
            addChild(boundingBox_mc);  
            boundingBox_mc = null;            
        }         
    }     

}