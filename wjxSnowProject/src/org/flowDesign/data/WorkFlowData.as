package  org.flowDesign.data
{
	import mx.utils.StringUtil;
	/**
	 * 主要储存操作面板上 线和节点的数据。包括线的hashmap，节点的hashmap，以及
	 * 各数据的增加删除，查找。 
	 * @author Administrator
	 * 
	 */	
	public class WorkFlowData  
	{
		private var host: Object;
		public function WorkFlowData(value: Object): void 
		{
			this.host = value;
		}
		/**
		 * 节点id由两部分组成 固定定nodename与随机值nodeId;
		 */		
		private var _nodeId:int=0;
		private var _nodeName:String="node";
		public function set nodeName(name:String):void
		{
			this._nodeName=name;
		}
		public function get nodeName():String
		{
			return this._nodeName;		
		}
		
		public function get nodeId():String
		{
		  var nodeIdSting:String;
		  nodeIdSting=this.nodeName+this._nodeId;
		  _nodeId++;
		  return nodeIdSting;
		}
		
		
		/**
		 *存储已存在节点
		 */		
		private var _nodeDatas:HashMap=new HashMap();
		public function set nodeDatas(value:HashMap):void
		{
			this._nodeDatas=value;
		}
		public function get nodeDatas():HashMap
		{
			return this._nodeDatas;
		}
		
		/**
		 *存储数据的xml
		 */		
		private var _dataProvider:XML;
//		public function set dataProvider(value:XML):void
//		{
//			this._dataProvider=value;
//		}
		public function get dataProvider():XML
		{
			var hashmap:HashMap = this.nodeDatas;
			var linehap:HashMap = this.lineDatas;
			var xml:XML = <result></result>;
			var nodexml:XML = <node/>;
			var linexml:XML = <line/>;
			var nodearr:Array = hashmap.keys();
			var linearr:Array = linehap.keys();
			for(var i:int = 0;i<nodearr.length;i++)
			{
			var c:NodeData =hashmap.getKey(nodearr[i]);
			var xml1:String=StringUtil.substitute("<node id='{0}' name='{1}' nodeState='{2}' type='{3}' TypeId='{4}'/>",c.id,c.name,c.nodeState,c.type,c.TypeId);
			nodexml.appendChild(xml1);
			
			}
			for(var j:int = 0;j<linearr.length;j++)
			{
			var d:LineData =linehap.getKey(linearr[j]);
			var xml2:String=StringUtil.substitute("<node id='{0}' name='{1}' fromNodeId='{2}' toNodeId='{3}' lineType='{4}'/>",d.id,d.name,d.fromNodeId,d.toNodeId,d.lineType);
			linexml.appendChild(xml2);
			
			}
			 xml.appendChild(nodexml);
			 xml.appendChild(linexml);
			 trace(xml);
			return xml;
		}
		
		/**
		 *存储已存在线对像
		 */		
		private var _lineDatas:HashMap=new HashMap();
		public function set lineDatas(value:HashMap):void{
			this._lineDatas=value;
		}
		public function get lineDatas():HashMap{
			return this._lineDatas;
		}
		
		
		/**
		 * 节点数据操作
		 * 产生一个新节点
		 **/
		public function newNode(name:String,type:String,typeId:String,x:int,y:int,nodepro:IProperty):NodeData
		{
			var nodeData:NodeData=new NodeData();
			nodeData.id=this.nodeId;
			nodeData.name=name;
		    nodeData.type=type;
		    nodeData.x=x;
		    nodeData.y=y;
		    nodeData.TypeId=typeId;
		    nodeData.nodeProperty = nodepro;
		   	this.nodeDatas.put(nodeData.id,nodeData);
		   	return nodeData;
		}
		
		/**
		 * 得到一个节点数据
		 * @param nodeDataId
		 * @return 
		 * 
		 */		
		public function getNodeData(nodeDataId:String):NodeData{
		    var keys:Array=this.nodeDatas.keys();
		    var result:NodeData=null;	
		  	/**更新节点的xy*/
		  	if(keys!=null){
				for(var i:int=0;i<keys.length;i++){
					var nodeData:NodeData=nodeDatas.getKey(keys[i]);
					var nodeId:String=nodeData.id;
					if(nodeId==nodeDataId){
						result=nodeData;
						break;
					}
				}
			}
			return result;		
		}
		
		
		/**
		 * 删除节点 (同时删除与此节点相连的线)
		 * @param nodeDataId
		 * 
		 */		
		public function delNodeData(nodeDataId:String):void{
			var fromNodeLineData:Array=this.qryLineDataByFromNodeId(nodeDataId);
			var toNodeLineData:Array=this.qryLineDataByToNodeId(nodeDataId);
			for(var i:int=0;i<fromNodeLineData.length;i++){
				var fromLineData:LineData=fromNodeLineData[i];
				var fromLineDataId:String=fromLineData.id;
				this.delLineData(fromLineDataId);
			}
			for(var j:int=0;j<toNodeLineData.length;j++){
				var toLineData:LineData=toNodeLineData[j];
				var toLineDataId:String=toLineData.id;
				this.delLineData(toLineDataId);
			}
			this.nodeDatas.remove(nodeDataId);
			
		}
		
		/**
		 * 通过fromNodeId查找线数据
		 * @param fromNodeId
		 * @return 
		 * 
		 */		
		public function qryLineDataByFromNodeId(fromNodeId:String):Array{
			var result:Array=new Array();
			var keys:Array=this.lineDatas.keys();
			if(keys!=null){
				for( var i:int=0;i<keys.length;i++){
					var key:String=keys[i];
					var lineData:LineData=this.lineDatas.getKey(key);
					var lineDataFromId:String=lineData.fromNodeId;
					if(lineDataFromId==fromNodeId){
						result.push(lineData);
					}
				}
			}
			return result;
		}
		
		
		/**
		 * 通过toNodeId查找线数据
		 * @param toNodeId
		 * @return 
		 * 
		 */		
		public function qryLineDataByToNodeId(toNodeId:String):Array{
			var result:Array=new Array();
			var keys:Array=this.lineDatas.keys();
			if(keys!=null){
				for( var i:int=0;i<keys.length;i++){
					var key:String=keys[i];
					var toLineData:LineData=this.lineDatas.getKey(key);
					var toLineDataId:String=toLineData.toNodeId;
					if(toLineDataId==toNodeId){
						result.push(toLineData);
					}
				}
			}
			return result;
		}
		
		/**
		 * 删除直线 
		 * @param lineDataId
		 * @return 
		 * 
		 */		
		public function delLineData(lineDataId:String):void{
			var lineData:LineData=this.lineDatas.getKey(lineDataId);
			var fromNodeData:NodeData=this.nodeDatas.getKey(lineData.fromNodeId);
			var toNodeData:NodeData=this.nodeDatas.getKey(lineData.toNodeId);
			fromNodeData.delToNode(toNodeData);
			toNodeData.delFromNode(fromNodeData);
			this.lineDatas.remove(lineDataId);
		}
		
		/**
		 * 线数据操作
		 * 产生一个连接线的数据             
		 **/
		public function newLineData(fromNodeId:String,toNodeId:String,lineType:Class,linep:IProperty):LineData{
			var lineData:LineData=new LineData();
			lineData.id=fromNodeId+toNodeId;
			lineData.name = fromNodeId+toNodeId;
			lineData.fromNodeId=fromNodeId;
			lineData.toNodeId=toNodeId;
			lineData.lineType=lineType;
			lineData.lineProperty = linep;
			var fromNodeData:NodeData=this.nodeDatas.getKey(fromNodeId);
			var toNodeData:NodeData=this.nodeDatas.getKey(toNodeId);
			fromNodeData.addToNode(toNodeData);
			toNodeData.addFromNode(fromNodeData);
		    this.lineDatas.put(lineData.id,lineData);
		  return lineData;
		}
		
		
		/**
		 * 得到一条线数据
		 * @param lineDataId
		 * @return 
		 * 
		 */		
		public function getLineData(lineDataId:String):LineData{
			var keys:Array=this.lineDatas.keys();
			var result:LineData=null;
			if(keys!=null){
				for(var i:int=0;keys.length;i++){
					var lineData:LineData=this.lineDatas.getKey(keys[i]);;
					if(lineData==null)
					 break;
					var lineId:String=lineData.id;
					if(lineDataId==lineId){
						result=lineData;
						break;
					}
				}
			}
			return result;
		}
		
		
	
	
	
	
		
	}
}