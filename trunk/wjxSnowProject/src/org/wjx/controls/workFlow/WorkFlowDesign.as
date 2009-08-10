package  org.wjx.controls.workFlow
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.MoveEvent;
	
	import org.wjx.common.HashMap;
	import org.wjx.controls.workFlow.workFlowClasses.LineData;
	[Event (name="nodeComplete", type="org.wjx.controls.workFlow.workFlowEvent.WrokFlowDesignEvent")]
	[Event (name="lineCpmplete", type="org.wjx.controls.workFlow.workFlowEvent.WrokFlowDesignEvent")]
	[Event (name="nodeDel", type="org.wjx.controls.workFlow.workFlowEvent.WrokFlowDesignEvent")]
	[Event (name="lineDel", type="org.wjx.controls.workFlow.workFlowEvent.WrokFlowDesignEvent")]
	[Event (name="nodeMove", type="org.wjx.controls.workFlow.workFlowEvent.WrokFlowDesignEvent")]
	[Event (name="nodeProperty", type="org.wjx.controls.workFlow.workFlowEvent.WrokFlowDesignEvent")]
	[Event (name="lineProPerty", type="org.wjx.controls.workFlow.workFlowEvent.WrokFlowDesignEvent")]
	
	public class WorkFlowDesign extends Canvas
	{	
		import org.wjx.controls.workFlow.workFlowClasses.WorkFlowData;
		import org.wjx.controls.workFlow.workFlowClasses.NodeData;
		import org.wjx.controls.workFlow.workFlowClasses.WfNode;
		import org.wjx.controls.workFlow.workFlowClasses.Line;
		import org.wjx.controls.workFlow.workFlowClasses.TemporaryLine;
		import org.wjx.controls.workFlow.workFlowEvent.NodeEvent;
		import org.wjx.controls.workFlow.workFlowEvent.LineEvent;
		import org.wjx.controls.workFlow.workFlowClasses.LineLabel;
		import org.wjx.controls.workFlow.workFlowClasses.WorkFlowDataProvider;
		import org.wjx.controls.workFlow.workFlowEvent.WrokFlowDesignEvent;
		import mx.events.ResizeEvent;
		
		import  flash.events.MouseEvent;
		import  mx.events.FlexEvent;
		import mx.controls.Alert;
		
		private var temporaryLine:TemporaryLine=new TemporaryLine();
		public function WorkFlowDesign()
		{
			workFlowData=new WorkFlowData(this);
			_workFlowDataProvider=new WorkFlowDataProvider(this);
			this.addEventListener(MouseEvent.MOUSE_OUT,designMouseOut);	
			this.addEventListener(MouseEvent.MOUSE_DOWN,designMouseDowon);
			this.addEventListener(MouseEvent.MOUSE_MOVE,designMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP,designMouseUp);
			this.toolSelectValue="move";
		    temporaryLine.clear();
			this.addChild(temporaryLine);
			
		}
		/**
		 *属性设置 
		 **/
		 
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
		
		private  function set workFlowDataProvider(value:WorkFlowDataProvider):void
		{
			this._workFlowDataProvider=value;   		
		} 
		private function get workFlowDataProvider():WorkFlowDataProvider
		{
			return this._workFlowDataProvider;	
		}
		 
		 /**
		 * 记录选择的工具对像 move移动工具 line直线工具 curveLine回退线工具
		 */
		 private var _toolSelectValue:String;
		 public function set toolSelectValue(value:String):void
		 {
		 	this.clearSelectObject();
		 	this._toolSelectValue=value;
		 } 
		 public function get toolSelectValue():String
		 {
		 	return this._toolSelectValue;
		 }
		 
		 /**
		  *记录当前所选对像的名称与类型 name type（画板中的）
		  */		 
		 private var _selectObject:Array=new Array();
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

		/*********************************************************************
		 * 
		 *                          EVENT
		 * 
		 ******************************************************************/		
		  
		  
		  /*********************************************************************
		 * 
		 *                         节点操作
		 * 
		 ******************************************************************/	
		  
		/**
		 * 节点操作（获取一个节点数据）
		 **/
		public function getNodeData(nodeName:String):NodeData
		{
			var nodeDatas:HashMap=workFlowData.nodeDatas;
			var nodeData:NodeData=nodeDatas.getKey(nodeName);
			return nodeData;
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
		public function newNode(name:String,type:String,x:int,y:int,typeId:String):void
		{
			var	nodeData:NodeData=workFlowData.newNode(name,type,typeId,x,y);
		   	var nodeControl:UIComponent=newNodeControl(nodeData);
			this.addChild(nodeControl);   
		}
		/**
		 * 外部接口（）
		 * @param nodeData
		 * @return 
		 * 
		 */		
		public function newNodeChild(nodeData:NodeData):Boolean
		{
			var nodeId:String=this.workFlowData.nodeId;
			this.workFlowData.nodeDatas.put(nodeData.id,nodeData);
			var nodeControl:UIComponent=newNodeControl(nodeData);
			this.addChild(nodeControl); 
			return true;
		}
		
		
		/**
		 * 生成一个节点（拖动，获取更具数据）
		 * @param nodeData
		 * @return 
		 * 
		 */		
		protected function newNodeControl(nodeData:NodeData):UIComponent
		{
			var wfNode:WfNode=new WfNode();
			wfNode.label=nodeData.name;
			wfNode.id=nodeData.id
			wfNode.name=nodeData.id;
			wfNode.type=nodeData.type;
			wfNode.data=nodeData.id;
			wfNode.nodeState=nodeData.nodeState;
			if(!this.inFrist)
			{
				wfNode.x=this.contentMouseX;
				wfNode.y=this.contentMouseY;
			}
			else
			{
				wfNode.x=nodeData.x;
				wfNode.y=nodeData.y;
			}
            wfNode.addEventListener(FlexEvent.CREATION_COMPLETE,nodeCreationComplete);
            wfNode.addEventListener(MouseEvent.MOUSE_OVER,nodeMouseOver);
            wfNode.addEventListener(MouseEvent.MOUSE_DOWN,nodeMouseDown);
            wfNode.addEventListener(MouseEvent.MOUSE_OUT,nodeMouseOut);
            wfNode.addEventListener(ResizeEvent.RESIZE,nodeResize);
            wfNode.addEventListener(NodeEvent.rightClick,nodeRightClick);
            wfNode.addEventListener(NodeEvent.deleteClick,nodeDeleteClick);
            wfNode.addEventListener(NodeEvent.propertyClick,nodePropertyClick);
            wfNode.addEventListener(MouseEvent.DOUBLE_CLICK,nodeMouseDoubleClick);
           	wfNode.addEventListener(MoveEvent.MOVE,nodeMove); 
           	wfNode.addEventListener(NodeEvent.nodeStartDrage,nodeDrageStart);
           	wfNode.addEventListener(NodeEvent.nodeStopDrage,nodeDrageStop);
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
		  var nodeEvent:WfNode=event.currentTarget as WfNode;
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
			var nodeEvent:WfNode=event.currentTarget as WfNode;
			var nodeEventName:String=nodeEvent.name;
		    var nodeData:NodeData=this.workFlowData.getNodeData(nodeEventName);
		   	nodeData.x=nodeEvent.x;
		    nodeData.y=nodeEvent.y;
		   	var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent("nodeMove");
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
		 	var wfNodeEvent:WfNode=event.currentTarget as WfNode;
			if(this.toolSelectValue=="line" || this.toolSelectValue=="curveLine" )
				{
				  wfNodeEvent.isSelect=false;
				  if(this.drawLine)/**划线结束的时候 */
				  {
				  	   var wfNodeEventName:String=wfNodeEvent.name;
				  	   if(this.temporaryLine.startName!=wfNodeEventName)
				  	   {
				  	   	   this.temporaryLine.endName=wfNodeEventName;
				  	       this._drawLineEnd=true;
				  	   }
				  }
				}
			else
				{
					 wfNodeEvent.isSelect=true;
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
	       var wfNodeEvent:WfNode=event.currentTarget as WfNode;
	   	   if(this.toolSelectValue=="line" || this.toolSelectValue=="curveLine" )
	   	   {
		   		wfNodeEvent.isSelect=false;
		   		this.temporaryLine.startX=wfNodeEvent.x+wfNodeEvent.width/2;
		   		this.temporaryLine.startY=wfNodeEvent.y+wfNodeEvent.height/2;
		   		this.temporaryLine.endX=this.contentMouseX;
		   		this.temporaryLine.endY=this.contentMouseY;
		   		this.temporaryLine.startName=wfNodeEvent.name;
		   		if(this.toolSelectValue=="line")
		   		{
		   			this.temporaryLine.lineType=0;
		   		}
		   		if(this.toolSelectValue=="curveLine")
		   		{
		   			this.temporaryLine.lineType=1;	
		   		}
		   		this.temporaryLine.drawLine();
		   		this.drawLine=true;
	   	  }
	   	else
		   	{
		   		var wfNodeName:String=wfNodeEvent.name;
		   		this.setSelectState(wfNodeName,"node");
		   		
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
			var wfNodeEvent:WfNode=event.currentTarget as WfNode;
			if(!wfNodeEvent.isSelect)
			{
				if(this.toolSelectValue=="line" || this.toolSelectValue=="curveLine" )
				{
					wfNodeEvent.isSelect=false;
				}
				else
				{
					wfNodeEvent.isSelect=true;
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
			
	   		if(this.toolSelectValue=="line" || this.toolSelectValue=="curveLine" )
	   		{
	   			var eventWfNode:WfNode=event.currentTarget as  WfNode;
	   			eventWfNode.isSelect=false;
	   			
	   		}
	   		else
	   		{
	   			var eventWfNode2:WfNode=event.currentTarget as  WfNode;
	   			setSelectState(eventWfNode2.name,"node");
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
			
		  	var eventWfNode:WfNode=event.currentTarget as  WfNode;
		    var eventWfNodeName:String=event.currentTarget.name;
			var fromNodeLineDatas:Array=this.workFlowData.qryLineDataByFromNodeId(eventWfNodeName);
			var toNodeLineDatas:Array=this.workFlowData.qryLineDataByToNodeId(eventWfNodeName);
			for(var i:int=0;i<fromNodeLineDatas.length;i++)
			{
				var formLineData:LineData=fromNodeLineDatas[i];
				var formLineDataId:String=formLineData.id;
				var getFromLine:Line=Line(this.getChildByName(formLineDataId));
				if(getFromLine!=null)
				{
					this.removeChild(getFromLine);
					var fromLineLabel:LineLabel=LineLabel(this.getChildByName(formLineData.lineLabelId)); 
					if(fromLineLabel!=null)
					{
						this.removeChild(fromLineLabel);
					}
				}
			}
			for(var j:int=0;j<toNodeLineDatas.length;j++)
			{
				var toLineData:LineData=toNodeLineDatas[j];
				var toLineDataId:String=toLineData.id;
				var getToLine:Line=Line(this.getChildByName(toLineDataId));
				if(getToLine!=null)
				{
					this.removeChild(getToLine);
					var toLineLabel:LineLabel=LineLabel(this.getChildByName(toLineData.lineLabelId)); 
					if(toLineLabel!=null)
					{
						this.removeChild(toLineLabel);
					}
				}
			}
			
			if(eventWfNode!=null)
			{
				this.removeChild(eventWfNode);
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
		  var wfNodeEvent:WfNode=event.currentTarget as  WfNode;
		  var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.nodeProperty);
          wrokFlowDesignEvent.nodeId=wfNodeEvent.name;
          this.dispatchEvent(wrokFlowDesignEvent);
		
		}
		
		/**
		 * 双击节点  派发设置属性 事件
		 * @param event
		 * 
		 */		
		protected function nodeMouseDoubleClick(event:MouseEvent):void
		{
			if(this.toolSelectValue=="line" || this.toolSelectValue=="curveLine" )
			{
			}
			else
			{
				var wfNodeEvent:WfNode=event.currentTarget as  WfNode;
		  		var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.nodeProperty);
          		wrokFlowDesignEvent.nodeId=wfNodeEvent.name;
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
			if(nodeId!=null)
			{
				var wfNodeEvent:WfNode=WfNode(this.getChildByName(nodeId));
			    if(wfNodeEvent!=null)
			    {
			    	wfNodeEvent.label=label;
			    }
			}
			
		}
		/**
		 * 节点大小size改变 ，更新线段
		 * @param event
		 * 
		 */		
		public function nodeResize(event:ResizeEvent):void
		{
			var wfNodeEvent:WfNode=event.currentTarget as WfNode;
			if(wfNodeEvent!=null)
			{
				var getNodeName:String=wfNodeEvent.name;
				var getNodeFromLine:Array=this.workFlowData.qryLineDataByFromNodeId(getNodeName);
				for(var i:int=0;i<getNodeFromLine.length;i++)
				{
				    var fromLineData:LineData=LineData(getNodeFromLine[i]);
				    if(fromLineData!=null)
				    {
				    	this.lineRefash(fromLineData);
				    }
				 }
				 var getNodeToLine:Array=this.workFlowData.qryLineDataByToNodeId(getNodeName);
				 for(var j:int=0;j<getNodeToLine.length;j++)
				 {
				    var toLineData:LineData=LineData(getNodeToLine[j]);
				    if(toLineData!=null)
				    {
				    	this.lineRefash(toLineData);
				    }
				}
			}
		}
		
		
		/**
		 * 节点拖动 
		 * @param event
		 * 
		 */		
		public function nodeDrageStart(event:NodeEvent):void
		{
			trace("nodeDrageStart");
			trace(event.currentTarget.name);
			this.drageName=event.currentTarget.name;
		}
		
		/**
		 * 节点停止拖动 
		 * @param event
		 * 
		 */		
		public function nodeDrageStop(event:NodeEvent):void
		{
			trace("nodeDrageStop");
			if(this.drageName!=null)
			{
				this.drageName=null;
			}
			
			
			
		}
	   /*************************************************************************************
	   * 	
	   * 									线操作
	   * 
	   * 							
	   ************************************************************************************** */	
	   	
	   	/**
	   	 * 增加新的线段 
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function newLineControl():Boolean
	   	{
	   		var lineData:LineData=new LineData();
	   		lineData.fromNodeId=this.temporaryLine.startName;
	   		lineData.toNodeId=this.temporaryLine.endName;
	   		if(this.toolSelectValue=="curveLine")
	   		{
	   			lineData.lineType="curveLine";
	   		}
	   		else
	   		{
	   			lineData.lineType="line";
	   		}
	   		this.newLineChild(lineData);
	   		return true;
	   	}
	   	public  function newLineChild(lineData:LineData):void
	   	{
	   		var line:Line=this.newLine(lineData);
	   		if(line!=null)
	   		{
	   			this.addChild(line);
	   		}
	   	}
	   	/**
	   	 * 创建一个新线条	
	   	 * @param lineData
	   	 * @return 
	   	 * 
	   	 */	   	
	   
	   	private function newLine(lineData:LineData):Line
	   	{
	    	
	    	var fromNodeId:String=lineData.fromNodeId;
	   		var toNodeId:String=lineData.toNodeId;
	   		var lineId:String=fromNodeId+toNodeId;
	   		var line:Line=null;
	   		if(this.getChildByName(lineId)==null)
	   		{
	   		 	line=new Line();
	   			var fromNode:WfNode=WfNode(this.getChildByName(fromNodeId));
	   			var toNode:WfNode=WfNode(this.getChildByName(toNodeId));
	   			fromNode.isSelect=false;
	   			toNode.isSelect=false;
	   			var lineText:String=fromNode.label+toNode.label;
	   			var addNewLineData:LineData=this.workFlowData.newLineData(fromNode.name,toNode.name,lineText,lineData.lineType);
	   			line.id=lineId;
	   			line.name=lineId;
	   			line.startX=fromNode.x;
	   			line.startY=fromNode.y;
	   			line.lineState=lineData.lineState;
	   			
				//计算箭头终点坐标公式
				 ////trace(fromNode.width);
	   			var fromX:int=fromNode.x+(fromNode.width/2);
	   			var fromY:int=fromNode.y+(fromNode.height/2);
	   			var toX:int=toNode.x+(toNode.width/2);
	   			var toY:int=toNode.y+(toNode.height/2);
	   		
	   			var endXY:Array=countLineXY(fromX,fromY,toX,toY,toNode.height,toNode.width);
	   			line.endX=endXY[0].x;
	   			line.endY=endXY[0].y;
	   			var startXY:Array=countLineXY(toX,toY,fromX,fromY,fromNode.height,fromNode.width);
	   			line.startX=startXY[0].x;
	   			line.startY=startXY[0].y;
	   		
	   			line.lineType=this.temporaryLine.lineType;
	   			line.middleX=this.temporaryLine.middleX;
	   			line.middleY=this.temporaryLine.middleY;
	   		
	       		
	       		line.addEventListener(MouseEvent.MOUSE_DOWN,lineMouseDowon);
	       		line.addEventListener(MouseEvent.DOUBLE_CLICK,lineMouseDoubleClick);
	       		line.addEventListener(LineEvent.rightClick,lineRightClick);
            	line.addEventListener(LineEvent.deleteClick,lineDeleteClick);
            	line.addEventListener(LineEvent.propertyClick,linePropertyClick);
            	//line.addEventListener(MouseEvent.MOUSE_OVER,lineMouseOver);
            	if(lineData.lineType=="curveLine")
            	{
            		line.lineType=1;
            	}
            	else
            	{
            		line.lineType=0;
	   				var lineLabelMiddleX:int=(startXY[0].x+endXY[0].x)/2;
            		var lineLabelMiddleY:int=(startXY[0].y+endXY[0].y)/2;
            		this.newLineLabel(addNewLineData.lineLabelId,addNewLineData.lineLabelText,lineLabelMiddleX,lineLabelMiddleY);
            	 	
            	}
            	if(!this.inFrist)
            	{
            		var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent("lineCpmplete");
          			wrokFlowDesignEvent.lineData=addNewLineData;
         			this.dispatchEvent(wrokFlowDesignEvent);
            	}
            }		
	        return line;
	   	}
	   	/**
	   	 * 	//线的名称
	   	 * @param id
	   	 * @param text
	   	 * @param middleX
	   	 * @param middleY
	   	 * @return 
	   	 * 
	   	 */	   	
	   
	   	private function newLineLabel(id:String,text:String,middleX:int,middleY:int):void
	   	{
	   		var lineLabel:LineLabel=new LineLabel();
	   		lineLabel.id=id;
	   		lineLabel.name=id;
	   		lineLabel.text=text;
	   		lineLabel.middleX=middleX;
	   		lineLabel.middleY=middleY;
	   		lineLabel.addEventListener(ResizeEvent.RESIZE,lineLabelResize);
	   		lineLabel.addEventListener(FlexEvent.CREATION_COMPLETE,lineLabelCreationComplete);
	   		lineLabel.refashXY();
	   		this.addChild(lineLabel);
	   	}
	   	/**
	   	 * 线上的label大小改变
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function lineLabelResize(event:ResizeEvent):void
	   	{
	   		var lineLabel:LineLabel=event.currentTarget as LineLabel;
	   		if(lineLabel!=null)
	   		{
	   			var lineLabelId:String=lineLabel.name;
	   			var lineData:LineData=this.workFlowData.qryLineDataByLineLable(lineLabelId);
	   		    this.lineRefash(lineData);
	   		}
	   		
	   	}
	   	/**
	   	 * 文本创建完毕
	   	 * @param event
	   	 * 
	   	 */	   	
	   	private function lineLabelCreationComplete(event:FlexEvent):void
	   	{
	   	 var lineLable:LineLabel=event.currentTarget as LineLabel;
	   		if(lineLable.x+lineLable.width>(this.x+this.width))
	   		{
          	this.width=this.width+(lineLable.x-this.width)+lineLable.width+10;/**增加面板宽  */
            }
            if(lineLable.y+lineLable.height>(this.y+this.height))
            {
          	this.height=this.height+(lineLable.y-this.height)+lineLable.height+10;/**增加面板高  */
          	}
	   	}
	   	/**
	   	 * 线 鼠标滑上
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function lineMouseOver(event:MouseEvent):void
	   	{
	   		if(this.toolSelectValue=="line" || this.toolSelectValue=="curveLine")
	   		{
	   			var eventLine:Line=event.currentTarget as Line;
	   			eventLine.lineSelect=false;
	   		}
	   		else
	   		{
	   			//eventLine.lineSelect=;
	   		}
	   		event.stopPropagation();
	   	}
	   	/**
	   	 * 线 鼠标按下
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */
	   	private function lineMouseDowon(event:MouseEvent):void
	   	{
	   		var lineEvent:Line=event.currentTarget as Line;
	   		var lineEventName:String=lineEvent.name;
	   		    if(this.toolSelectValue=="line" || this.toolSelectValue=="curveLine")
	   		    {
	   		    	
	   		    }
	   		    else
	   		    {
	   		    	lineEvent.lineSelect=true;
					setSelectState(lineEventName,"line");
	   		    }
				event.stopPropagation();
	   	}
	   	/**
	   	 * 线 右键
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function lineRightClick(event:LineEvent):void
	   	{
	   		var eventLine:Line=event.currentTarget as Line;
	   		setSelectState(eventLine.name,"line");
	   		event.stopPropagation();
	   	}
	   	/**
	   	 * 线 右键删除
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function lineDeleteClick(event:LineEvent):void
	   	{
	   		var lineEvent:Line=event.currentTarget as Line;
	   		if(lineEvent!=null)
	   		{
	   			var lineData:LineData=this.workFlowData.getLineData(lineEvent.name);
	   			var lineLableId:String=lineData.lineLabelId;
	   			var lineLable:LineLabel=LineLabel(this.getChildByName(lineLableId));
	   			if(lineLable!=null)
	   			{
	   				this.removeChild(lineLable);
	   			}
	   			this.removeChild(lineEvent);
	   			this.workFlowData.delLineData(lineEvent.name);
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
	   	private function linePropertyClick(event:LineEvent):void
	   	{
	   		var lineEvent:Line=event.currentTarget as Line;
	   		if(lineEvent!=null)
	   		{
	   			var lineData:LineData=this.workFlowData.getLineData(lineEvent.name);
	   			var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.lineProPerty);
          		wrokFlowDesignEvent.lineData=lineData;
          		this.dispatchEvent(wrokFlowDesignEvent);
      		}
	   	}
	   	/**
	   	 * 线 双击
	   	 * @param event
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function lineMouseDoubleClick(event:MouseEvent):void
	   	{
	   		if(this.toolSelectValue=="line" || this.toolSelectValue=="curveLine" )
	   		{
	   		}
	   		else
	   		{
	   			var lineEvent:Line=event.currentTarget as Line;
	   			if(lineEvent!=null)
	   			{
	   				var lineData:LineData=this.workFlowData.getLineData(lineEvent.name);
	   				var wrokFlowDesignEvent:WrokFlowDesignEvent=new WrokFlowDesignEvent(WrokFlowDesignEvent.lineProPerty);
          			wrokFlowDesignEvent.lineData=lineData;
          			this.dispatchEvent(wrokFlowDesignEvent);
      			}
      		}
	   	}
	   	
	    /**
	     * 计算线的 坐标等信息
	     * @param fromX
	     * @param fromY
	     * @param toX
	     * @param toY
	     * @param height
	     * @param width
	     * @return 
	     * 
	     */
	    private function countLineXY(fromX:int,fromY:int,toX:int,toY:int,height:int,width:int):Array
	    {
	    	var h:int=height;
			var w:int=width;
			var k:Number=(fromY-toY)/(fromX-toX);
			var b:Number=((toY*fromX)-(toX*fromY))/(fromX-toX);
			var A:Number=h/w;
			var x:int=0;
			var y:int=0;
			var l:int=0;
			var result:Array=new Array();
			if(Math.abs(k)>A)
			{
					
					 if(fromY>toY&&fromX!=toX)
					 {
						x=int(((toY+(h/2))-b)/k);
						y=int(toY+(h/2));
					}
					if(fromY<toY&&fromX!=toX)
					{
						x=int(((toY-(h/2))-b)/k);
						y=int(toY-(h/2));
					}
					if(k==Infinity)
					{
						x=toX;
						y=int(toY+(h/2));
					}
					if(k==-Infinity)
					{
						x=toX;
						y=int(toY-(h/2));
					}
					
				}
				else
				{
					if(fromX>toX)
					{
						x=int(toX+w/2);
						y=k*x+b;
					}
					if(fromX<toX)
					{
						x=int(toX-w/2);
						y=k*x+b;
					} 
				}
		
	 	result.push({x:x,y:y});
	 	return	result;
	    }
	   	/**
	   	 * 更新数据
	   	 * @param lineData
	   	 * @return 
	   	 * 
	   	 */	   	
	   	private function lineRefash(lineData:LineData):void
	   	{
	   	    var fromNodeId:String=lineData.fromNodeId;
	   	    var toNodeId:String=lineData.toNodeId;
	   	    var fromNode:WfNode=WfNode(this.getChildByName(fromNodeId));
	   	    var toNode:WfNode=WfNode(this.getChildByName(toNodeId));
	   	    var line:Line=Line(this.getChildByName(lineData.id));
	   		var fromX:int=fromNode.x+(fromNode.width/2);
	   		var fromY:int=fromNode.y+(fromNode.height/2);
	   		var toX:int=toNode.x+(toNode.width/2);
	   		var toY:int=toNode.y+(toNode.height/2);
	   		var endXY:Array=countLineXY(fromX,fromY,toX,toY,toNode.height,toNode.width);
			line.endX=endXY[0].x;
	   		line.endY=endXY[0].y;
	   		
	   		var startXY:Array=countLineXY(toX,toY,fromX,fromY,fromNode.height,fromNode.width);
			line.startX=startXY[0].x;
	   		line.startY=startXY[0].y;
	   		line.middleX=(fromX+toX)/2+100;
	   		line.middleY=(fromY+toY)/2+100; 
	   		line.lineRefash();
	   		
	   		var lineLabel:LineLabel=LineLabel(this.getChildByName(lineData.lineLabelId));
	   		if(lineLabel!=null){
	   		lineLabel.middleX=(startXY[0].x+endXY[0].x)/2;
	   		lineLabel.middleY=(startXY[0].y+endXY[0].y)/2;
	   		lineLabel.refashXY();
	   		}
		}
	   /**
	    * 设置线上文字
	    * @param lineId
	    * @param label
	    * @return 
	    * 
	    */	   	
	   public function setLineLabel(lineId:String,label:String):void
	   {
	   		if(lineId!=null)
	   		{
	   			var lineData:LineData=this.workFlowData.getLineData(lineId);
	   			var lineLabelId:String=lineData.lineLabelId;
	   			var lineLabel:LineLabel=LineLabel(this.getChildByName(lineLabelId));
	   			if(lineLabel!=null)
	   			{
	   				lineLabel.text=label;
	   			}
	   		}
	   }
	   	
	   	/**
	   	 * 画板事件
	   	 * */
		private function designMouseDowon(event:MouseEvent):void
		{
			this.clearSelectObject();
			event.stopPropagation();
		}
		/**
		 * 鼠标移动 有几种情况
		 * 1。选中节点移动。
		 * 2。画线。
		 * @param event
		 * @return 
		 * 
		 */		
		private function designMouseMove(event:MouseEvent):void
		{
			
			if(this.drageName!=null)/**判断鼠标移动的时候是拖动节点还是画线*/
			{
				var wfNode:WfNode=WfNode(this.getChildByName(drageName));
				var mouseX:Number=event.currentTarget.contentMouseX;
				var mouseY:Number=event.currentTarget.contentMouseY;
				var wfNodeMouseX:Number=wfNode.contentMouseX;
				var wfNodeMouseY:Number=wfNode.contentMouseY;
				/**
				* 增加画布长宽
				*/				
				if(mouseX+wfNode.width>this.width)
				{
					this.width=this.width+wfNode.width;
				}
				if(mouseY+wfNode.height>this.height)
				{
					this.height=this.height+wfNode.height;	
					
				}
				/**
				* 不能拖出左边界
				*/				
				if(mouseX-wfNodeMouseX<0)
				{
					wfNode.stopDrag();
					wfNode.move(0,wfNode.y);
					wfNode.dispatchEvent(new NodeEvent(NodeEvent.nodeStopDrage));
					this.drageName=null;
				}
				/**不能拖出上边界  */
				if(mouseY-wfNodeMouseY<0)
				{
					wfNode.stopDrag();
					wfNode.move(wfNode.x,0);
					wfNode.dispatchEvent(new NodeEvent(NodeEvent.nodeStopDrage));
					this.drageName=null;	
				}
			}
			
			if(this.toolSelectValue=="line" || this.toolSelectValue=="curveLine")/**当前是画线模式 */
			{
				if(this.drawLine)
				{
					this.temporaryLine.endX=this.contentMouseX;
					this.temporaryLine.endY=this.contentMouseY;
					this.temporaryLine.drawLine();		
				}
			 	 
			}
			if(this.selectObject[0]!=null)/**选着节点不为空  */
			{
				if(this.selectObject.length>0)
				{
					var selectObjectName:String=this.selectObject[0].name;
					var selectObjectType:String=this.selectObject[0].type;
					if(selectObjectType=="line")/**如果是直线  */
					{
						var getLine:Line=Line(this.getChildByName(selectObjectName));
						if(getLine!=null)
						{
			 				getLine.movePonitXY(event.currentTarget.contentMouseX,event.currentTarget.contentMouseY);
			 			}
					}
					if(selectObjectType=="node")/**如果选中的节点 更新与之相连的线的位置 */
					{
						var getNode:WfNode=WfNode(this.getChildByName(selectObjectName));
						if(getNode!=null)
						{
							if(getNode.isDrage)
							{
								var getNodeName:String=getNode.name;
								var getNodeFromLine:Array=this.workFlowData.qryLineDataByFromNodeId(getNodeName);
				   					for(var i:int=0;i<getNodeFromLine.length;i++)
				   					{
				    					var fromLineData:LineData=LineData(getNodeFromLine[i]);
				    					if(fromLineData!=null)
				    					{
				    						this.lineRefash(fromLineData);
				    					}
				   					}
				  			 	var getNodeToLine:Array=this.workFlowData.qryLineDataByToNodeId(getNodeName);
				    			for(var j:int=0;j<getNodeToLine.length;j++)
				    			{
				    				var toLineData:LineData=LineData(getNodeToLine[j]);
				    				if(toLineData!=null)
				    				{
				    					this.lineRefash(toLineData);
				    				}
				    			}
							}
						}
					}
				}
			}
		}
		/**
		 * 鼠标移开
		 * @param event
		 * @return 
		 * 
		 */		
		private function designMouseOut(event:MouseEvent):void
		{
			if(this.drageName!=null)
			{
				var wfNode:WfNode=WfNode(this.getChildByName(this.drageName));
				wfNode.stopDrag();
				wfNode.dispatchEvent(new NodeEvent(NodeEvent.nodeStopDrage));
				this.drageName=null;
			}
   		}
		/**
		 * 鼠标放开
		 * @param event
		 * @return 
		 * 
		 */		
		private function designMouseUp(event:MouseEvent):void
		{
			 //trace("designMouseUp");
			if(this.toolSelectValue=="line" || this.toolSelectValue=="curveLine")
			{
				if(this.drawLine)
				{
					if(this.drawLineEnd)
					{
	 					this.drawLine=false;
						this.drawLineEnd=false;
						if(this.newLineControl())
						{
							this.temporaryLine.clear();
						}
					}
					else
					{
						this.drawLine=false;
						this.temporaryLine.clear();
					}
				}
			}
		}
		
		
		/**
		 * 设置状态
		 * @param newSelectName
		 * @param newSelectType
		 * @return 
		 * 
		 */		
		public function setSelectState(newSelectName:String,newSelectType:String):void
		{
			 //trace("setSelectState");
			if(this.selectObject[0]!=null)
			{
				var oldSelectName:String=this.selectObject[0].name;
				var oldSelectType:String=this.selectObject[0].type;
				 	if(oldSelectType=="line")
				 	{
				 		if(oldSelectName!=newSelectName)
				 		{
				 			if(oldSelectName!=null)
				 			{
			   		 			var lineSelect:Line=Line(this.getChildByName(oldSelectName));
			 					if(lineSelect!=null)
			 					{
			 						lineSelect.lineSelect=false;
			 					}
			   				}
							this.selectObject[0]={name:newSelectName,type:newSelectType}
							if(newSelectType=="node")
							{
								var wfNodeEvent:WfNode=WfNode(this.getChildByName(newSelectName));
								wfNodeEvent.nodeSelect=true;
							}
				  		}
					}
					if(oldSelectType=="node")
					{
						if(newSelectName!=oldSelectName)
						{
	   						if(oldSelectName!=null)
	   						{
	   							var getWfNode:WfNode=WfNode(this.getChildByName(oldSelectName));
	   		   						if(getWfNode!=null)
	   		   						{
	   		   							getWfNode.nodeSelect=false;
	   		   						}
	   		 				}
	   		 				this.selectObject[0]={name:newSelectName,type:newSelectType}
	   		 				if(newSelectType=="node")
	   		 				{
								var wfNodeEvent2:WfNode=WfNode(this.getChildByName(newSelectName));
								wfNodeEvent2.nodeSelect=true;
							}
	   					}
					}
				}
			else
				{
					this.selectObject[0]={name:newSelectName,type:newSelectType}
					if(newSelectType=="node")
					{
						var wfNodeEvent3:WfNode=WfNode(this.getChildByName(newSelectName));
						wfNodeEvent3.nodeSelect=true;
					}
				
			    }
		}
		/**
		 * //清出选择对像
		 * @return 
		 * 
		 */		
		
		public function clearSelectObject():void
		{
			if(this.selectObject[0]!=null)
			{
				var selectObjectName:String=this.selectObject[0].name;
				var slectObjectType:String=this.selectObject[0].type;
				if(slectObjectType=="line")
				{
					var lineSelect:Line=Line(this.getChildByName(selectObjectName));
			 		if(lineSelect!=null)
			 		{
			 			lineSelect.lineSelect=false;
			 			this.selectObject[0]=null;
			 		}	
				}
				if(slectObjectType=="node")
				{
					var nodeSelect:WfNode=WfNode(this.getChildByName(selectObjectName));
					if(nodeSelect!=null)
					{
						nodeSelect.nodeSelect=false;
						this.selectObject[0]=null;
					}	
				}
			}
		}
		
		
		
		
	}
}