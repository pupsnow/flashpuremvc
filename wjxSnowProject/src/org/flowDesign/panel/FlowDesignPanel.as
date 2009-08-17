package org.flowDesign.panel
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;
	import mx.managers.DragManager;
	
	import org.flowDesign.data.LineData;
	import org.flowDesign.data.NodeData;
	import org.flowDesign.data.WorkFlowData;
	import org.flowDesign.data.WorkFlowDataProvider;
	import org.flowDesign.event.NodeEvent;
	import org.flowDesign.event.WrokFlowDesignEvent;
	import org.flowDesign.layout.DrawingTool;
	import org.flowDesign.layout.DrawingToolManager;
	import org.flowDesign.layout.IFlowUI;
	import org.flowDesign.layout.Node;

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
		
		public function set dataProvider(dataProvider:XML):void
		{
			this.workFlowData.dataProvider=dataProvider;
		}
		public function get dataProvider():XML
		{
			return this.workFlowData.dataProvider;
		}
		
		/**
		 * 整个流程图内的数据保存
		 * 
		 * */
		private var _workFlowDataProvider:WorkFlowDataProvider;
		
		[Bindable]
		public function set DataProvider(value:XML):void
		{
			this._workFlowDataProvider.dataProvider=value;
		}
		
		public function get DataProvider():XML
		{
			return	this._workFlowDataProvider.dataProvider;
		}
		 
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
		 public var _inFrist:Boolean=false;
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
		 public var _drageName:String=null;
		 public function set drageName(value:String):void
		 {
		 	this._drageName=value;
		 } 
		 public function get drageName():String
		 {
		 	return this._drageName;
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
			if(this.selectObject[0]!=null)
			{
				var selectObjectName:String=this.selectObject[0].name;
				var slectObjectType:String=this.selectObject[0].type;
				var selectedUI:IFlowUI= this.getChildByName(selectObjectName) as IFlowUI;
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
										this.width=this.width+node.width;
									}
									if(mouseY+node.height>this.height)
									{
										this.height=this.height+node.height;	
										
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
						this.temporaryLine.clear();
						this.removeChild(this.temporaryLine);
						this.temporaryLine = null;
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
					this.temporaryLine.clear();
					this.removeChild(this.temporaryLine);
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
			var icon:Class = event.dragSource.dataForFormat('icon') as Class;
			var lable:String = event.dragSource.dataForFormat('lable') as String;
			var typename:String=event.dragSource.dataForFormat('typename') as String;
			var typeId:String=event.dragSource.dataForFormat('typeId') as String;
			var x:Number=event.localX-this.x-dragemouse.x;
			var y:Number=event.localY-this.y-dragemouse.y;
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
			var	nodeData:NodeData=workFlowData.newNode(name,type,typeId,x,y);
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
            wfNode.doubleClickEnabled=true;
			return wfNode;
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
          if(nodeEvent.x+nodeEvent.width>(this.x+this.width))
		      {
		      	this.width=this.width+(nodeEvent.x-this.width)+nodeEvent.width+10;//增加画布宽
		      }
          if(nodeEvent.y+nodeEvent.height>(this.y+this.height))
            {
          	this.height=this.height+(nodeEvent.y-this.height)+nodeEvent.height+10;//增加画布宽
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
		   		this.temporaryLine.startX=node.x+node.width/2;
		   		this.temporaryLine.startY=node.y+node.height/2;
		   		this.temporaryLine.endX=this.contentMouseX;
		   		this.temporaryLine.endY=this.contentMouseY;
		   		this.temporaryLine.startName=node.name;
		   		this.addChildAt(temporaryLine,0);
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
	   	   if(currentTool!=null)
	   	   {
		   		node.isSelect=false;
		   		this.drawLine=false;
		   		this.drawLineEnd = false;
		   		var linedata1:LineData = this.workFlowData.getLineData(this.temporaryLine.startName+this.temporaryLine.endName);
		   		if(event.target==this.getChildByName(this.temporaryLine.startName)||linedata1!=null)
		   		{
		   			 this.temporaryLine.clear();
		   			 this.removeChild(this.temporaryLine);
		   			 this.temporaryLine=null;
		   		}
		   		else
		   		{
		   			this.temporaryLine.name = this.temporaryLine.startName+this.temporaryLine.endName;
		   			this.temporaryLine.workflowdata = this.workFlowData;
		   			var linedata:LineData = new LineData();
		   				linedata.fromNodeId = this.temporaryLine.startName;
		   				linedata.toNodeId = this.temporaryLine.endName;
		   				linedata.lineLabelText = "111";
		   				linedata.lineType = "line";
		   			this.temporaryLine.addNewLine(linedata);
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
					this.removeChild(getFromLine);
//					var fromLineLabel:LineLabel=LineLabel(this.getChildByName(formLineData.lineLabelId)); 
//					if(fromLineLabel!=null)
//					{
//						this.removeChild(fromLineLabel);
//					}
				}
			}
			for(var j:int=0;j<toNodeLineDatas.length;j++)
			{
				var toLineData:LineData=toNodeLineDatas[j];
				var toLineDataId:String=toLineData.id;
				var getToLine:DrawingTool=DrawingTool(this.getChildByName(toLineDataId));
				if(getToLine!=null)
				{
					this.removeChild(getToLine);
//					var toLineLabel:LineLabel=LineLabel(this.getChildByName(toLineData.lineLabelId)); 
//					if(toLineLabel!=null)
//					{
//						this.removeChild(toLineLabel);
//					}
				}
			}
			
			if(node!=null)
			{
				this.removeChild(node);
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
			}
		}
		
		
		/**
		 * 设置节点的名称 
		 * @param nodeId
		 * @param label
		 * 
		 */		
		public function setNodeLabel(nodeId:String,label:String):void
		{
//			if(nodeId!=null)
//			{
//				var wfNodeEvent:WfNode=WfNode(this.getChildByName(nodeId));
//			    if(wfNodeEvent!=null)
//			    {
//			    	wfNodeEvent.label=label;
//			    }
//			}
			
		}
		/**
		 * 节点大小size改变 ，更新线段
		 * @param event
		 * 
		 */		
		public function nodeResize(event:ResizeEvent):void
		{
//			var wfNodeEvent:WfNode=event.currentTarget as WfNode;
//			if(wfNodeEvent!=null)
//			{
//				var getNodeName:String=wfNodeEvent.name;
//				var getNodeFromLine:Array=this.workFlowData.qryLineDataByFromNodeId(getNodeName);
//				for(var i:int=0;i<getNodeFromLine.length;i++)
//				{
//				    var fromLineData:LineData=LineData(getNodeFromLine[i]);
//				    if(fromLineData!=null)
//				    {
//				    	this.lineRefash(fromLineData);
//				    }
//				 }
//				 var getNodeToLine:Array=this.workFlowData.qryLineDataByToNodeId(getNodeName);
//				 for(var j:int=0;j<getNodeToLine.length;j++)
//				 {
//				    var toLineData:LineData=LineData(getNodeToLine[j]);
//				    if(toLineData!=null)
//				    {
//				    	this.lineRefash(toLineData);
//				    }
//				}
//			}
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

		
	}
}