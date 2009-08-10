package  org.wjx.controls.workFlow.workFlowClasses{
    import flash.display.Sprite;
    import flash.events.*;
    
    import mx.core.UIComponent;
    import mx.events.*; 
    public class Line extends UIComponent {
      	import flash.ui.ContextMenu;
		import flash.ui.ContextMenuItem;
		import org.wjx.controls.workFlow.workFlowEvent.LineEvent;
       
       /**
        * //线对像
        */       
       private var _lineChild:UIComponent;
       
       /**
        * //开始点对像
        */     
       private var _startPoint:UIComponent;
      
      
       /**
        * //中间点对像
        */      
       private var _middlePoint:UIComponent;
       
       
      
       /**
        *  //结束点对像
        */       
       private var _endPoint:UIComponent;
     
       
      
       public function Line() {
           //线对像
           	_lineChild = new UIComponent();
           	
           	_lineChild.addEventListener(MouseEvent.MOUSE_OVER,lineMouseOver);
           	_lineChild.addEventListener(MouseEvent.MOUSE_OUT,lineMouseOut);
            _lineChild.addEventListener(MouseEvent.MOUSE_UP,lineMouseDown);
          	this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
           
           	//开始点对像
         	_startPoint = new UIComponent();
         	_startPoint.width=6;
         	_startPoint.height=6;
          //  _startPoint.addEventListener(MouseEvent.MOUSE_DOWN, startMouseDownHandler);
          //  _startPoint.addEventListener(MouseEvent.MOUSE_UP, startMouseUpHandler);
           
           
           	//中间点对像
           	_middlePoint = new UIComponent();
         //    _middlePoint.addEventListener(MouseEvent.MOUSE_DOWN, middleMouseDownHandler);
         //   _middlePoint.addEventListener(MouseEvent.MOUSE_UP, middleMouseUpHandler);
           
           
           	//结束点对像
           	_endPoint = new UIComponent();
           _endPoint.width=6;
           _endPoint.height=6;
          //  _endPoint.addEventListener(MouseEvent.MOUSE_DOWN, endMouseDownHandler);
          //  _endPoint.addEventListener(MouseEvent.MOUSE_UP, endMouseUpHandler);
           	drawLine();
            addChild(_lineChild);
            addChild(_startPoint);
            addChild(_middlePoint);
            addChild(_endPoint);
            initMenu();
        }
       private var	deleteMenuItem:ContextMenuItem;
       private var nodePropertyMenuItem:ContextMenuItem;
       public function initMenu():void{
	    	var contextMenu : ContextMenu = new ContextMenu();
	    	contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,mouseRightClick);
	    	contextMenu.hideBuiltInItems(); // 隐藏一些内建的鼠标右键菜单项
			deleteMenuItem = new ContextMenuItem("删除");
			deleteMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,lineDeleteClick);
			contextMenu.customItems.push(deleteMenuItem);
			
			nodePropertyMenuItem= new ContextMenuItem("属性");
			nodePropertyMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,linePropertyClick);
			contextMenu.customItems.push(nodePropertyMenuItem);
			this.contextMenu = contextMenu;// 这里的this为Application对象
                      
	    } 
	    /**
	     * 鼠标右键  
	     * @param event
	     * @return 
	     * 
	     */	    
	    public function mouseRightClick(event:ContextMenuEvent):void
	    {
	      if(this.lineState==null ||this.lineState==nodeStateConstants.defaultState){
	      	if(this.lineSelect){
	       		deleteMenuItem.enabled=true;
	       		nodePropertyMenuItem.enabled=true;
	       		this.dispatchEvent(new LineEvent(LineEvent.rightClick));
	       	}else{
	       		deleteMenuItem.enabled=false;
	       		nodePropertyMenuItem.enabled=false;
	       	}
	      }else{
	      	deleteMenuItem.visible=false;
	       	nodePropertyMenuItem.visible=false;
	      }
	       
	     }
	     /**
	      * 删除 
	      * @param event
	      * @return 
	      * 
	      */	     
	     public function lineDeleteClick(event:ContextMenuEvent):void
	     {
	     	this.dispatchEvent(new LineEvent(LineEvent.deleteClick));
	     }
	     /**
	      * 查看属性 
	      * @param event
	      * @return 
	      * 
	      */	     
	     public function linePropertyClick(event:ContextMenuEvent):void
	     {
	     	this.dispatchEvent(new LineEvent(LineEvent.propertyClick));
	     }
       
         /**
          *是否选中 
          */         
         private var _lineSelect:Boolean=false;
         public function set lineSelect(lineSe:Boolean):void{
         	this._lineSelect=lineSe;
         	if(!lineSe){
         		this._select=false;
         	}
         	if(lineSe){
         		var childNum:int=this.parent.numChildren;
         	    this.parent.setChildIndex(this,childNum-1);
         	}
         	drawStartPoint();
        	drawMiddlePoint();
        	drawEndPoint();
        	drawLine();
         }
       public function get lineSelect():Boolean{
       	return this._lineSelect;
       }
       
       /**
        *当前操作的点
        */       
       private var _selectPoint:String="null";
       public  function set selectPoint(value:String):void{
       		this._selectPoint=value;
       		
        }
       public function get selectPoint():String{
       	return this._selectPoint;
       }
       
       
       
        /**
         * 开始节点
         */       
        private var _startX:int=0;
        private var _startY:int=0;
       
        public function  set startX(startX:int):void{
        this._startX=startX;
        }
        
      	public function get startX():int{
        return this._startX;
        }
        
        
        public function set startY(startY:int):void{
        	this._startY=startY;
        }
        
        public function get startY():int{
        	return this._startY;
        }
        
        
        
        /**
         * 是否选中
         */        
        private var _isSelect:Boolean=false;
        public function set isSelect(value:Boolean):void
        {
        	this._isSelect=value;
        }
        public function get isSelect():Boolean{
        	return this._isSelect;
        }
       
       
       
        /**
         * //结束节点
         */        
        private var _endX:int=0;
        private var _endY:int=0;
        public function set endX(endX:int):void{
          this._endX=endX;
        } 
        public function get endX():int{
        	return this._endX;
        }
        public function set endY(endY:int):void{
        	
        	this._endY=endY;
        }
        public function get endY():int{
        	return this._endY;
        }
        
        
        
        /**
         * 线颜色
         */        
       
        private var _lineColor:uint=6711039;
        
        public function set lineColor(color:uint):void{
        	this._lineColor=color;
        }
         
        public function get lineColor():uint{
            return this._lineColor;
          
        }
        
        
        
        /**
         * 线的宽度 
         */        
        
        private var _lineWidth:int=2;
        public function set lineWidth(width:int):void{
        	this._lineWidth=width;
        }
        public function get lineWidth():int{
        	return this._lineWidth;
        }
        
        
        
        /**
         * 线的类型 0为直线 1为曲线
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
         * 选择时的颜色
         */        
        private var _selectColor:uint=0xFF0000;
        public function set selectColor(Color:uint):void{
        	this._selectColor=Color;
        }
        public function get selectColor():uint{
        	return this._selectColor;
        }
        
        
       /**
        * 中间点  
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
       *是否在拖动 
       */      	
      private var _lineDrage:Boolean=false;
      public function set lineDrage(value:Boolean):void
      {
      	this._lineDrage=value;
      }
      public function get lineDrage():Boolean{
      	return this._lineDrage;
      }
       
      private var _isDrage:Boolean=false;
      public function set isDrage(value:Boolean):void{
      	this._isDrage=value;
      } 
      public function get isDrage():Boolean{
      	return this._isDrage;
      }
       
       
      /**
       * 线的状态
       */       
      private var _lineState:String=null;
      public function set lineState(value:String):void{
      	this._lineState=value;
      }
       
      public function get lineState():String{
      	return this._lineState;
      }
       
       
       
      private var _completeColor:uint=0x4D9900;
      public function get completeColor():uint{
      	return this._completeColor;
      } 
      
      private var _noExecuteColor:uint=0xA3A3A3;
      public function get noExecuteColor():uint{
      	return _noExecuteColor;
      }
       
       /**
        * 设置移动点的位置
        * @param MoveX
        * @param MoveY
        * @return 
        * 
        */       
       public function  movePonitXY(MoveX:int,MoveY:int):void
       {
       		if(selectPoint=="start"){
       		this.startX=MoveX;
       		this.startY=MoveY;
       		}
       		if(selectPoint=="middle"){
       		this.middleX=MoveX;
       		this.middleY=MoveY;
       		}
       		if(selectPoint=="end"){
       		this.endX=MoveX;
       		this.endY=MoveY;
       		}
       		drawStartPoint();
        	drawMiddlePoint();
        	drawEndPoint();
        	drawLine();
       }
        
        private var _select:Boolean=false;  
       /**
       *线对像事件
       * */ 
       private function creationComplete(event:FlexEvent):void
       {
        this.middleY=(this.startX+this.endX)/2;
        this.middleY=(this.startY+this.endY)/2;
       	drawLine();
       	event.stopPropagation();
       }
	  /**
	   * mouseover事件
	   * @param event
	   * @return 
	   * 
	   */         
	  private function lineMouseOver(event:MouseEvent):void
	  {
			if(!this._select){
	        	this._select=true;
	        	 drawStartPoint();
	        	 if(_lineType==1){
	        	 drawMiddlePoint();
	        	 }
	        	drawEndPoint();
	        	drawLine();
	        	}
	        	event.stopPropagation();
	        }
        /**
         *mouseout事件 
         * @param event
         * @return 
         * 
         */        
        public function lineMouseOut(event:MouseEvent):void
        {
        	if(this._select && selectPoint=="null"){
        	this._select=false;
        	drawStartPoint();
        	drawMiddlePoint();
        	drawEndPoint();
        	drawLine();
        	event.stopPropagation();
        	}	
        }
       /**
        *mousedown事件 
        * @param evnet
        * @return 
        * 
        */       
       public function lineMouseDown(evnet:MouseEvent):void
       {
       	//this.lineSelect=true;
      }
       
        /**
        * 开始节点对像事件
        * */
      private function startMouseDownHandler(event:MouseEvent):void {
       	var sprite:Sprite = Sprite(event.target);
        this._select=true;
        this.isDrage=true;
        sprite.startDrag(true);
        this.selectPoint="start";
    	}
   
        private function startMouseUpHandler(event:MouseEvent):void {
            
           	var selectUi:UIComponent=event.currentTarget as UIComponent;
         	 selectUi.stopDrag();
         	  this.isDrage=false;
            this.startX=selectUi.x;
        	this.startY=selectUi.y;
        	drawLine();
            this.selectPoint="null";
        }

         
        /**
        * 中间点对像事件
        * */
        
         private function middleMouseDownHandler(event:MouseEvent):void {
           var sprite:Sprite = Sprite(event.target);
           sprite.startDrag(true);
            this.isDrage=true;
            this.selectPoint="middle";
        	}

        private function middleMouseUpHandler(event:MouseEvent):void {
            
           	var selectUi:UIComponent=event.currentTarget as UIComponent;
            selectUi.stopDrag();
             this.isDrage=false;
           	this.middleX=selectUi.x;
        	this.middleY=selectUi.y;
        	drawLine();
            this.selectPoint="null";
        }

       
        /**
        * 结束点对像事件
        * */
         private function endMouseDownHandler(event:MouseEvent):void {
           
            var sprite:Sprite = Sprite(event.target);
          	sprite.startDrag(true);
          	 this.isDrage=true;	
             this.selectPoint="end";
        	}

        private function endMouseUpHandler(event:MouseEvent):void {
            var selectUi:UIComponent=event.currentTarget as UIComponent;
           	selectUi.stopDrag();
           	 this.isDrage=false;
          	this.endX=selectUi.x;
        	this.endY=selectUi.y;
        	drawLine();
            this.selectPoint="null";
        }

       
       
        /**
         * 
         * 画开始点
         */       
        public function drawStartPoint():void{
        	if(this.lineState==null ||this.lineState==nodeStateConstants.defaultState){
        		this._startPoint.graphics.clear();
        	 	if(this.lineSelect){
        			this._startPoint.graphics.beginFill(this.pointColor);
           			this._startPoint.graphics.drawCircle(3,3,6);
           			this._startPoint.move(this._startX,this._startY);
           			this._startPoint.graphics.endFill();
          		}
         	}
        }
        /**
         * 画中间点
         * 
         */       
        public function drawMiddlePoint():void{
        	if(this.lineState==null ||this.lineState==nodeStateConstants.defaultState){
         		if(this._lineType==1){
         			this._middlePoint.graphics.clear();
         			if(this.lineSelect ){
         				this._middlePoint.graphics.beginFill(this.pointColor);
           				this._middlePoint.graphics.drawCircle(3,3,6);
           				this._middlePoint.move(this.middleX,this.middleY);
           				this._middlePoint.graphics.endFill();	
           			}
          		}
         	}
        } 
        /**
         * 画结束点
         * 
         */        
        public function drawEndPoint():void{
        	if(this.lineState==null ||this.lineState==nodeStateConstants.defaultState){
        		this._endPoint.graphics.clear();
         		if(this.lineSelect){
        			this._endPoint.graphics.beginFill(this.pointColor);
        			this._endPoint.graphics.drawCircle(3,3,6);
     				this._endPoint.move(this._endX,this._endY);  
        			this._endPoint.graphics.endFill();	
         		}
        	}
        }
        
        public function lineRefash():void
        {
        	this.lineSelect=false;
        	this._select=false;
        	//drawLine();
        }
        
        /**
         * 得到线的颜色
         * @return 
         * 
         */        
        public function getDrawColor():uint{
        	var drawColor:uint;
        	if(this.lineState==null ||this.lineState==nodeStateConstants.defaultState){
        		if(this.lineSelect || this._select){
        			drawColor=this.selectColor;
        		}else{
        			drawColor=this.lineColor;	
        		}
        	}else{
        		if(this.lineState==nodeStateConstants.complete){
        			drawColor=this.completeColor;
        		}
        		if(this.lineState==nodeStateConstants.noExecute){
        			drawColor=this.noExecuteColor;
        		}
        	}
        	return drawColor;
        }
        
        
        /**
         * 画线
         * 
         */        
        private function drawLine():void {
			this._lineChild.graphics.clear();
         	var drawColor:uint;
        	if(this.lineSelect || this._select){
        		drawColor=this.getDrawColor();
          	}else{
          		this._startPoint.graphics.clear();
           		this._middlePoint.graphics.clear();
           		this._endPoint.graphics.clear();
           		drawColor=this.getDrawColor();
         	}
           	this._lineChild.graphics.moveTo(this.startX,this.startY);
           	if(this.lineType==1){
           		if(getCenterXY()){
           		this._lineChild.graphics.lineStyle(15,drawColor,0);
          		this._lineChild.graphics.curveTo(this.middleX,this.middleY,this.endX,this.endY);
           	   
           	   	this._lineChild.graphics.lineStyle(this.lineWidth,drawColor)
           	    
           	    this._lineChild.graphics.moveTo(this.startX,this.startY);
           	    this.drawArrowhead(this._lineChild);
           	    
           	   	this._lineChild.graphics.moveTo(this.startX,this.startY);
           	    this._lineChild.graphics.curveTo(this.middleX,this.middleY,this.endX,this.endY);
           	 }
           	}else{
         		this._lineChild.graphics.lineStyle(15,drawColor,0);
            	this._lineChild.graphics.moveTo(this.startX,this.startY);
           		this._lineChild.graphics.lineTo(this.endX,this.endY);
         	    this._lineChild.graphics.lineStyle(this.lineWidth,drawColor);
         	  	
         	  	this._lineChild.graphics.moveTo(this.startX,this.startY);
         	  	this.drawArrowhead(this._lineChild);
         	  	
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
        	if(this.lineType==1){
        		fromX=this.middleX;
        		fromY=this.middleY;
        	}else{
        		fromX=this.startX;
        		fromY=this.startY;
        	}
        	var dd:int=Math.sqrt((this.endX-fromX)*(this.endX-fromX)+(this.endY-fromY)*(this.endY-fromY));
            var xa:int=this.endX+10*((fromX-this.endX)+(fromY-this.endY)/2)/dd;
		    var ya:int=this.endY+10*((fromY-this.endY)-(fromX-this.endX)/2)/dd;
		    var xb:int=this.endX+10*((fromX-this.endX)-(fromY-this.endY)/2)/dd;
		    var yb:int=this.endY+10*((fromY-this.endY)+(fromX-this.endX)/2)/dd;
			/* if(this.lineSelect || this._select){
			child.graphics.beginFill(this.selectColor);
			}else{
			child.graphics.beginFill(lineColor);	
			} */
			child.graphics.beginFill(this.getDrawColor());
			child.graphics.moveTo(this.endX, this.endY);
			child.graphics.lineTo(xa, ya);
			child.graphics.lineTo(xb, yb);
			child.graphics.endFill();
        }
        
        //计算中问点坐标
        private function getCenterXY():Boolean{
    	//中点坐标
    	//trace("-----------------------");
    	if((Math.abs(this.startX)-Math.abs(this.endX))==0){
    	  if(this.startY<this.endY){
    	  		this.middleY=(this.startY+this.endY)/2 
    	  		this.middleX=this.startX-60;       	  
    	  	}else{
    	  		this.middleY=(this.startY+this.endY)/2 
    	  		this.middleX=this.startX+60;	
    	  	}
    	  	
    	}else if((Math.abs(this.startY)-Math.abs(this.endY))==0){
    		if(this.startX<this.endX){
    			this.middleX=(this.startX+this.endX)/2;
    			this.middleY=this.startY+60;
    		}else{
    			this.middleX=(this.startX+this.endX)/2;
    			this.middleY=this.startY-60;
    		}
    	
    	}else{
    		var x3:int=(this.startX+this.endX)/2;
    		var y3:int=(this.startY+this.endY)/2;
    		var k1:Number=(this.endY-this.startY)/(this.endX-this.startX);
    		var k3:Number=-1/k1;
    		var b3:Number=y3-(k3*x3);
    	//	var k2:Number=(k1-1.732)/(1.732*k1+1)
    		var tana:*=60/Math.sqrt((this.startX-x3)*(this.startX-x3)+(this.startY-y3)*(this.startY-y3));
    		var k2:Number=(k1-tana)/(tana*k1+1);
    		//var b2:Number=this.startY-(k2*this.startY);
    		if(k2<0){
    			var tana3:*=15/Math.sqrt((this.endX-x3)*(this.endX-x3)+(this.endY-y3)*(this.endY-y3));	
    		}
    		var b2:Number=this.endY-(k2*this.endX);
    		//trace("k2",k2);
    		//trace(k2);
    	
    		this.middleX=(b3-b2)/(k2-k3);
    		this.middleY=(k3*this.middleX)+b3;
    		//trace("midd",this.middleX,this.middleY)
    		var abs:int=Math.abs(Math.abs(this.startY)-Math.abs(this.endY));
    		//trace("aa",abs);
    	if(abs<7){
    		if(this.startX<this.endX){
    			this.middleX=(this.startX+this.endX)/2;
    			this.middleY=this.startY+60;
    		}else{
    			this.middleX=(this.startX+this.endX)/2;
    			this.middleY=this.startY-60;
    		}	
    		}
    		//trace("start:",this.startX,this.startY); 
    		//trace("midd",this.middleX,this.middleY);
    		//trace("end",this.endX,this.endY);
    	}
    	//trace("===================");
    	return true;
    	
    }
        
         
    }
}