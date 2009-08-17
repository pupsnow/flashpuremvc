package  org.flowDesign.data
{
	public class WorkFlowDataProvider
	{
		
		private var host: Object;
		public function WorkFlowDataProvider(value: Object): void {
			this.host = value;
			initdataProvider();
		}
		
		
		private var _dataProvider:XML;
		[Bindable]
		public  function set dataProvider(value:XML):void{
			this._dataProvider=value;
		}
		public function get dataProvider():XML{
			return this._dataProvider;
		}
		
		
		/**
		 * 初始化数据
		 * @return 
		 * 
		 */		
		public function initdataProvider():void{
	     	 _dataProvider=<processDefinition id=""  modularid="" name="" version="" parentPrdeId="" PrdeCode=""/>;
         }
         
		/**
		 * 绑定数据
		 * @param value
		 * 
		 */         
		public function dataBind(value:XML):void
		{
			this.dataProvider=value;
		}
		
		
		/**
		 * 添加节点
		 * @param nodeId
		 * @param name
		 * @param type
		 * @param x
		 * @param y
		 * @param typeId
		 * @return 
		 * 
		 */		
		public function addNode(nodeId:String,name:String,type:String,x:int,y:int,typeId:String):void{
			var nodeXml:XML=<node/>;
			nodeXml.@id=nodeId;
			nodeXml.@x=x;
			nodeXml.@y=y;
			nodeXml.@name=name;
			nodeXml.@type=type;
			nodeXml.@priograde="3";
			nodeXml.@nodedesc="";
			nodeXml.@typeId=typeId;
			nodeXml.@dispStrategyId="";
			nodeXml.@joinModeId="2";
			nodeXml.@splitModeId="3"; 
			if(typeId=="1" || typeId=="2" ||typeId=="4" ){
				//事件
				var events:XML=<events/>;
				nodeXml.appendChild(events); 
				//任务   
				var task:XML=<task/>;
				events.appendChild(task);
				task.@name=name;					     	
				task.@excutantId="1";
				task.@acceptModeId="2";
				task.@eventTypeId="1";
				//派发策略
				var dispStrategyConfig:XML=<dispStrategyConfig/>;
				task.appendChild(dispStrategyConfig);
				dispStrategyConfig.@dispStrategyId="1";
				dispStrategyConfig.@dispStrategyName="按岗位";
				dispStrategyConfig.@dispStrategyDesc="按岗位";
				//派发策略参数
				var value:XML=<value/>;
				value.@valueNumber="1";
				value.@dispTypeId="1";
				dispStrategyConfig.appendChild(value);
				            
			}
	 		this.dataProvider.appendChild(nodeXml); 
		}
		
		
		
		
		/**
		 * 添加两个节点的连接 
		 * @param fromNodeId
		 * @param toNodeId
		 * @param type
		 * @return 
		 * 
		 */		
		public function linkNode(fromNodeId:String,toNodeId:String,type:String):void{
			addFromNode(toNodeId,fromNodeId,type);
			addToNode(fromNodeId,toNodeId,type);
		}
		
		/**
		 * 在dataPrivate中添加添加源连接 
		 * @param NodeId
		 * @param fromNodeId
		 * @param type
		 * @return 
		 * 
		 */		
		public function addFromNode(NodeId:String,fromNodeId:String,type:String):void{
			var childrens:XMLList=this.dataProvider.node;
			var i:int=0;
			while(i<childrens.length()){
				var children:XML=childrens[i];
				if(children.@id==NodeId){
					var flux:XML=children.flux[0];
					if(flux==null){
						flux=<flux><fromnodes/></flux>;
						children.appendChild(flux);
					  }else{
					  	var fromnodes2:XML=flux.fromnodes[0];
					  	if(fromnodes2==null){
					  		fromnodes2=<fromnodes/>;
					  		flux.appendChild(fromnodes2);
					  	}
					  }
					var fromnode:XML=<fromNode id="" name="" type=""/>;
					fromnode.@id=fromNodeId;
					fromnode.@type=type;
					var fromnodes:XML=flux.fromnodes[0];
					var pd:Boolean=true;
					
					if(fromnodes.fromNode!=null){
						var fromNodeins:XMLList=fromnodes.fromNode;
					    for( var j:int=0;j<fromNodeins.length();j++){	
					    	var fromNodeinsinId:String=fromNodeins[j].@id; 
				            if(fromNodeinsinId==fromNodeId){
				      	    	pd=false;
				            }
				         } 
				     }
				 
				   if(pd){
				    	fromnodes.appendChild(fromnode);
				   }
				}
				i++;
			}
		}
		
		/**
		 * 在dataPrivate中添加添加源连接
		 * @param NodeId
		 * @param toNodeId
		 * @param type
		 * @return 
		 * 
		 */		
		public function addToNode(NodeId:String,toNodeId:String,type:String):void{
			var childrens:XMLList=_dataProvider.node;
			var i:int=0;
			while(i<childrens.length()){
				var children:XML=childrens[i];
				if(children.@id==NodeId){
					var flux:XML=children.flux[0];
					if(flux==null){
						flux=<flux><tonodes/></flux>;
						children.appendChild(flux);
					 }else{
					  	var tonodes2:XML=flux.tonodes[0];
					  	if(tonodes2==null){
					  		tonodes2=<tonodes/>;
					  		flux.appendChild(tonodes2);
					  	}
					}
				  	var tonode:XML=<tonode id="" name="" type=""/>;
				  	tonode.@id=toNodeId;
				  	tonode.@type=type;
				  	var tonodes:XML=flux.tonodes[0];
				  	var pd:Boolean=true;
					
					if(tonodes.tonode!=null){
						var tonodeins:XMLList=tonodes.tonode;
					    	for( var j:int=0;j<tonodeins.length();j++){	
					      		var tonodeinId:String=tonodeins[j].@id; 
				             	if(tonodeinId==toNodeId){
				      	      		pd=false;
				             	}
				           	} 
				    }
				  	if(pd){
				  		var extoNodeXml:*=selectNodeXml(toNodeId);
				  	   	var exFromNodeXml:*=selectNodeXml(NodeId);
				       	var result:XML=<result/>;
				       	result.@name=exFromNodeXml.@name+extoNodeXml.@name;
				       	result.@nodeId=toNodeId;
				       	result.@isdefault="true";
				       	addNoedeExpressions(exFromNodeXml,result);
				      	tonodes.appendChild(tonode);
				   }
				}
				i++;
			 }
		}
		
		
   		/**
   		 * 添加节点表达式
   		 * @param NodeXml
   		 * @param result
   		 * @return 
   		 * 
   		 */
   		public function addNoedeExpressions(NodeXml:XML,result:XML):void{
   			var expressions:XML;
   			if(!NodeXml.hasOwnProperty("expressions")){
  				expressions=<expressions/>;
  				NodeXml.appendChild(expressions);
   			}else{
   				expressions=NodeXml.child("expressions")[0];
   			}
   			var expression:XML=<expression/>;	
     		var id:String=result.@id;
   			if(id!=""){
   				expression.@id=id;
   			}
   	 		var name:String=result.@name;
   			if(name!=""){
   				expression.@name=name;
   			}
   			var isdefault:String=result.@isdefault;
   			if(isdefault!=""){
   				expression.@isdefault=isdefault;
   			}
   			var nodeId:String=result.@nodeId;
   			if(nodeId!=""){
   				expression.@nodeId=nodeId;
   			}
   			var expressionvalue:String=result.@expressionvalue;	
   			if(expressionvalue!=""){
   				expression.@expressionvalue=expressionvalue;
   			}
   	
   			var nodevalueCondition:XML;
   			if(expressions.hasOwnProperty("nodevalueCondition")){
   				nodevalueCondition=expressions.nodevalueCondition;
   			}else{
   				nodevalueCondition=<nodevalueCondition/>;
   			}
   	
   	
 			var expressionvalueValue:String=result.@operationSign;
   			if(expressionvalue!=""){
   				var operationSign:XML=<operationSign/>;	
   				operationSign.text()[0]=expressionvalueValue;
   				nodevalueCondition.appendChild(operationSign);
   			}
  
			var expressionvalueValue2:String=result.@operationSignlable;
   			if(expressionvalueValue2!=""){
   				var operationSignlable:XML=<operationSignlable/>;
   				operationSignlable.text()[0]=expressionvalueValue2;
   				nodevalueCondition.appendChild(operationSignlable);
   			}
   
   			var controlSpecIdValue:String=result.@controlSpecId;
   			if(controlSpecIdValue!=""){
   				var controlSpecId:XML=<controlSpecId/>;
   				controlSpecId.text()[0]=controlSpecIdValue;	
   				nodevalueCondition.appendChild(controlSpecId);
   			}
			
			var lableFieldValue:String=result.@lableField;
   			if(lableFieldValue!=""){
   				var lableField:XML=<lableField/>;	
   				lableField.text()[0]=lableFieldValue;	
   				nodevalueCondition.appendChild(lableField);
   			}
   			
   			var operationRelationlablleValue:String=result.@operationRelationlablle;
   			if(operationRelationlablleValue!=""){
   				var operationRelationlablle:XML=<operationRelationlablle/>;	
   				operationRelationlablle.text()[0]=operationRelationlablleValue;	
   				nodevalueCondition.appendChild(operationRelationlablle);
   			}
   
			var operationRelationValue:String=result.@operationRelation;
   			if(operationRelationValue!=""){
   				var operationRelation:XML=<operationRelation/>;	
   				operationRelation.text()[0]=operationRelationValue;	
   				nodevalueCondition.appendChild(operationRelation);
   			}
   	
   			var valueValue:String=result.@value;
   			if(valueValue!=""){
   				var value:XML=<value/>;	
   				value.text()[0]=valueValue;	
   				nodevalueCondition.appendChild(value);
   			}
   	
   	
   			if(nodevalueCondition.hasComplexContent()){
   				expression.appendChild(nodevalueCondition);
   			}
   		
   		expressions.appendChild(expression);	
   		}
		
		
   		/**
   		 * 得到一个节点的xml
   		 * @param nodeId
   		 * @return 
   		 * 
   		 */		
		
   		public function selectNodeXml(nodeId:String):XML{
   			var nodeXmlList:XMLList=this.dataProvider.node;
   			for(var i:int=0;i<nodeXmlList.length();i++){
   				var nodeXml:XML=nodeXmlList[i];
   				if(nodeXml.@id==nodeId){
   					return nodeXmlList[i];
   					break;
   				}
   			}
   			return null;
   		}
   		
   		
   		
		/**
		 * 删除一个节点
		 * @param nodeId
		 * @return 
		 * 
		 */		
	
		public function delNode(nodeId:String):void{
			var nodeXmlList:XMLList=this.dataProvider.child("node");
			if(nodeXmlList!=null){
				for(var i:int=0;i<nodeXmlList.length();i++){
					var nodeXml:XML=nodeXmlList[i];
					var nodeXmlId:String=nodeXml.@id;	
					if(nodeXmlId==nodeId){
						var fluxXmlList:XMLList=nodeXml.child("flux");
						if(fluxXmlList!=null){
							var fluxXml:XML=fluxXmlList[0];
							if(fluxXml!=null){
								var fromNodesXmlList:XMLList=fluxXml.child("fromnodes");
								if(fromNodesXmlList!=null){
									var fromNodesXml:XML=fromNodesXmlList[0];
									if(fromNodesXml!=null){
										var fromNodeXmlList:XMLList=fromNodesXml.child("fromNode");
										for(var j:int=0;j<fromNodeXmlList.length();j++){
											var fromNodeXml:XML=fromNodeXmlList[j];
											var fromNodeId:String=fromNodeXml.@id;
											deleteToLink(fromNodeId,nodeId);
										}
									}
								}
							
							
								var toNodesXmlList:XMLList=fluxXml.child("tonodes");
								if(toNodesXmlList!=null){
									var toNodesXml:XML=toNodesXmlList[0];
									if(toNodesXml!=null){
										var toNodeXmlList:XMLList=toNodesXml.child("tonode");
										for(var k:int=0;k<toNodeXmlList.length();k++){
											var toNodeXml:XML=toNodeXmlList[k];
											var toNodeId:String=toNodeXml.@id;
											deleteFromLink(toNodeId,nodeId);
										}
									}
								}
							}
						}
					delete 	nodeXmlList[i];
					}
				}
			}		
		}	
		
		
		
		/**
		 * 删除节点的from连接
		 * @param nodeId
		 * @param fromNodeId
		 * @return 
		 * 
		 */		
		
		public function deleteFromLink(nodeId:String,fromNodeId:String):void{
			var nodeXmlList:XMLList=this.dataProvider.child("node");
			if(nodeXmlList!=null){
				for(var i:int=0;i<nodeXmlList.length();i++){
					var nodeXml:XML=nodeXmlList[i];
					var nodeXmlId:String=nodeXml.@id;	
					if(nodeXmlId==nodeId){
						var fluxXmlList:XMLList=nodeXml.child("flux");
						if(fluxXmlList!=null){
							var fluxXml:XML=fluxXmlList[0];
							if(fluxXml!=null){
								var fromNodesXmlList:XMLList=fluxXml.child("fromnodes");
								if(fromNodesXmlList!=null){
									var fromNodesXml:XML=fromNodesXmlList[0];
									if(fromNodesXml!=null){
										var fromNodeXmlList:XMLList=fromNodesXml.child("fromNode");
										for(var j:int=0;j<fromNodeXmlList.length();j++){
											var fromNodeXml:XML=fromNodeXmlList[j];
											var fromNodeXmlId:String=fromNodeXml.@id;
											if(fromNodeXmlId==fromNodeId){
												delete fromNodeXmlList[j];
											}
										}
									}
								}
							}
						}
				
					}
				}		
			}
		}
		
		/**
		 * 删除节点to连接
		 * @param nodeId
		 * @param toNodeId
		 * @return 
		 * 
		 */		
		public function deleteToLink(nodeId:String,toNodeId:String):void{
			var nodeXmlList:XMLList=this.dataProvider.child("node");
			if(nodeXmlList!=null){
				for(var i:int=0;i<nodeXmlList.length();i++){
					var nodeXml:XML=nodeXmlList[i];
					var nodeXmlId:String=nodeXml.@id;	
					if(nodeXmlId==nodeId){
						var fluxXmlList:XMLList=nodeXml.child("flux");
						if(fluxXmlList!=null){
							var fluxXml:XML=fluxXmlList[0];
							if(fluxXml!=null){
								var toNodesXmlList:XMLList=fluxXml.child("tonodes");
								if(toNodesXmlList!=null){
									var toNodesXml:XML=toNodesXmlList[0];
									if(toNodesXml!=null){
										var toNodeXmlList:XMLList=toNodesXml.child("tonode");
										for(var j:int=0;j<toNodeXmlList.length();j++){
											var toNodeXml:XML=toNodeXmlList[j];
											var toNodeXmlId:String=toNodeXml.@id;
											if(toNodeXmlId==toNodeId){
												delete toNodeXmlList[j];
											}
										}
									}
								}
							}
						}
					}
				}		
			}
		}
		
		
		/**
		 * 删除两个节点之间的连接
		 * @param fromNodeId
		 * @param toNodeId
		 * @return 
		 * 
		 */		
		public function unLink(fromNodeId:String,toNodeId:String):void{
			deleteFromLink(toNodeId,fromNodeId);
			deleteToLink(fromNodeId,toNodeId);
		}
		
		
		
		/**
		 * 得到所有的节点的节点数据
		 * @return 
		 * 
		 */
		public function getALLNodeData():Array{
			var result:Array=new Array();
			var nodeXmlList:XMLList=this.dataProvider.child("node");
		    if(nodeXmlList!=null){
		    	for(var i:int=0;i<nodeXmlList.length();i++){
		    		var nodeXml:XML=nodeXmlList[i];
		    		var nodeData:NodeData=new NodeData();
		    		nodeData.id=nodeXml.@id;
		    		nodeData.x=nodeXml.@x;
		    		nodeData.y=nodeXml.@y;
		    		nodeData.type=nodeXml.@type;
		    		nodeData.name=nodeXml.@name;
		    		nodeData.TypeId=nodeXml.@typeId;
					result.push(nodeData);
		    	}
		    }
		return result;
		}
		
		 /**
		  * 
		  * @return 
		  * 
		  */		
		 public function getAllLineData():Array{
	       var nodeXmlList:XMLList=this.dataProvider.node;
	       var result:Array=new Array();
	      // var i:int=0;
			//用来生存节点之间的连线
			if(nodeXmlList!=null){
				for(var i:int=0;i<nodeXmlList.length();i++){
					var nodeXml:XML=nodeXmlList[i];
					var flux:XML=nodeXml.child("flux")[0];
					if(flux!=null){
						if(nodeXml.child("flux")[0].child("fromnodes")!=null){
							if(nodeXml.child("flux")[0].child("fromnodes")[0]!=null){
								var fromNodeXmlList:XMLList=nodeXml.child("flux")[0].child("fromnodes")[0].child("fromNode");
								for(var j:int=0;j<fromNodeXmlList.length();j++){
									var fromNodeXml:XML=fromNodeXmlList[j];
									if(fromNodeXml!=null){
										var lineData:LineData=new LineData();
										lineData.fromNodeId=fromNodeXml.@id;
										lineData.toNodeId=nodeXml.@id;
										var lineType:*=fromNodeXml.@type;
										if(lineType=="curveLine"){
											lineData.lineType="curveLine";
										}else{
											lineData.lineType="line";	
										}
										result.push(lineData);
									}
								}
						  	}
						 }
					}
				}
	  	 	}
	  	 	return result;
	  	}
	  	
	  	
	  	
		/**
		 * 设置流程图的基本信息
		 * @param value
		 * @return 
		 * 
		 */	  	
		public function setBaseInfo(value:XMLList):void{
			this.dataProvider.appendChild(value);
		}
		
		/**
		 * 
		 */		
		private  var qryChildNodeValues:XML;
   		public function qryChildWorkValue(nodeId:String):XML{
   			this.qryChildNodeValues=<nodevalues/>;
       		var children:XML=this.selectNodeXml(nodeId);
       		if(children.hasOwnProperty("flux")){
   	   			var	childFulux:XML=children.child("flux")[0];
   				if(childFulux.hasOwnProperty("fromnodes")){
   					var childFromNodes:XML=childFulux.child("fromnodes")[0];
   						if(childFromNodes.hasOwnProperty("fromNode")){
   			 				var childFromNodess:XMLList=childFromNodes.child("fromNode");
   								for(var j:int=0;j<childFromNodess.length();j++){
   									var childFromNode:XML=childFromNodess[j];
   				    				if(childFromNode.@id!="" && childFromNode.id!=null){
   				    	            	var childfromNodeId:*=childFromNode.@id;
   				    					addqryChildWorkValue(childfromNodeId);
   				   					}
   								}
   						}
   				}
       		}
   	   	return qryChildNodeValues;
   		}
   
   
   
   
   
   		/**
   		 * 查找当前流程中子流程可用变量
   		 * @param nodeId
   		 * @return 
   		 * 
   		 */   		
   		public function addqryChildWorkValue(nodeId:String):void{
   			var children:XML=this.selectNodeXml(nodeId);
   	
   			if(children.hasOwnProperty("nodevalues")){
   	 			var childNodeVariables:XMLList=XML(children.child("nodevalues")[0]).child("nodeVariable");
   	   			for(var i:int=0;i<childNodeVariables.length();i++){
   	 				var childNodeVariable:XML=childNodeVariables[i];
   	   				if(qryDoubleValueNodeValues(childNodeVariable)){
   	   					this.qryChildNodeValues.appendChild(childNodeVariable.copy());
   	    			}
   	   			}
   			}
   			if(children.hasOwnProperty("flux")){
   				var	childFulux:XML=children.child("flux")[0];
   				if(childFulux.hasOwnProperty("fromnodes")){
   					var childFromNodes:XML=childFulux.child("fromnodes")[0];
   					if(childFromNodes.hasOwnProperty("fromNode")){
   			 			var childFromNodess:XMLList=childFromNodes.child("fromNode");
   						for(var j:int=0;j<childFromNodess.length();j++){
   							var childFromNode:XML=childFromNodess[j];
   				    		if(childFromNode.@id!="" && childFromNode.id!=null){
   				    			var childfromNodeId:String=childFromNode.@id;
   				    			var childFromType:String=childFromNode.@type;
   				    			if(childFromType!="curveLine"){
   				    			addqryChildWorkValue(childfromNodeId);
   				    			}
   				    		}
   						}
   					}
   				}
   			}
  		}
  		
  		
  		
  		
  		
  		
		/**
		 * 
		 * @param childXml
		 * @return 
		 * 
		 */		
		private function qryDoubleValueNodeValues(childXml:XML):Boolean{
   			if(this.qryChildNodeValues.hasOwnProperty("nodeVariable")){
   				var nodeVariables:XMLList=qryChildNodeValues.child("nodeVariable");
   				for(var i:int=0;i<nodeVariables.length();i++){
   					var childControlSpecId:String=childXml.child("controlSpecId")[0].text();
   					var ControlSpecId:String=nodeVariables[i].child("controlSpecId")[0].text();
   					if(childControlSpecId==ControlSpecId){
   						return false;
   					}
    	 		}
   			}
   		return true;
   		}
		
		
		
		
		
		/**
		 * 
		 * @param nodeId
		 * @return 
		 * 
		 */		
		public function qryNodeEntityState(nodeId:String):String{
			if(this.dataProvider.hasOwnProperty("nodeEntity")){
				var nodeEntity:XML=this.dataProvider.child("nodeEntity")[0];
				if(nodeEntity.hasOwnProperty("node")){
					var nodeList:XMLList=nodeEntity.child("node");
					for(var i:int=0;i<nodeList.length();i++){
						var xmlNodeId:String=XML(nodeList[i]).@id;
						if(xmlNodeId==nodeId){
							var state:String=XML(nodeList[i]).@state;
							return state;
						}
					}
					
				}
				
			}
			return null;
		}
		
		
		
		
	}
}
		
		
		
		
		
		
		
		
		
		
