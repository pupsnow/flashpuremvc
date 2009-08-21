package org.flowDesign.panel
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	
	import org.flowDesign.data.LineData;
	import org.flowDesign.data.LineProperty;
	import org.flowDesign.data.NodeData;
	import org.flowDesign.data.NodeProperty;
	import org.flowDesign.data.WorkFlowData;
	import org.flowDesign.data.WorkFlowDataProvider;
	import org.flowDesign.event.NodeEvent;
	import org.flowDesign.event.WrokFlowDesignEvent;
	import org.flowDesign.layout.DrawingTool;
	import org.flowDesign.layout.DrawingToolManager;
	import org.flowDesign.layout.IFlowUI;
	import org.flowDesign.layout.Node;
	import org.flowDesign.source.NodeStyleSource;
	import org.wjx.controls.workFlow.workFlowEvent.LineEvent;
	[Event (name="nodeDel", type="org.flowDesign.event.WrokFlowDesignEvent")]
	[Event (name="lineDel", type="org.flowDesign.event.WrokFlowDesignEvent")]
	[Event (name="nodeMove", type="org.flowDesign.event.WrokFlowDesignEvent")]
	[Event (name="nodeProperty", type="org.flowDesign.event.WrokFlowDesignEvent")]
	[Event (name="lineProPerty", type="org.flowDesign.event.WrokFlowDesignEvent")]
	public class FlowDesignPanel extends Canvas
	{
		
		/**
		 *当前选择工具类型 
		 */				
		private var _currentTool:Class;
		public  function set currentTool(value:Class):void
		{
			this._currentTool = value;
		}
		public function get currentTool():Class
		{
			return this._currentTool;
		}
		 /**
		 * 节点或线的数据保存
		 * */
		private var workFlowData:WorkFlowData;
		
//		public function set dataProvider(dataProvider:XML):void
//		{
//			this.workFlowData.dataProvider=dataProvider;
//		}
		public function get dataProvider():XML
		{
			return this.workFlowData.dataProvider;
		}
		
		/**
		 * 整个流程图内的数据保存
		 * 
		 * */
		private var _workFlowDataProvider:WorkFlowDataProvider;
		
//		[Bindable]
//		public function set DataProvider(value:XML):void
//		{
//			this._workFlowDataProvider.dataProvider=value;
//		}
//		
//		public function get DataProvider():XML
//		{
//			return	this._workFlowDataProvider.dataProvider;
//		}
		 
		 /**
		  *记录当前所选对像的名称与类型 name type（画板中的）
		  */		 
		 private var _selectObject:Array=[];
		 public function set selectObject(value:Array):void
		 {
		 	this._selectObject=value;
		 }
		 public function get selectObject():Array
		 {
		 	return this._selectObject;
		 }
		 
		  /**
		  *判断是否 画线是否可以
		  */		  
		 private var _drawLine:Boolean=false;
		 public function set drawLine(value:Boolean):void
		 {
		 	this._drawLine=value;
		 } 
		 public function get drawLine():Boolean
		 {
		 	return this._drawLine;
		 }
		 
		 
		 /**
		  *判断是否 完成画线
		  */		 
		 private var _drawLineEnd:Boolean=false;
		 public function set drawLineEnd(value:Boolean):void
		 {
		 	this._drawLineEnd=value;
		 }  
		 public function get drawLineEnd():Boolean
		 {
		 	return this._drawLineEnd;
		 } 
		
		 /**
		  *节点是否正在拖动 
		  */		 
		 private var _isDrage:Boolean=false;
		 public function set isDrage(value:Boolean):void{
		 	this._isDrage=value;
		 }
		 public function get isDrage():Boolean{
		 	return this._isDrage;
		 }
		 
		 /**
		  * 
		  */		
		 private var _inFrist:Boolean=false;
		 public function set inFrist(value:Boolean):void
		 {
		 	this._inFrist=value;
		 }
		 public function get inFrist():Boolean
		 {
		 	return this._inFrist;
		 }
		 		 
		 /**
		  *用于记录拖动的对像名称
		  */		 
		 private var _drageName:String=null;
		 public function set drageName(value:String):void
		 {
		 	this._drageName=value;
		 } 
		 public function get drageName():String
		 {
		 	return this._drageName;
		 }
		 
		 
		/**
		 *当前正在执行的环节 
		 */		 
		 private var _currentStep:String;
		 
		 public function set currentStep(value:String):void
		 {
		 	_currentStep = value;
		 }
		 
		 public function get currentStep():String
		 {
		 	return _currentStep;
		 }
		 
		private var temporaryLine:DrawingTool; 
		
		
		public function FlowDesignPanel()
		{
			workFlowData=new WorkFlowData(this);
			_workFlowDataProvider=new WorkFlowDataProvider(this);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown_Event_Handler);
			this.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove_Event_Handler);
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUp_Event_Handler);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOut_Event_Handler);	
			this.addEventListener(DragEvent.DRAG_ENTER,	dragEnterHandler);
			this.addEventListener(DragEvent.DRAG_DROP,	dragDropHandler);
			this.addEventListener(DragEvent.DRAG_EXIT,	dragExitHandler);
		}
		/**
		 *鼠标按下 清空当前选择对象
		 * @param event
		 * 
		 */		
		protected  function  mouseDown_Event_Handler(event:MouseEvent):void
		{
			clearSelectObject();
			event.stopPropagation();
		}
		
		
		/**
		 * 设置状态(各个组件的状态修改 选中 非选中)
		 * @param newSelectName
		 * @param newSelectType
		 * @return 
		 * 
		 */		
		public function setSelectState(newSelectName:String,newSelectType:String):void
		{
			if(this.selectObject[0]!=null)
			{
				var oldSelectName:String=this.selectObject[0].name;
				var oldSelectType:String=this.selectObject[0].type;
				if(newSelectName!=oldSelectName)
				{
				var oldSelectedUI:IFlowUI = this.getChildByName(oldSelectName) as IFlowUI;
					if(oldSelectedUI!=null)
					oldSelectedUI.uiSelect = false;
				var newSelectedUI:IFlowUI = this.getChildByName(newSelectName) as IFlowUI;
					newSelectedUI.uiSelect = true;
				this.selectObject[0]={name:newSelectName,type:newSelectType}
				}
					
			}
			else
				{
					this.selectObject[0]={name:newSelectName,type:newSelectType}
					var newSlectedUI2:IFlowUI = this.getChildByName(newSelectName) as IFlowUI;
						newSlectedUI2.uiSelect = true;
			    }
		}
		/**
		 * 清出选择对像
		 * @return 
		 * 
		 */		
		
		public function clearSelectObject():void
		{
			if(this.currentTool!=null)
				this.currentTool =null;
			if(this.selectObject[0]!=null)
			{
				var selectObjectName:String=this.selectObject[0].name;
				var slectObjectType:String=this.selectObject[0].type;
				var selectedUI:IFlowUI= this.getChildByName(selectObjectName) as IFlowUI;
					if(selectedUI!=null)
					selectedUI.uiSelect = false;
				this.selectObject[0]=null;
			}
		}
		
		/**
		 * 鼠标移动 在面板上移动
		 * @param event
		 * 
		 */		
		protected function mouseMove_Event_Handler(event:MouseEvent):void
		{
		if(currentTool!=null)/**当前是画线模式 */
			{
				if(this.drawLine)
				{
					this.temporaryLine.endX=this.contentMouseX;
					this.temporaryLine.endY=this.contentMouseY;
					this.temporaryLine.invalidateDisplayList();
				}
			 	 
			}
		else if(this.selectObject[0]!=null)/**选着节点不为空 也就是当前是移动 */
			{
				
					var selectObjectName:String=this.selectObject[0].name;
					var selectObjectType:String=this.selectObject[0].type;
					
					if(selectObjectType=="node")/**如果选中的节点 更新与之相连的线的位置 */
					{
						var node:Node=Node(this.getChildByName(selectObjectName));
								if(node!=null)
								{
									if(node.isDrage)
									{
									var mouseX:Number=event.currentTarget.contentMouseX;
									var mouseY:Number=event.currentTarget.contentMouseY;
									var wfNodeMouseX:Number=node.contentMouseX;
									var wfNodeMouseY:Number=node.contentMouseY;
									/**
									* 增加画布长宽
									*/				
									if(mouseX+node.width>this.width)
									{
										this.width=this.width+node.width+100;
									}
									if(mouseY+node.height>this.height)
									{
										this.height=this.height+node.height+100;	
										
									}
									/**
									* 不能拖出左边界
									*/				
									if(mouseX-wfNodeMouseX<0)
									{
										node.stopDrag();
										node.move(0,node.y);
										node.dispatchEvent(new NodeEvent(NodeEvent.NODESTOP_DRAGE));
										this.drageName=null;
									}
									/**不能拖出上边界  */
									if(mouseY-wfNodeMouseY<0)
									{
										node.stopDrag();
										node.move(node.x,0);
										node.dispatchEvent(new NodeEvent(NodeEvent.NODESTOP_DRAGE));
										this.drageName=null;	
									}
								var getNodeName:String=node.name;
								var getNodeFromLine:Array=this.workFlowData.qryLineDataByFromNodeId(getNodeName);
				   					for(var i:int=0;i<getNodeFromLine.length;i++)
				   					{
				    					var fromLineData:LineData=LineData(getNodeFromLine[i]);
				    					if(fromLineData!=null)
				    					{
				    						DrawingTool(this.getChildByName(fromLineData.id)).lineRefresh(fromLineData);
				    					}
				   					}
				  			 	var getNodeToLine:Array=this.workFlowData.qryLineDataByToNodeId(getNodeName);
				    			for(var j:int=0;j<getNodeToLine.length;j++)
				    			{
				    				var toLineData:LineData=LineData(getNodeToLine[j]);
				    				if(toLineData!=null)
				    				{
				    					DrawingTool(this.getChildByName(toLineData.id)).lineRefresh(toLineData);
				    				}
				    			}
							}
						}
					}
				}
			}		
		/**
		 *鼠标松开 
		 * @param event
		 * 
		 */		
		protected function mouseUp_Event_Handler(event:MouseEvent):void
		{
			if(this.currentTool!=null)
			{
				if(this.drawLine)
				{
					if(this.drawLineEnd)
					{
	 					this.drawLine=false;
						this.drawLineEnd=false;
					}
					else
					{
						this.drawLine=false;
						removeLine(this.temporaryLine);
						this.temporaryLine =  null;
					}
				}
			}
		}
		/**
		 *鼠标移出 
		 * @param event
		 * 
		 */		
		protected function mouseOut_Event_Handler(event:MouseEvent):void
		{
			if(this.contentMouseX<5||this.contentMouseX>this.width-5||
			   this.contentMouseY<5||this.contentMouseY>this.height-5)
			{
				if(this.currentTool!=null&&this.temporaryLine!=null)
				{
					this.drawLine=false;
					removeLine(this.temporaryLine);
					this.temporaryLine = null;
				}
			}
		}
		
		/**
		 * 拖动进入事件 
		 * @param event
		 * 
		 */		
		private function dragEnterHandler(event:DragEvent):void
		{
		    var dropTarget:Canvas=event.currentTarget as Canvas;
		        DragManager.acceptDragDrop(dropTarget);
		}
		
		/**
		 * 拖运退出事件
		 * @param event
		 * 
		 */		
		private function dragExitHandler(event:DragEvent):void
		{
		    var dropTarget:Canvas=event.currentTarget as Canvas;
			revertBoxBorder();
		}
		private function revertBoxBorder():void
		{
		}
		/**
		 * 拖运放下事件
		 * */
		private function dragDropHandler(event:DragEvent):void
		{
			var dragemouse:Point = new Point(event.dragSource.dataForFormat('x') as Number,
								event.dragSource.dataForFormat('y') as Number)
			var nodeType:String = event.dragSource.dataForFormat('value') as String;
			var lable:String = event.dragSource.dataForFormat('lable') as String;
			var typename:String=event.dragSource.dataForFormat('typename') as String;
			var typeId:String=event.dragSource.dataForFormat('typeId') as String;
			var x:Number=event.localX-this.x-dragemouse.x;
			var y:Number=event.localY-this.y-dragemouse.y;
			if(x<0) 
			x=5;
			if(y<0) 
			y=5;
			if(y+80>this.height+this.y) //y大于右边位置
			y = y-60;//重置y
			if(x+80>this.width+this.x)  
			x = x-60;
			newNode(lable,nodeType,x,y,typeId);
		}		
		
		/**
		 * 添加一个新节点
		 * @param name
		 * @param type
		 * @param x
		 * @param y
		 * @param typeId
		 * 
		 */		
		private  function newNode(name:String,type:String,x:int,y:int,typeId:String):void
		{
			
			//这个地方应该更具不同的 节点的 扩展属性 事例对应的类
			var nodepro:NodeProperty = new NodeProperty();
				nodepro.nodeTitle = name;
			var	nodeData:NodeData=workFlowData.newNode(name,type,typeId,x,y,nodepro);
		   	var nodeControl:UIComponent=newNodeControl(nodeData);
			this.addChild(nodeControl);   
		}
		/**
		 * 生成一个节点（拖动，获取更具数据）
		 * @param nodeData
		 * @return 
		 * 
		 */		
		protected function newNodeControl(nodeData:NodeData):UIComponent
		{
			var wfNode:Node=new Node();
			wfNode.label=nodeData.name;
			wfNode.id=nodeData.id
			wfNode.name=nodeData.id;
			wfNode.type=nodeData.type;
			wfNode.data=nodeData.id;
			wfNode.nodeState=nodeData.nodeState;
			wfNode.x=nodeData.x;
			wfNode.y=nodeData.y;
			wfNode.addEventListener(FlexEvent.CREATION_COMPLETE,nodeCreationComplete);
            wfNode.addEventListener(MouseEvent.MOUSE_OVER,nodeMouseOver);
            wfNode.addEventListener(MouseEvent.MOUSE_DOWN,nodeMouseDown);
            wfNode.addEventListener(MouseEvent.MOUSE_UP,nodeMouseUp);
            wfNode.addEventListener(MouseEvent.MOUSE_OUT,nodeMouseOut);
            wfNode.addEventListener(MouseEvent.DOUBLE_CLICK,nodeMouseDoubleClick);
            
            wfNode.addEventListener(MoveEvent.MOVE,nodeMove); 
            wfNode.addEventListener(ResizeEvent.RESIZE,nodeResize);
            
            wfNode.addEventListener(NodeEvent.RIGHT_CLICK,nodeRightClick);
            wfNode.addEventListener(NodeEvent.DELETE_CLICK,nodeDeleteClick);
            wfNode.addEventListener(NodeEvent.PROPERTY_CLICK,nodePropertyClick);
           	wfNode.addEventListener(NodeEvent.NODESTART_DRAGE,nodeDrageStart);
           	wfNode.addEventListener(NodeEvent.NODESTOP_DRAGE,nodeDrageStop);
           	
           	wfNode.addEventListener(NodeEvent.SETCURRENT_CLICK,setCurrentClick);
           	wfNode.addEventListener(NodeEvent.COMPLETECURRENT_CLICK,completeCurrentClick);
           	wfNode.addEventListener(NodeEvent.PASSCURRENT_CLICK,passCurrentClick);
           	
           	
            wfNode.doubleClickEnabled=true;
			return wfNode;
		}
		
		
		/**
		 *删除节点 
		 * @param event
		 * 
		 */		
		 
		 protected function removeNode(node:Node):void
		{
			node.removeEventListener(FlexEvent.CREATION_COMPLETE,nodeCreationComplete);
            node.removeEventListener(MouseEvent.MOUSE_OVER,nodeMouseOver);
            node.removeEventListener(MouseEvent.MOUSE_DOWN,nodeMouseDown);
            node.removeEventListener(MouseEvent.MOUSE_UP,nodeMouseUp);
            node.removeEventListener(MouseEvent.MOUSE_OUT,nodeMouseOut);
            node.removeEventListener(MouseEvent.DOUBLE_CLICK,nodeMouseDoubleClick);
            
            node.removeEventListener(MoveEvent.MOVE,nodeMove); 
            node.removeEventListener(ResizeEvent.RESIZE,nodeResize);
            
            node.removeEventListener(NodeEvent.RIGHT_CLICK,nodeRightClick);
            node.removeEventListener(NodeEvent.DELETE_CLICK,nodeDeleteClick);
            node.removeEventListener(NodeEvent.PROPERTY_CLICK,nodePropertyClick);
           	node.removeEventListener(NodeEvent.NODESTART_DRAGE,nodeDrageStart);
           	node.removeEventListener(NodeEvent.NODESTOP_DRAGE,nodeDrageStop);
           	node.removeEventListener(NodeEvent.SETCURRENT_CLICK,setCurrentClick);
           	node.removeEventListener(NodeEvent.COMPLETECURRENT_CLICK,completeCurrentClick);
           	node.removeEventListener(NodeEvent.PASSCURRENT_CLICK,passCurrentClick);
			this.removeChild(node);
			node = null;
			
		}
		 
       /**
		 * 节点完成
		 * @param event
		 * @return 
		 * 
		 */		
		protected function nodeCreationComplete(event:FlexEvent):void
		{
		  var nodeEvent:Node=event.currentTarget as Node;
		  var nodeId:String=nodeEvent.id;
		  var nodeData:NodeData=workFlowData.getNodeData(nodeId);
		 	  nodeData.x=nodeEvent.x;
          	  nodeData.y=nodeEvent.y;
          if(nodeEvent.x+nodeEvent.width+10>(this.x+this.width))
		      {
		      	this.width=this.width+(nodeEvent.x-this.width)+nodeEvent.width+100;//增加画布宽
		      }
          if(nodeEvent.y+nodeEvent.height+10>(this.y+this.height))
            {
          		this.height=this.height+(nodeEvent.y-this.height)+nodeEvent.height+100;//增加画布宽
            }
          var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.nodeComplete);
         	  wrokFlowDesignEvent.nodeData=nodeData;
          this.dispatchEvent(wrokFlowDesignEvent);//派发
          
       }
       
		/**
		 * 节点被被拖动时跟新数据的x y坐标 
		 * @param event
		 * @return 
		 * 
		 */       
		protected function nodeMove(event:MoveEvent):void
		{
			var node:Node=event.currentTarget as Node;
			var nodeName:String=node.name;
		    var nodeData:NodeData=this.workFlowData.getNodeData(nodeName);
		   	nodeData.x=node.x;
		    nodeData.y=node.y;
		   	var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.nodeMove);
          	wrokFlowDesignEvent.nodeData=nodeData;
          	this.dispatchEvent(wrokFlowDesignEvent);
		}
		
		
		/**
		 * 鼠标滑过节点时，如果工具选着的是直线或曲线，那么现在节点是不能被选中的，只能是划线模式，
		 * 否则节点是可以被选中的。
		 * @param event
		 * @return 
		 * 
		 */		
		protected function nodeMouseOver(event:MouseEvent):void
		{
		 	var node:Node=event.currentTarget as Node;
			if(this.currentTool!=null )
				{
				  node.isSelect=false;
				  if(this.drawLine)/**划线结束的时候 */
				  {
				  	   var nodeName:String=node.name;
				  	   if(this.temporaryLine.startName!=nodeName)
				  	   {
				  	   	   this.temporaryLine.endName=nodeName;
				  	       this._drawLineEnd=true;
				  	   }
				  }
				}
			else
				{
					 node.isSelect=true;
				}
			 
		}
		
		
	   /**
	    * 鼠标按下，如果工具选着的是直线或曲线，那么现在节点是不能被选中的，只能是划线模式，
		 * 否则节点是可以被选中的
	    * @param event
	    * 
	    */		
	   protected function nodeMouseDown(event:MouseEvent):void
	   {
	   		
	       var node:Node=event.currentTarget as Node;
	   	   if(currentTool!=null)
	   	   {
		   		node.isSelect=false;
		   		this.temporaryLine = DrawingToolManager.createTool(this.currentTool,event);;
		   		addNewLine(temporaryLine,node);
		   		this.drawLine=true;
	   	  }
	   	else
		   	{
		   		var nodename:String=node.name;
		   		this.setSelectState(nodename,"node");
		   	}
	   		event.stopPropagation();
	   }
	   
	   
	   /**
	    * 鼠标在节点上放开 
	    * @param event
	    * 
	    */	   
	   protected function nodeMouseUp(event:MouseEvent):void
	   {
	   		
	       var node:Node=event.currentTarget as Node;
	   	   if(currentTool!=null&&this.temporaryLine!=null)
	   	   {
		   		node.isSelect=false;
		   		this.drawLine=false;
		   		this.drawLineEnd = false;
		   		var linedata1:LineData = this.workFlowData.getLineData(this.temporaryLine.startName+this.temporaryLine.endName);
		   		if(event.target==this.getChildByName(this.temporaryLine.startName)||linedata1!=null)
		   		{
		   			removeLine(this.temporaryLine);
		   			this.temporaryLine = null;
		   		}
		   		else//线条添加成功
		   		{
		   			addLineName(this.temporaryLine,this.temporaryLine.startName+this.temporaryLine.endName);
		   			this.temporaryLine.endX = node.x+node.width/2;
		   			this.temporaryLine.endY = node.y+node.height/2;
		   			this.temporaryLine.invalidateDisplayList();
		   			this.temporaryLine.workflowdata = this.workFlowData;
		   			var linedata:LineData = new LineData();
		   				linedata.fromNodeId = this.temporaryLine.startName;
		   				linedata.toNodeId = this.temporaryLine.endName;
		   				linedata.lineType = this.currentTool;		   			
		   			var linep:LineProperty = new LineProperty();
		   			linedata.lineProperty = linep;
		   			
		   			linedata = this.workFlowData.newLineData(linedata.fromNodeId,linedata.toNodeId,linedata.lineType,linedata.lineProperty)
		   			addEventListern(this.temporaryLine);
		   			this.temporaryLine=null;
		   			//线添加成功 弹出条件设置
		   			var linePUP:LinePropertyUpdataWin = new LinePropertyUpdataWin();
		   				 linePUP.linedate = linedata;
		   			PopUpManager.addPopUp(linePUP,Application.application as DisplayObject,true);
		   			PopUpManager.centerPopUp(linePUP);
		   			
		   		}
	   	  }
	   		event.stopPropagation();
	   }
		/**
		 * 鼠标移开
		 * @param event
		 * @return 
		 * 
		 */		
		protected function nodeMouseOut(event:MouseEvent):void
		{
			var node:Node=event.currentTarget as Node;
			if(!node.isSelect)
			{
				if(this.currentTool!=null)
				{
					node.isSelect=false;
				}
				else
				{
					node.isSelect=true;
				}
			}
			if(this.drawLineEnd)
			{
				this.drawLineEnd=false;
			}
		
		
		}
		/**
		 * 节点右键（如果选中了划线，那么右键是无效的）
		 * @param event
		 * @return 
		 * 
		 */		
		protected function nodeRightClick(event:NodeEvent):void
		{
			var node:Node =event.currentTarget as  Node;
	   		if(this.currentTool!=null)
	   		{
	   			node.isSelect=false;
	   		}
	   		else
	   		{
	   			setSelectState(node.name,"node");
	   		}
		}
		
		
		
		
		
		
		 /**
	      * 设置为当前 右键 
	      * @param event
	      * @return 
	      * 
	      */	     
	     
	     public function setCurrentClick(event:NodeEvent):void
	     {
	     	var makelisten:Function=function(e:CloseEvent):void
			{
				if(e.detail==Alert.OK||e.detail==Alert.YES)
				{
					closeHandler(event);
				}
			}
	     	Alert.show("你确定要把选中环节设为【当前运行环节】，设置后将不能在修改。","提示",2|4,this,closeHandler);
	     }
	     
	     private function closeHandler(event:NodeEvent):void
	     {
	     	var nodename:String=event.currentTarget.name;
		    var nodedata:NodeData=this.workFlowData.getNodeData(nodename);
		    var fromNodeLineDatas:Array=this.workFlowData.qryLineDataByFromNodeId(nodename);//上级步骤 全部作为完成
			var toNodeLineDatas:Array=this.workFlowData.qryLineDataByToNodeId(nodename);//下级步骤等待选择
			
			for(var j:int=0;j<toNodeLineDatas.length;j++)
				{
					var toLineData3:LineData=toNodeLineDatas[j];
					var toLineDataId3:String=toLineData3.id;
					var getToLine3:DrawingTool=DrawingTool(this.getChildByName(toLineDataId3));
					if(getToLine3!=null)
					{
						getToLine3.lineState = NodeStyleSource.noExecute;
					}
				}
	     }
	     /**
	      * 当前环节完成 右键
	      * @param event
	      * @return 
	      * 
	      */	     
	     
	     public function completeCurrentClick(event:NodeEvent):void
	     {
			var nodename:String=event.currentTarget.name;
		    var nodedata:NodeData=this.workFlowData.getNodeData(nodename);
		    var fromNodeLineDatas:Array=this.workFlowData.qryLineDataByFromNodeId(nodename);//上级步骤 全部作为完成
			var toNodeLineDatas:Array=this.workFlowData.qryLineDataByToNodeId(nodename);//下级步骤等待选择
			
	     	var comUpdate:SetCurrentStepUpdataWin = new SetCurrentStepUpdataWin();
	     		comUpdate.nodedate = nodedata;
	     		comUpdate.fromNodeLineDatas = fromNodeLineDatas;
	     		comUpdate.toNodeLineDatas = toNodeLineDatas;
	     		comUpdate.parentView = this;
	     		
			   PopUpManager.addPopUp(comUpdate,Application.application as DisplayObject,true);
			   PopUpManager.centerPopUp(comUpdate);
	     }		
		
		
		/**
	      * 跳过当前环节完成 右键
	      * @param event
	      * @return 
	      * 
	      */	     
	     
	     public function passCurrentClick(event:NodeEvent):void
	     {
//	     	this.dispatchEvent(new NodeEvent(NodeEvent.PASSCURRENT_CLICK));
	     }		
		
		
		
		
		/**
		 * 节点选着了 删除，删除对应的连线
		 * @param event
		 * @return 
		 * 
		 */		
		protected function nodeDeleteClick(event:NodeEvent):void
		{
			
		  	var node:Node=event.currentTarget as  Node;
		    var eventWfNodeName:String=event.currentTarget.name;
			var fromNodeLineDatas:Array=this.workFlowData.qryLineDataByFromNodeId(eventWfNodeName);
			var toNodeLineDatas:Array=this.workFlowData.qryLineDataByToNodeId(eventWfNodeName);
			for(var i:int=0;i<fromNodeLineDatas.length;i++)
			{
				var formLineData:LineData=fromNodeLineDatas[i];
				var formLineDataId:String=formLineData.id;
				var getFromLine:DrawingTool=DrawingTool(this.getChildByName(formLineDataId));
				if(getFromLine!=null)
				{
					this.removeLine(getFromLine);
				}
			}
			for(var j:int=0;j<toNodeLineDatas.length;j++)
			{
				var toLineData:LineData=toNodeLineDatas[j];
				var toLineDataId:String=toLineData.id;
				var getToLine:DrawingTool=DrawingTool(this.getChildByName(toLineDataId));
				if(getToLine!=null)
				{
					this.removeLine(getToLine);
				}
			}
			
			if(node!=null)
			{
				removeNode(node);
				node = null;
			}
			this.workFlowData.delNodeData(eventWfNodeName);
			var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.nodeDel);
          	wrokFlowDesignEvent.nodeId=eventWfNodeName;
          	this.dispatchEvent(wrokFlowDesignEvent);	//派发删除节点
		}
		/**
		 * 节点属性设置
		 * @param event
		 * @return 
		 * 
		 */		
		protected function nodePropertyClick(event:NodeEvent):void
		{
		  var node:Node=event.currentTarget as  Node;
		  var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.nodeProperty);
          wrokFlowDesignEvent.nodeId=node.name;
          this.dispatchEvent(wrokFlowDesignEvent);
			var nodeData:NodeData = this.workFlowData.getNodeData(node.id);
          		nodePropertyUpdata(node,nodeData);
		}
		
		/**
		 * 双击节点  派发设置属性 事件
		 * @param event
		 * 
		 */		
		protected function nodeMouseDoubleClick(event:MouseEvent):void
		{
			if(this.currentTool!=null)
			{
			}
			else
			{
				var node:Node=event.currentTarget as  Node;
		  		var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.nodeProperty);
          		wrokFlowDesignEvent.nodeId=node.name;
          		this.dispatchEvent(wrokFlowDesignEvent);
          		var nodeData:NodeData = this.workFlowData.getNodeData(node.id);
          		nodePropertyUpdata(node,nodeData);
			}
		}
		
		protected function nodePropertyUpdata(target:Node,targetDate:NodeData):void
		{
			var updata:NodePropertyUpdataWin = new NodePropertyUpdataWin();
				updata.ParentNode = target;
				updata.nodedate = targetDate;
				PopUpManager.addPopUp(updata,Application.application as DisplayObject);
				PopUpManager.centerPopUp(updata);
		}
		
		/**
		 * 节点大小size改变 ，更新线段
		 * @param event
		 * 
		 */		
		public function nodeResize(event:ResizeEvent):void
		{
		}
		
		
		/**
		 * 节点拖动 
		 * @param event
		 * 
		 */		
		public function nodeDrageStart(event:NodeEvent):void
		{
			this.drageName=event.currentTarget.name;
		}
		
		/**
		 * 节点停止拖动 
		 * @param event
		 * 
		 */		
		public function nodeDrageStop(event:NodeEvent):void
		{
			if(this.drageName!=null)
			{
				this.drageName=null;
			}
			
		}
		
		
		
		/**
		 * **************************************线操作************************************** 
		 *  增加新线条
		 * */
		 
		 private function addNewLine(value:DrawingTool,node:Node):void
		 {
        	value.startX=node.x+node.width/2;
	   		value.startY=node.y+node.height/2;
	   		value.endX=this.contentMouseX;
	   		value.endY=this.contentMouseY;
	   		value.startName=node.name;
	   		this.addChildAt(value,0);
		 }
		 
		 private function addLineName(value:DrawingTool,name:String):void
		 {
		 	value.name = name;
		 }
		 private function addEventListern(value:DrawingTool):void
		 {
		 	value.addEventListener(MouseEvent.MOUSE_DOWN,lineMouseDowonH);
//	 		value.addEventListener(MouseEvent.MOUSE_OVER,lineMouseOverH);
//          value.addEventListener(MouseEvent.MOUSE_OUT,lineMouseOutH);
       		value.addEventListener(MouseEvent.DOUBLE_CLICK,lineMouseDoubleClickH);
       		value.addEventListener(LineEvent.rightClick,lineRightClickH);
        	value.addEventListener(LineEvent.deleteClick,lineDeleteClickH);
        	value.addEventListener(LineEvent.propertyClick,linePropertyClickH);
		 }
		
		/**
		 * 
		 * 删除线条
		 * */
		private function removeLine(value:DrawingTool):void
		{
			value.clear();
			value.removeEventListener(MouseEvent.MOUSE_DOWN,lineMouseDowonH);
//			value.removeEventListener(MouseEvent.MOUSE_OVER,lineMouseOverH);
//          value.removeEventListener(MouseEvent.MOUSE_OUT,lineMouseOutH);
       		value.removeEventListener(MouseEvent.DOUBLE_CLICK,lineMouseDoubleClickH);
       		value.removeEventListener(LineEvent.rightClick,lineRightClickH);
        	value.removeEventListener(LineEvent.deleteClick,lineDeleteClickH);
        	value.removeEventListener(LineEvent.propertyClick,linePropertyClickH);
        	this.removeChild(value);
        	value = null;
		}
		
		
		 /**
	   	 * 线 鼠标按下
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */
	   	private function lineMouseDowonH(event:MouseEvent):void
	   	{
	   		var line:DrawingTool=event.currentTarget as DrawingTool;
	   		var lineName:String=line.name;
	   		    if(this.currentTool==null)
	   		    {
	   		    	line.uiSelect=true;
					setSelectState(lineName,"line");
	   		    }
				event.stopPropagation();
	   	}
	   	/**
	   	 * 线 右键
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function lineRightClickH(event:LineEvent):void
	   	{
	   		var line:DrawingTool=event.currentTarget as DrawingTool;
	   		setSelectState(line.name,"line");
	   		event.stopPropagation();
	   	}
	   	/**
	   	 * 线 右键删除
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function lineDeleteClickH(event:LineEvent):void
	   	{
	   		var line:DrawingTool=event.currentTarget as DrawingTool;
	   		if(line!=null)
	   		{
	   			var lineData:LineData=this.workFlowData.getLineData(line.name);
	   			removeLine(line);
	   			this.workFlowData.delLineData(line.name);
	   			var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.lineDel);
          		wrokFlowDesignEvent.lineData=lineData;
          		this.dispatchEvent(wrokFlowDesignEvent);
	   		}
	   		
	   	}
	   	/**
	   	 * 线 右键属性
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function linePropertyClickH(event:LineEvent):void
	   	{
	   		var line:DrawingTool=event.currentTarget as DrawingTool;
	   		if(line!=null)
	   		{
	   			var lineData:LineData=this.workFlowData.getLineData(line.name);
	   			var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.lineProPerty);
          		wrokFlowDesignEvent.lineData=lineData;
          		this.dispatchEvent(wrokFlowDesignEvent);
          		linePropertyUpdata(lineData)
      		}
	   	}
	   	/**
	   	 * 线 双击
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function lineMouseDoubleClickH(event:MouseEvent):void
	   	{
	   		if(this.currentTool==null)
	   		{
	   			var line:DrawingTool=event.currentTarget as DrawingTool;
	   			if(line!=null)
	   			{
	   				var lineData:LineData=this.workFlowData.getLineData(line.name);
	   				var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.lineProPerty);
          			wrokFlowDesignEvent.lineData=lineData;
          			this.dispatchEvent(wrokFlowDesignEvent);
    
          			linePropertyUpdata(lineData)
      			}
      		}
	   	}
	   	
	   	protected function linePropertyUpdata(targetDate:LineData):void
		{
			var updata:LinePropertyUpdataWin = new LinePropertyUpdataWin();
				updata.linedate = targetDate;
				PopUpManager.addPopUp(updata,Application.application as DisplayObject);
				PopUpManager.centerPopUp(updata);
		}
	   	
		
	}
}