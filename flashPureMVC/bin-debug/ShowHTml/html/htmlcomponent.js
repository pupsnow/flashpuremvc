    // Copyright 2008 www.flexcapacitor.com, www.drumbeatinsight.com 
    // Version 4.2.3
    
    // global array of html elements
    var fcHTMLControls = new Array();
    var fcEventTimeoutInterval = 200;
    var fcExistingOnBeforeUnload;
    var fcRelativeMovie = false;
	var xinha_editors=null;
	var xinha_init=null;
	var xinha_config=null;
	var xinha_plugins=null;
	var _editor_url  = "html/editors/xinha/"
    var _editor_lang = "en";
	
    // blur xinha editor
    function fcAddBlurHandler() {
		this._doc.xinhaEditor = this;
		Xinha._addEvent(this._doc, "blur", function() {
			var movie = fcGetMovieById(this.xinhaEditor.movieId);
			//movie.xinhaBlur();
			window.focus();
			movie.focus();
		});
    }
    
	// add HTML element to the page
    function fcAddChild(o) {
    	var movie = fcGetMovieById(o.movieId);
    	fcHTMLControls.movieId = o.movieId;
    	
    	if (String(o.chrome)=="true") {
    		fcAddChildPopUp(o);
    	}
    	else if (o.type=="division") {
    		fcAddChildDivision(o);
    	}
    	else if (o.type=="iframe") {
    		fcAddChildIFrame(o);
    	}
    	else if (o.type=="editor") {
    		fcAddChildEditor(o);
    	}
    }
    
    // add division to the page
    function fcAddChildDivision(o) {
		fcGetIncludes(o.includesBefore, "body");
		var newElement = document.createElement("div");
		newElement.id = o.id;
		newElement.name = o.name;
		newElement.movieId = o.movieId;
		
		newElement.style.position = o.position;
		
		if (String(o.fitToContentHeight)=="true") {
			o.height = "";
		}
		fcSetSize(newElement,o.width,o.height);
		fcMoveElementTo(newElement,o.x,o.y);
		if (String(o.backgroundTransparent)!="true") {
			newElement.style.backgroundColor = "#" + o.backgroundColor;
		}
		newElement.style.color = "#" + o.color;
		newElement.style.padding = o.padding;
		newElement.style.margin = "0px";
		// always 0px - do not add a border to the container div tag
		// add a border in mxml or add a child div tag in the htmlText property and add a border to that
		newElement.style.border = o.border;
		newElement.innerHTML = o.htmlText;
		
		document.body.appendChild(newElement);
		
		fcAddToGlobalArray(newElement, o);
		fcSetScrollPolicyById(o.id, o.htmlScrollPolicy);
		
		fcGetIncludes(o.includesAfter);
		
		if (String(o.visible)=="false") {
			fcHide(o.id,true,false);
		}
		
		fcDelayedDispatchEvent("htmlCreationComplete", o.movieId, o.id, fcEventTimeoutInterval);
    }
    
    // add an editor to the page
    function fcAddChildEditor(o) {
    	// Add new editors here
		// There are three places to add new editor support. 
		// here, getHTML, setHTML and if possible, call htmlCreationComplete when the editor has been created
		// see FCKeditor_OnComplete for an example
		
    	// if the editor is generated with the same id, same textarea should be used
		var el = document.getElementById(o.id);
		if (el!=null) return;
		
		// we add this control early on editors 
		fcHTMLControls[o.id] = new Object();
	
		fcGetIncludes(o.includesBefore);
		var editorName = o.name + "Editor";
		var newElement = document.createElement("div");
		newElement.id = o.id;
		newElement.name = o.name;
		newElement.movieId = o.movieId;
		
		newElement.style.position = o.position;
		fcSetSize(newElement,o.width,o.height);
		fcMoveElementTo(newElement,o.x,o.y);
		if (String(o.backgroundTransparent)!="true") {
			newElement.style.backgroundColor = "#" + o.backgroundColor;
		}
		newElement.style.padding = o.padding;
		newElement.style.margin = "0px";
		newElement.style.border = o.border;
		
		var textareaElement = document.createElement("textarea");
		textareaElement.id = editorName;
		textareaElement.name = editorName;
		textareaElement.value = o.htmlText;
		fcSetSize(textareaElement,"100%","100%");
		newElement.appendChild(textareaElement);
		
		document.body.appendChild(newElement);
		fcSetScrollPolicyById(o.id, o.htmlScrollPolicy);
		
		// add additional editor support here
		if (o.editorType=="fckeditor") {
			// Create an instance of FCKeditor (using the target textarea as the name).
			var oFCKeditor = new FCKeditor( editorName ) ;
			oFCKeditor.BasePath = o.editorPath;
			if (o.configPath) {
				oFCKeditor.Config["CustomConfigurationsPath"] = o.configPath +"?" + ( new Date() * 1 ) ;
			}
			oFCKeditor.Width = '100%';
			oFCKeditor.Height = '100%';
			oFCKeditor.ReplaceTextarea();
			
			fcHTMLControls[o.id].editor = oFCKeditor;
		}
		else if (o.editorType=="tinymce") {
		    var elm = document.getElementById(o.id);
		    setTimeout("fcEventTimeoutHandler('"+o.movieId+"','"+o.id+"')",fcEventTimeoutInterval);
		    
			if (typeof o.editorOptions == "string") {
				// crashes firefox???
				//tinyMCE.init({mode:"exact",theme:"simple"});
			}
			else {
				tinyMCE.init(o.editorOptions);
			}
			
			if (tinyMCE.getInstanceById(editorName) == null) {
				// cannot find editor sometimes. causes crash
				//tinyMCE.execCommand('mceAddControl', false, editorName);
			}
			fcHTMLControls[o.id].editor = elm
		}
		else if (String(o.editorType)=="xinha") {
			// NOTE: we should be able to pass in the plugin array, the stylesheet array, toolbar array and settings array,
			/* This compressed file is part of Xinha. For uncompressed sources, forum, and bug reports, go to xinha.org */
			/* The URL of the most recent version of this file is http://svn.xinha.webfactional.com/trunk/examples/XinhaConfig.js */

			xinha_init=xinha_init ? xinha_init:function(){
				xinha_editors=xinha_editors?xinha_editors:[editorName];
				xinha_plugins=o.editorOptions.xinha_plugins?o.editorOptions.xinha_plugins:["CharacterMap","ContextMenu","SmartReplace","Stylist","Linker","SuperClean","TableOperations"];
				_editor_lang=o.editorOptions._editor_lang?o.editorOptions._editor_lang:"en"; // the language we need to use in the editor.
				_editor_skin=o.editorOptions._editor_skin?o.editorOptions._editor_skin:""; // the skin we use in the editor
				if(!Xinha.loadPlugins(xinha_plugins,xinha_init)){
					return;
				}
				xinha_config=xinha_config?xinha_config():new Xinha.Config();
				if (o.editorOptions.xinha_config) {
					var settings = o.editorOptions.xinha_config;
					for (var name in settings) {
						if (xinha_config[name]) {
							xinha_config[name] = settings[name];
						}
					}
				}
				//xinha_config.pageStyleSheets=[_editor_url+"examples/full_example.css"];
				xinha_editors=Xinha.makeEditors(xinha_editors,xinha_config,xinha_plugins);
				Xinha.startEditors(xinha_editors);
				var ed = xinha_editors[editorName];
				fcHTMLControls[o.id].editor = ed;
				ed._onGenerate = fcAddBlurHandler;
				ed.currentWhenDocReady = ed.whenDocReady;
				ed.movieId = o.movieId;
				ed.whenDocReady = function(e) {
					var func = ed.currentWhenDocReady;
					if (typeof func!="undefined") {
						ed.currentWhenDocReady(e);
					};
					fcHTMLControls[o.id].loaded = true;
					fcDelayedDispatchEvent("htmlCreationComplete", o.movieId, o.id, fcEventTimeoutInterval);
				}
			};
			fcHTMLControls[o.id].editor = textareaElement;
			Xinha.addOnloadHandler(xinha_init);
			xinha_init();
			
			//setTimeout("xinha_init()", 500);
		}
		
		fcAddToGlobalArray(newElement, o);
		
		if (String(o.visible)=="false") {
			fcHide(o.id,true,false);
		}
		
    }
    
    // add iframe to the page
    function fcAddChildIFrame(o) {
		var newElement = document.createElement("iframe");
		newElement.id = o.id;
		newElement.name = o.name;
		newElement.movieId = o.movieId;
		newElement.width = o.width;
		newElement.height = o.height;
		newElement.frameBorder = o.frameborder;
		newElement.style.position = o.position;
		fcSetSize(newElement,o.width,o.height);
		fcMoveElementTo(newElement,o.x,o.y);
		
		if (String(o.backgroundTransparent)!="true") {
			newElement.style.backgroundColor = "#" + o.backgroundColor;
		}
		newElement.style.color = "#" + o.color;
		// always 0px - do not add a border to the iframe itself
		// add a child div and add a border to that or add border in mxml
		newElement.style.border = o.border;
		newElement.style.padding = o.padding;
		newElement.src = o.source;
		
		//  use innerHTML or DOM element creation methods to put content into body
		document.body.appendChild(newElement);
		
		newElement.onload = function() {
			// set a flag so the application knows the page is loaded
			fcDelayedDispatchEvent("htmlCreationComplete", o.movieId, o.id, fcEventTimeoutInterval);
		}
		
		newElement.onunload = function() {
			// set a flag so the application knows the page is unloading
			// can we purge this from memory here?
			fcDispatchEvent("htmlUnload", o.movieId, o.id);
		}
		
		fcAddToGlobalArray(newElement, o);
		
		if (String(o.visible)=="false") {
			fcHide(o.id,true,false);
		}
		
    }
    
    // add mocha ui pop up to the page
    function fcAddChildPopUp(o) {
		fcGetIncludes(o.includesBefore);
		var p = new Object();
		p.id = o.id;
		p.content = o.htmlText;
		p.x = o.x;
		p.y = o.y;
		if (String(o.centerPopUp)!="true") {
			p.x = o.x;
			p.y = o.y;
		}
		p.contentURL = String(o.source);
		if (String(o.backgroundTransparent)!="true") {
			p.bodyBgColor = "" + o.backgroundColor;
		}
		p.color = "" + o.color;
		p.title = o.title;
		p.modal = o.modal;
		p.width = o.width;
		p.height = o.height;
		p.minimizable = o.minimizable;
		p.maximizable = o.maximizable;
		p.resizable = o.resizable;
		p.draggable = o.draggable;
		p.closable = o.closable;
		p.headerHeight = o.headerHeight;
		p.footerHeight = o.footerHeight;
		p.headerTitleTop = o.headerTitleTop;
		p.headerControlsTop = o.headerControlsTop;
		
		p.onContentLoaded = function (e) {
			fcDelayedDispatchEvent("htmlPopUpContentLoaded", o.movieId, o.id, fcEventTimeoutInterval)
		}
		p.onFocus = function (e) {
			fcDispatchEvent("htmlPopUpFocus", o.movieId, o.id)
		}
		p.onResize = function (e) {
			fcDispatchEvent("htmlPopUpResize", o.movieId, o.id)
		}
		p.onMinimize = function (e) {
			fcDispatchEvent("htmlPopUpMinimize", o.movieId, o.id)
		}
		p.onMaximize = function (e) {
			fcDispatchEvent("htmlPopUpMaximize", o.movieId, o.id)
		}
		p.onClose = function (e) {
			// we need to listen to this event and handle it in flex html manager class for alerts
			fcDispatchEvent("htmlPopUpClose", o.movieId, o.id)
		}
		p.onCloseComplete = function (e) {
			fcDispatchEvent("htmlPopUpCloseComplete", o.movieId, o.id)
		}
		
		// html, xhr, or iframe
		if (o.type == "division") {
			p.loadMethod = "html";
		}
		else if (o.type == "iframe") {
			p.loadMethod = "iframe";
		}
		else if (o.type == "xhr") {
			p.loadMethod = "xhr";
		}
		
		if (String(o.chrome)=="true" && document.mochaUI) {
			// apply any options
			var mocha = document.mochaUI;
			var options = document.mochaUI.options;
			var popUpOptions = o.popUpOptions;
			for (var name in popUpOptions) {
				if (typeof options[name] !="undefined") {
					options[name] = popUpOptions[name];
				}
				if (typeof mocha[name] !="undefined") {
					mocha[name] = popUpOptions[name];
				}
			}
			mocha.newWindow(p, false);
		}
		
		fcAddToGlobalArray(fcGetElement(o.id), o);
		
		fcGetIncludes(o.includesAfter);
		
		if (String(o.visible)=="false") {
			//fcHide(o.id,true,false);
		}
		
		// dispatch when window is created
		fcDelayedDispatchEvent("htmlCreationComplete", o.movieId, o.id, fcEventTimeoutInterval);
		if (String(o.alert)=="true") {
			var newElement = document.createElement("div");
			newElement.id = o.id + "_alert_buttons";
			newElement.movieId = o.movieId;
			//newElement.style.position = "absolute";
			//newElement.style.bottom = "6px";
			//newElement.style.right = "6px";
			newElement.className = "mochaAlertButtons"; // set in css/mocha.css
			
			for (var i=0;i<o.alertButtons.length;i++) {
				var button = document.createElement("input");
				var value = o.alertButtons[i];
				button.type = "button";
				button.value = value;
				button.className = "mochaAlertButton"; // set in css/mocha.css
				
				button.onclick = function(e) {
					fcDispatchEvent2("htmlAlertHandler", o.movieId, o.id, this.value);
					var el = fcGetElement(o.id);
					if(document.mochaUI) {
						document.mochaUI.closeWindow(el);
					}
				}
				newElement.appendChild(button);
			}
			
			var el = fcGetElement(o.id);
			el.appendChild(newElement);
		}
    }
    
	// add to associative array - do we need to make any changes for garbage collecting?
	function fcAddToGlobalArray(el, o) {
		var newElement = new Object();
		newElement.element = el; // could cause memory leak do we need it?
		newElement.id = o.id;
		newElement.loaded = false;
		newElement.type = o.type;
		newElement.popUp = o.chrome;
		newElement.alert = o.alert;
		newElement.movieId = o.movieId;
		if (o.type == "editor") {
			// set first in addChildEditor
			newElement.editor = fcHTMLControls[o.id].editor;
		}
		else {
			newElement.editor = "";
		}
		
		fcHTMLControls[o.id] = newElement;
	}
	
	// evaluates a script and returns the value - note use ExternalInterface to call functions
	function fcCallScript(str) {
		try {
			var something = eval(str);
			return something;
		}
		catch(e) {
			return false;
		}
	}

	// handle when flash text field gets focus, text field in iframe is greedy
	function fcDefocus(elementId) {
		var element = fcGetElement(elementId);
		if (element && element.movieId) {
			var movie = fcGetMovieById(element.movieId);
			element.style.visibility = "hidden";
			window.focus();
			movie.focus();
			element.style.visibility = "visible";
		}
		else {
			window.focus();
			element.focus();
		}
	}

	// call actionscript function after specified delay
    // we do this to give the browser and flash time to sync
	function fcDelayedDispatchEvent(eventName,movieId,id,delay) {
		setTimeout("fcDispatchEvent('"+eventName+"','"+movieId+"','"+id+"')",delay);
	}
	
    // dispatch creation complete event 
	function fcDispatchEvent(eventName, movieId, id) {
		var movie = fcGetMovieById(movieId);
		movie[eventName](id);
	}
	
	// dispatch creation complete event 
	function fcDispatchEvent2(eventName, movieId, id, value) {
		var movie = fcGetMovieById(movieId);
		movie[eventName](id, value);
	}
    
	//usage: var currentTarget = fcEventTrigger (e);
    function fcEventTrigger (e) {
    	if (!e) { e = event; }
    	return e.target || e.srcElement;
	}
	
	// finds the absolute position of the swf movie
	function fcFindPosition(obj) {
		var left = obj.offsetLeft;
		var top = obj.offsetTop;
		if (obj.offsetParent) {
			var parentPos = this.fcFindPosition(obj.offsetParent);
			if (parentPos[0]) left += parentPos[0];
  			if (parentPos[1]) top += parentPos[1];
 		}
		return [left,top];
 	}
    
	// The FCKeditor_OnComplete function is a special function called everytime an
	// editor instance is completely loaded and available for API interactions.
	function FCKeditor_OnComplete(editorInstance) {
		var editor = fcGetElement(editorInstance.Name);
		if (editor) {
			fcHTMLControls[editor.parentNode.id].loaded = true;			
			fcDelayedDispatchEvent("htmlCreationComplete", editor.parentNode.movieId, editor.parentNode.id, fcEventTimeoutInterval);
		}
	}
	
	// gets the element by name
	function fcGetElement(id) {
		return document.getElementById(id);
	}
	
	// cannot get height of pages loaded from different domains
	// ie, page is hosted at www.yoursite.com and you load www.google.com will fail with return value of -1
	// works in ff and ie. not tested in mac browsers - 
	function fcGetElementHeight(id){
		var el = fcGetElement(id);
		moz = (document.getElementById && !document.all);
		
		if (el) {
		
			// check the height value
			try {
			
				/*** return div height ***/
				if (el.nodeName.toLowerCase()=="div") {
					var scrollHeight = el.scrollHeight;
					var divHeight = el.style.height;
					divHeight = (scrollHeight > parseInt(divHeight)) ? scrollHeight : divHeight;
					return divHeight;
				}
				
				/*** return iframe height ***/
				//moz
				if (moz) {
					return el.contentDocument.body.scrollHeight;
				}
				else if (el.Document) {
					return el.Document.body.scrollHeight;
				}
			}
			catch(e) {
				//An error is raised if the content in the iframe is not from the same domain as the swf
				//alert('Error: ' + e.number + '; ' + e.description+'\nPossibly - Cannot access height of iframe because the content is from another dudes domain');
				return -1;
			}
		}
	}

	// get property value
	function fcGetElementValue(id, elProperty){
		
		// if periods are in the name assume absolute path 
		// otherwise assume element id
		if (id.indexOf('.')!=-1) {
			var newArr = id.split('.');
			var elValue = "";
			
			try {
				el = window;
				for (var i=0;i < newArr.length;i++) {
					el = el[newArr[i]];
				}
				return el;
			}
			catch (e) {
				//alert("Whoooops!! Cant find " + id);
				// should return null or undefined here
				return -1;
			}
		}
		else {
			// try and get property value
			try {
				var el = fcGetElement(id);
				var elValue = el[elProperty];
				return elValue;
			}
			catch(e) {
				//alert("Error: Can't find " + id + "." + elProperty);
				// should return null or undefined here
				return -1;
			}
		}
	}
	
	// get HTML content
	function fcGetHTML(id, elementType, editorType, chrome) {
		var el = fcGetElement(id);
		if (el!=null) {
			
			if (elementType =="division" && String(chrome)=="true") {
				var elContent = fcGetElement(id + "_content");
				if (elContent != null) {
					return String(elContent.innerHTML);
				}
			}
			else if (elementType=="division") {
				return el.innerHTML;
			}
			else if (elementType == "editor") {
				var oEditor;
				
				// add additional editor support here
				if (editorType=="fckeditor") {
					if ( typeof( FCKeditorAPI ) != 'undefined' ) {
						oEditor = FCKeditorAPI.GetInstance( id + "Editor" );
						if ( oEditor )	{
							// Get the current text in the editor.
							return oEditor.GetXHTML();
						}
					}
				}
				else if (editorType=="tinymce") {
					return tinyMCE.getContent(id);
				}
				else if (editorType=="xinha") {
					//var ed = editors[id];
					var ed = fcHTMLControls[id].editor;
					if (typeof Xinha != "undefined") {
						return ed.getHTML();
					}
					return ed.value;
				}
				
			}
		}
		return "";
	}

	// load javascript files dynamically
	function fcGetIncludes(includes, elementName) {
		var len = includes.length;
		var locale = "";
		if (String(elementName)=="head") {
			locale = document.getElementsByTagName("head")[0];
		}
		else {
			locale = document.body;
		}
		
		for (var i=0;i<len;i++) {
			var el = document.createElement("script");
			el.type = "text/javascript";
			el.src = includes[i];
			locale.appendChild(el);
		}
	}

	// get reference to the flash movie	
	function fcGetMovieById(id) {
		if (navigator.appName.indexOf ("Microsoft") !=-1) {
			return window[id];
		} else {
			return window.document[id];
		}
	}

	// load css stylesheets dynamically
	function fcGetStyleSheets(sheets) {

		var len = sheets.length;
		var head = document.getElementsByTagName("head")[0];
		var body = document.body;
		// this 
		for (var i=0;i<len;i++) {
			var cssNode = document.createElement('link');
			cssNode.type = 'text/css';
			cssNode.rel = 'stylesheet';
			cssNode.href = sheets[i];
			cssNode.media = 'screen';
			head.appendChild(cssNode);
		}
		
		// we shouldn't have to do this
		// in tests locally styles were partially applied (ff mac)
		// doing something to make the browser redraw the div would apply the stylesheet fully
		setTimeout("fcUpdateStyleSheets()", 10);
	}
	
	// checks if browser is IE
	function fcIsIE(version) {
		var isIE = (navigator.appVersion.indexOf("MSIE") != -1) ? true : false;
		return isIE;
	}
	
	// hide element by name
	// set height of content to 0px so the 
	// flash context menu appears in the right location
	// note: display none also fixes the issue but have not implemented yet
	function fcHide(id, hideOffscreen, offscreenOffset) {
		var el = fcGetElement(id);
		if (hideOffscreen) {
			//el.style.width = "0px";
			//el.style.height = "0px";
		}
		//el.style.visibility = "hidden";
		el.style.display = "none";
	}
	
	// move element to new location
	function fcMoveElementTo(el,x,y) {
		var movie = fcGetMovieById(el.movieId);
		if (fcRelativeMovie) {
			el.style.left = parseInt(x) + fcFindPosition(movie)[0] + "px";
			el.style.top = parseInt(y) + fcFindPosition(movie)[1] + "px";
		}
		else {
			el.style.left = parseInt(x) + "px";
			el.style.top = parseInt(y) + "px";
		}
	}
	
	// warn user if they or a link try to navigate them away from the page - used to prevent data loss / save changes
	// TODO: we should apply this to iframes in the future and then remove the iframe handlers on window.onbeforeunload
	function fcPromptOnUnload(prompt, message) {
		if (String(prompt) == "true") {
			window.onbeforeunload = function (e) {
				return message;
			};
		}
		else {
			window.onbeforeunload = function (e) {
				
			}
		}
	}
	
	// call before removing from DOM - necessary?
	// credit - http://javascript.crockford.com/memory/leak.html
	function fcPurge(d) {
		var a = d.attributes, i, l, n;
		if (a) {
			l = a.length;
			for (i = 0; i < l; i += 1) {
				n = a[i].name;
				if (typeof d[n] === 'function') {
					d[n] = null;
				}
			}
		}
		a = d.childNodes;
		if (a) {
			l = a.length;
			for (i = 0; i < l; i += 1) {
				fcPurge(d.childNodes[i]);
			}
		}
	}
	
	// forces redraw
	function fcRefresh(id) {
		var el = fcGetElement(id);
		el.style.cssText = el.style.cssText;
	}
	
	// remove and get memory back	
	function fcRemove(id) {
		//fcHide(id, true);
		var el = fcGetElement(id);
		var elParent = el.parentNode;
		fcPurge(el);
		fcHTMLControls[id] = null;
		elParent.removeChild(el);
	}
	
	// clips the html content
	function fcSetClip(id, top, right, bottom, left) {
		var el = fcGetElement(id);
		if (el!=null) {
			el.style.clip = "rect(" + top + " " + right + " " + bottom + " " + left  + ")";
		}
	}
    
	// set document title
    function fcSetDocumentTitle(title) {
        window.document.title = title;
    }
	
	// set HTML content
	function fcSetHTML(id, htmlText, elementType, editorType, chrome) {
		var el = fcGetElement(id);
		if (el!=null) {
		
			if (elementType =="division" && String(chrome)=="true") {
				var elContent = fcGetElement(id + "_content");
				elContent.innerHTML = htmlText;
			}
			else if (elementType =="division") {
				el.innerHTML = htmlText;
			}
			else if (elementType == "editor") {
				var oEditor;
				
				// add additional editor support here
				if (editorType == "fckeditor") {
					if ( typeof( FCKeditorAPI ) != 'undefined' ) {
						oEditor = FCKeditorAPI.GetInstance( id + "Editor" );
						if ( oEditor )	{
							// Set the text in the editor.
							oEditor.SetHTML( htmlText ) ;
						}
					}
				}
				else if (editorType=="tinymce") {
					var editor = tinyMCE.getInstanceById(id+"Editor");
					editor.setHTML(htmlText);
				}
				else if (editorType=="xinha") {
					//var ed = editors[id];
					var ed = fcHTMLControls[id].editor;
					if (typeof Xinha != "undefined") { 
						ed.setEditorContent(htmlText);
					}
					else {
						ed.value = htmlText;
					}
				}
			}
		}
	}
	
	// set position - should we use fcFindPosition here?
	function fcSetPosition(id,x,y) {
		var el = fcGetElement(id);
		var movie = fcGetMovieById(fcHTMLControls[id].movieId);
		if (fcHTMLControls[id].popUp == true ) { return }
		
		// LEFT
		if (x != undefined) {
			el.style.left = parseInt(x) + fcFindPosition(movie)[0] + "px";
		}
		// TOP
		if (y != undefined) {
			el.style.top = parseInt(y) + fcFindPosition(movie)[1] + "px";
		}
	}
	
	// save cpu when movie is at upper left corner of window
	function fcSetRelativeMovie(isRelative) {
		fcRelativeMovie = (String(isRelative)!="false") ? true : false;
	}
	
	// set scroll policy of element
	function fcSetScrollPolicy(el, overflow) {
		if (overflow != "resize") {
			el.style.overflow = overflow;
		}
	}
	
	// set scroll policy of element by id
	function fcSetScrollPolicyById(id, overflow) {
		var el = fcGetElement(id);
		
		// setting this to anything other than auto in ff fails it
		if (overflow != "resize") {
			el.style.overflow = overflow;
		}
	}
	
	// set size
	function fcSetSize(el,w,h) {
		
		if (String(w)!="undefined" && String(w)!="") {
			// if width is a percentage pass in the string as is
			if (String(w).indexOf("%")!=-1) {
				el.style.width = w;
			}
			else {
				el.style.width = parseInt(w) + "px";
			}
		}
		
		if (String(h)!="undefined" && String(h)!="") {
			if (String(h).indexOf("%")!=-1) {
				el.style.height = h;
			}
			else {
				el.style.height = parseInt(h) + "px"; 
			}
		}
	}
	
	// set size called by id
	function fcSetSizeByValue(id,w,h) {
		var el = fcGetElement(id);
		if (el.style.display=="none") { return; }
		if (fcHTMLControls[id].popUp == true ) { return }
		
		if (String(w)!="null" && String(w)!="undefined" && String(w)!="") {
			// if width is a percentage pass in the string as is
			if (String(w).indexOf("%")!=-1) {
				el.style.width = w;
			}
			else {
				el.style.width = parseInt(w) + "px";
			}
		}
		
		if (String(h)!="null" && String(h)!="undefined" && String(h)!="") {
			if (String(h).indexOf("%")!=-1) {
				el.style.height = h;
			}
			else {
				el.style.height = parseInt(h) + "px"; 
			}
		}
	}
	
	// set iframe location
	function fcSetSource(id,source) {
		var el = fcGetElement(id);
		el.src = source;
	}
	
	// show element by name
	// set display to block and we dont have to set size
	function fcShow(id, hideOffscreen, left, width, height) {
		var el = fcGetElement(id);
		//el.style.visibility = "visible";
		el.style.display = "block";
		if (hideOffscreen) {
			//el.style.width = parseInt(width) + "px";
			//el.style.height = parseInt(height) + "px";
		}
	}
	
	// causes a redraw to apply the stylesheets
	function fcUpdateStyleSheets(value) {
		
		for (var id in fcHTMLControls) {
			var o = fcHTMLControls[id];
			var element = (typeof o.element !="undefined" && typeof o.movieId !="undefined") ? o.element : "";
			if (element!="") {
				if (value) {
					element.style.display = value;
				}
				else {
					display = element.style.display;
					element.style.display = "none";
				}
			}
		}
		if (!value) {
			setTimeout('fcUpdateStyleSheets("block")', 20);
		}
	}
	
	function fcFlexOnload(movieId) {
		// calling callback is unreliable - swf movie may not be loaded yet
		//movie.onLoadComplete();
		fcHTMLControls.pageLoaded = "true";
	}
	
	// end of line