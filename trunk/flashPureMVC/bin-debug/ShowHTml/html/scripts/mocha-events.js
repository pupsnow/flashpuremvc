/* -----------------------------------------------------------------

	ATTACH MOCHA LINK EVENTS
	Notes: Here is where you define your windows and the events that open them.
	If you are not using links to run Mocha methods you can remove this function.
	
	If you need to add link events to links within windows you are creating, do
	it in the onContentLoaded function of the new window.

   ----------------------------------------------------------------- */

function attachMochaLinkEvents(){
	
	
	// Examples
	if ($('ajaxpageLink')){ // Associated HTML: <a id="xhrpageLink" href="pages/lipsum.html">XHR Page</a>
		$('ajaxpageLink').addEvent('click', function(e){	
			new Event(e).stop();
			document.mochaUI.newWindow({
				id: 'ajaxpage',
				title: 'Content Loaded with an XMLHttpRequest',
				loadMethod: 'xhr',
				contentURL: 'pages/lipsum.html',
				width: 340,
				height: 150
			});
		});
	}

	if ($('mootoolsLink')){
		$('mootoolsLink').addEvent('click', function(e){	
			new Event(e).stop();
			document.mochaUI.newWindow({
				id: 'mootools',
				title: 'Mootools Forums in an Iframe',
				loadMethod: 'iframe',
				contentURL: 'http://forum.mootools.net/',
				width: 650,
				height: 400,
				scrollbars: false,
				paddingVertical: 0,
				paddingHorizontal: 0
			});
		});
	}

	if ($('spirographLink')){
		$('spirographLink').addEvent('click', function(e){	
			new Event(e).stop();
			document.mochaUI.newWindow({
				id: 'spirograph',
				title: 'Canvas Spirograph in an Iframe',
				loadMethod: 'iframe',
				contentURL: 'pages/spirograph.html',
				width: 340,
				height: 340,
				scrollbars: false,
				paddingVertical: 0,
				paddingHorizontal: 0,
				bgColor: '#c30'
			});
		});
	}
	
	if ($('youTubeLink')) {
		$('youTubeLink').addEvent('click', function(e){
		new Event(e).stop();
			document.mochaUI.newWindow({
				id: 'youTube',
				title: 'YouTube in Iframe',
				loadMethod: 'iframe',
				contentURL: 'pages/youtube.html',
				width: 425,
				height: 355,
				scrollbars: false,
				paddingVertical: 0,
				paddingHorizontal: 0,
				bgColor: '#000'
			});
		});
	}
	
	if ($('anon1Link')){
		$('anon1Link').addEvent('click', function(e){	
			new Event(e).stop();
			document.mochaUI.newWindow({
				title: 'Content Loaded with an XMLHttpRequest',
				loadMethod: 'xhr',
				contentURL: 'pages/lipsum.html',
				width: 340,
				height: 150
			});
		});
	}
	
	if ($('anon2Link')){ 
		$('anon2Link').addEvent('click', function(e){	
			new Event(e).stop();
			document.mochaUI.newWindow({
				title: 'Content Loaded with an XMLHttpRequest',
				loadMethod: 'xhr',
				contentURL: 'pages/lipsum.html',
				width: 340,
				height: 150
			});
		});
	}	
	
}
