package  org.wjx.controls.workFlow.workFlowClasses{
    import flash.events.*;
    
    import mx.core.UIComponent;
    import mx.events.*;

    public class TemporaryLine extends UIComponent {
       /**
        * //线对像
        */       
       
       private var _lineChild:UIComponent;
     
      public function TemporaryLine() {
           //线对像
          _lineChild = new UIComponent();
          this.addChild(_lineChild);
          this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
           
        }
        /**
         *  //开始节点
         */        
       
        private var _startX:int=0;
        private var _startY:int=0;
       
        public function  set startX(startX:int):void{
        this.middleX=(startX+this.endX)/2+100;
        this._startX=startX;
        }
        
      	public function get startX():int{
        return this._startX;
        }
        
        
        public function set startY(startY:int):void{
        this.middleY=(startY+this.endY)/2+100;
        	this._startY=startY;
        }
        
        public function get startY():int{
        	return this._startY;
        }
        
        
        
        /**
         *  //结束节点
         */        
        private var _endX:int=0;
        private var _endY:int=0;
        public function set endX(endX:int):void{
        this.middleX=(endX+this.startX)/2+100;
          this._endX=endX;
        } 
        public function get endX():int{
        	return this._endX;
        }
        public function set endY(endY:int):void{
        	 this.middleY=(endY+this.startY)/2+100;
        	this._endY=endY;
        }
        public function get endY():int{
        	return this._endY;
        }
        
        
        /**
         * //线颜色
         */        
        private var _lineColor:uint=0x000000;
        
        public function set lineColor(color:uint):void{
        	this._lineColor=color;
        }
         
        public function get lineColor():uint{
            return this._lineColor;
          
        }
        
        
        /**
         * //线的宽度 
         */        
        private var _lineWidth:int=2;
        public function set lineWidth(width:int):void{
        	this._lineWidth=width;
        }
        public function get lineWidth():int{
        	return this._lineWidth;
        }
        
        
        /**
         * //线的类型 0为直线 1为曲线
         */        
        private var _lineType:int=0;
        
        public function set lineType(type:int):void{
        	if(type<0){
        		type=0;
        	}
        	if(type>1){
        		type=1;
        	}
        	this._lineType=type;
        }
        public function get lineType():int{
        	return this._lineType;
        }
        
        /**
         *  //选择时的颜色
         */        
        private var _selectColor:uint=0xFF0000;
        public function set selectColor(Color:uint):void{
        	this._selectColor=Color;
        }
        public function get selectColor():uint{
        	return this._selectColor;
        }
        
       /**
        * //中间点  
        */        
       private var _middleX:int=0;
       public function set middleX(middleX:int):void{
       	this._middleX=middleX;
       }
       public function get middleX():int{
       	return this._middleX;
       }
       private var _middleY:int=0;
       public function set middleY(middleY:int):void{
       	this._middleY=middleY;
       }
       public function get middleY():int{
       	return this._middleY;
       }
       
       
       
       /**
        * 点颜色
        */       
       private var _pointColor:uint=0Xf0d314;
       
       public function set pointColor(Color:uint):void{
       	this._pointColor=Color;
       }
       public function get pointColor():uint{
       	return this._pointColor;
       }
       
       /**
        * 开始节点名称
        */       
       private var _startName:String;
       public function set startName(value:String):void{
       	this._startName=value;
       }
       public function get startName():String{
       	return this._startName;
       }
       
       
       /**
        * 结束结点名称
        */       
       private var _endName:String;
       public function set endName(value:String):void{
       	this._endName=value;
       }
       public function get endName():String{
       	return this._endName;
       }
       
     
       /**
       *线对像事件
       * */ 
       private function creationComplete(event:FlexEvent):void{
        this.middleY=(this.startX+this.endX)/2;
        this.middleY=(this.startY+this.endY)/2;
       	drawLine();
      }
         
 
        /**
         * 
         * 画线
         */        
        
        public function drawLine():void 
        {
            
            this._lineChild.graphics.clear();
         	this.visible=true;
            this._lineChild.graphics.lineStyle(this.lineWidth,this.selectColor);
            this._lineChild.graphics.moveTo(this.startX,this.startY);
          
           if(this.lineType==1)
              {
//           		this.drawArrowhead(this._lineChild);
				trace(this.startX+"this.startY:"+this.startY);
           		this._lineChild.graphics.moveTo(this.startX,this.startY);
           		this._lineChild.graphics.lineTo(this.startX,this.startY+20);
          		this._lineChild.graphics.lineTo(this.endX,this.startY+20);
          		this._lineChild.graphics.lineTo(this.endX,this.endY);
           		
           		
          		this._lineChild.graphics.lineStyle(15,this.lineColor,0);
          		this._lineChild.graphics.moveTo(this.startX,this.startY);
           		this._lineChild.graphics.lineTo(this.startX,this.startY+20);
          		this._lineChild.graphics.lineTo(this.endX,this.startY+20);
          		this._lineChild.graphics.lineTo(this.endX,this.endY);
          		
        	   }
        	else
        	   {
           		this.drawArrowhead(this._lineChild);
           		this._lineChild.graphics.moveTo(this.startX,this.startY);
           		this._lineChild.graphics.lineTo(this.endX,this.endY);	
          		this._lineChild.graphics.lineStyle(15,this.lineColor,0);
            	this._lineChild.graphics.moveTo(this.startX,this.startY);
           		this._lineChild.graphics.lineTo(this.endX,this.endY);	
                }
           this._lineChild.graphics.endFill();
            
        }
        
        /**
         * 画箭头
         * @param child
         * @return 
         * 
         */        
        
        private function drawArrowhead(child:UIComponent):void
        {
        	var fromX:int;
        	var fromY:int;
        	if(this.lineType==1)
        	{
        		fromX=this.middleX;
        		fromY=this.middleY;
        	}
        	else
        	{
        		fromX=this.startX;
        		fromY=this.startY;
        	}
        	var dd:int=Math.sqrt((this.endX-fromX)*(this.endX-fromX)+(this.endY-fromY)*(this.endY-fromY));
            var xa:int=this.endX+10*((fromX-this.endX)+(fromY-this.endY)/2)/dd;
		    var ya:int=this.endY+10*((fromY-this.endY)-(fromX-this.endX)/2)/dd;
		    var xb:int=this.endX+10*((fromX-this.endX)-(fromY-this.endY)/2)/dd;
		    var yb:int=this.endY+10*((fromY-this.endY)+(fromX-this.endX)/2)/dd;
		
			child.graphics.beginFill(this.selectColor);
			child.graphics.moveTo(this.endX, this.endY);
			child.graphics.lineTo(xa, ya);
			child.graphics.lineTo(xb, yb);
			child.graphics.endFill();
        }
        /**
         *清除直线 
         * 
         */        
        public function clear():void
        {
        	this._lineChild.graphics.clear();
        	this.startX=0;
        	this.startY=0;
        	this.endX=0;
        	this.endY=0;
        	this.startName=null;
        	this.endName=null;
        	this.visible=false;
        }
        
    }
}