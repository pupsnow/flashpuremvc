//绑定数据xml
import org.wjx.controls.workFlow.EntityExplain;
import org.wjx.controls.workFlow.workFlowClasses.LineData;
import org.wjx.controls.workFlow.workFlowClasses.NodeData;
import org.wjx.controls.workFlow.workFlowClasses.WorkFlowDataProvider;
import org.wjx.controls.workFlow.workFlowClasses.nodeStateConstants;
import org.wjx.controls.workFlow.workFlowEvent.WrokFlowDesignEvent;
private var _workFlowDataProvider:WorkFlowDataProvider;
private var firstNodeNum:int=0;

public function set workFlowDataProvider(value:WorkFlowDataProvider){
	this._workFlowDataProvider=value;
}
public function get workFlowDataProvider():WorkFlowDataProvider{
	return this._workFlowDataProvider;
}

public function init(){
	this.workFlowDataProvider=new  WorkFlowDataProvider(this);
}



public function baindDataXml(value:XML){
	if(value!=null){
		this.workFlowDataProvider.dataBind(value);
		this.bindNode();
	}
}

//绑定节点xml到节点
public function bindNode(){
	var nodeDatas:Array=this.workFlowDataProvider.getALLNodeData();
	this.firstNodeNum=nodeDatas.length;
	euniteWorkFlow.inFrist=true;
	for(var i:int=0;i<nodeDatas.length;i++){
		var nodeData:NodeData=nodeDatas[i];
		var nodeId:String=nodeData.id;
		var nodeState:String=this.workFlowDataProvider.qryNodeEntityState(nodeId);
		nodeData.nodeState=this.getNodeState(nodeState);
		if(euniteWorkFlow.newNodeChild(nodeData)){
			
		}
	}
	euniteWorkFlow.inFrist=false;
}


//添加一个新节点事件
public function workFlowNodeComplete(event:WrokFlowDesignEvent){
    	this.firstNodeNum--;
		if(this.firstNodeNum==0){
		this.bindLine();
		}
}

public function bindLine():void{
	var lineDatas:Array=this.workFlowDataProvider.getAllLineData();
	for(var i:int=0;i<lineDatas.length;i++){
		var lineData:LineData=lineDatas[i];
		var fromNodeId:String=lineData.fromNodeId;
		var fromNodeStateId:String=this.workFlowDataProvider.qryNodeEntityState(fromNodeId);
		var fromNodeState:String=this.getNodeState(fromNodeStateId);
		
		var toNodeId:String=lineData.toNodeId;
		var toNodeStateId:String=this.workFlowDataProvider.qryNodeEntityState(toNodeId);
		var toNodeStateState:String=this.getNodeState(toNodeStateId);
		if(fromNodeState==nodeStateConstants.complete){
			if(toNodeStateState==nodeStateConstants.complete || toNodeStateState==nodeStateConstants.execute){
				lineData.lineState=nodeStateConstants.complete;
			}else{
				lineData.lineState=nodeStateConstants.noExecute;
			}
		}else{
			lineData.lineState=nodeStateConstants.noExecute;
		}
		
		euniteWorkFlow.newLineChild(lineData);
	}
}

public function getNodeState(stateId:String):String{
	var nodeState:String=null;
	if(stateId=="4"){
		nodeState= nodeStateConstants.complete;
	}
	if(stateId=="3"){
		nodeState= nodeStateConstants.execute;
	}
	return nodeState;
}

public function workFlowDesignCreationComplete(){
	var explain:EntityExplain=new EntityExplain();
	explain.x=0;
	explain.y=0;
	euniteWorkFlow.addChild(explain);
}

