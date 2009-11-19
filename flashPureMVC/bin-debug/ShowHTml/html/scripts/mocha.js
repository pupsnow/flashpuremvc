/* -----------------------------------------------------------------

	Script: 
		mocha.js version 0.94
	
	Copyright:
		Copyright (c) 2007-2008 Greg Houston, <http://greghoustondesign.com/>
		Used with permission by Drumbeat Insight
	
	License:
		MIT-style license

	Contributors:
		Scott F. Frederick
		Joel Lindau

   ----------------------------------------------------------------- */

var MochaUI = new Class({
	options: {
		// Global options for windows:
		// Some of these options can be overriden for individual windows in newWindow()
		resizable:         true,
		draggable:         true,
		minimizable:       true,  
		maximizable:       true,  
		closable:          true,
		effects:           true,  // Toggles the majority of window fade and move effects see Effects section - deprecated
		maximizeEffect:    true,  // Toggles the maximize window effect - deprecated
		minWidth:          250,   // Minimum width of windows when resized
		maxWidth:          2500,  // Maximum width of windows when resized
		minHeight:         100,	  // Minimum height of windows when resized
		maxHeight:         2000,  // Maximum height of windows when resized
		useDesktop:        false, // Adds windows to desktop div or document.body
		minimizeLocation:  "bottom center", // Minimize window locations top, left, right, bottom, middle, center
		dockIconWidth:	   64,
		dockIconHeight:	   64,

		// Style options:
		headerHeight:      32,    // Height of window titlebar
		footerHeight:      16,    // Height of window footer
		headerTitleTop:    10,    // Top position of window title see mocha.css div.mocha .mochaTitlebar h3
		headerControlsTop: 10,    // Top position of window title bar controls
		cornerRadius:      9,     // has no effect when using a skin
		bodyBgColor:	   '#fff',           // Body background color - Hex
		headerStartColor:  [250, 250, 250],  // Header gradient's top color - RGB
		headerStopColor:   [228, 228, 228],  // Header gradient's bottom color
		footerBgColor:     [246, 246, 246],	 // Background color of the main canvas shape
		minimizeColor:     [231, 231, 209],  // Minimize button color
		maximizeColor:     [217, 229, 217],  // Maximize button color
		closeColor:        [229, 217, 217],  // Close button color
		resizableColor:    [209, 209, 209],  // Resizable icon color

		// skin images
		minimizeIconImage: "/html/images/icoMinTitleWindow.png",  // Minimize button image
		maximizeIconImage: "/html/images/icoMaxTitleWindow.png",  // Maximize button image
		closeIconImage:    "/html/images/icoCloseTitleWindow.png",  // Close button image
		minimizeIconImageOver: "/html/images/icoMinTitleWindow_ovr.png",  // Minimize button image over
		maximizeIconImageOver: "/html/images/icoMaxTitleWindow_ovr.png",  // Maximize button image over
		closeIconImageOver:    "/html/images/icoCloseTitleWindow_ovr.png",  // Close button image over

		// Cascade options:
		desktopTopOffset:  20,    // Use a negative number if necessary to place first window where you want it
		desktopLeftOffset: 290,
		mochaTopOffset:    70,    // Initial vertical spacing of each window
		mochaLeftOffset:   70,    // Initial horizontal spacing of each window

		// Naming options:
		// If you change the IDs of the Mocha Desktop containers in your HTML, you need to change them here as well.
		desktop:           'mochaDesktop',
		desktopHeader:     'mochaDesktopHeader',
		desktopNavBar:     'mochaDesktopNavbar',
		pageWrapper:       'mochaPageWrapper',
		dock:              'mochaDock',

		// Effects - new and misc
		displayUpdateDuration: 		20,       // time in ms to update the display during custom animations - not recommended to change
		useGraphicalSkinning: 		true,     // use graphic skins - set to false to use canvas graphics
		maximizedWindowOffsetTop: 	0,        // when a window is maximized how far it is offset from the top
		maximizedWindowOffsetBottom:0,        // when a window is maximized how far it is offset from the bottom
		maximizedWindowOffsetLeft: 	0,        // when a window is maximized how far it is offset from the left
		maximizedWindowOffsetRight: 0,        // when a window is maximized how far it is offset from the right
		restoreMinimizedDuration: 	400,   	  // READ CAREFULLY the duration of time to restore a minimized window *from the dock*
		restoreMaximizedDuration: 	400,      // READ CAREFULLY the duration of time to restore *an already maximized a window* to its previous position
		minimizeWindowDuration: 	600,      // the duration of time to minimze the window to the dock
		maximizeWindowDuration: 	600,      // the duration of time to maximize a window
		showContentWhileDragging: 	true,     // show window content when dragging
		showContentWhileMaximizing: true,  	  // show window content when maximizing
		showContentWhileRestoring: 	true,     // show window content when restoring a maximized window to its previous state
		showContentWhileMinimizing: false,    // show window content when minimizing to dock
		showContentWhileResizing: 	true,     // show window content when resizing
		showDragCursor: 			false,    // show drag cursor in title bar of draggable windows
		profiler: []
	},
	initialize: function(options) {
		this.setOptions(options);

		// Private properties
		this.minimizeOffset     = 10; // offset when minimizing - deprecated
		this.ieSupport          = 'excanvas' // Makes it easier to switch between Excanvas and Moocanvas for testing
		this.indexLevel         = 100;  // Used for z-Index
		this.windowIDCount      = 0;
		this.myTimer 			= ''; // Used with accordian
		this.iconAnimation      = ''; // Used with loading icon
		this.mochaControlsWidth = 0;
		this.minimizebuttonX    = 0;  // Minimize button horizontal position
		this.maximizebuttonX    = 0;  // Maximize button horizontal position
		this.closebuttonX       = 0;  // Close button horizontal position
		this.shadowWidth        = 3;  
		this.shadowOffset       = this.shadowWidth * 2;
		this.isAnimating 		= false;

		this.desktop       = $(this.options.desktop);
		this.desktopHeader = $(this.options.desktopHeader);
		this.desktopNavBar = $(this.options.desktopNavBar);
		this.pageWrapper   = $(this.options.pageWrapper);
		this.dock          = $(this.options.dock);

		this.dockVisible   = this.dock ? true : false;   // True when dock is visible, false when not
		this.dockAutoHide  = false;  					// True when dock autohide is set to on, false if set to off

		if ( this.dock ) { this.initializeDock(); }

		this.setDesktopSize();			// html document must be strict doc type for desktop to work in IE
		this.newWindowsFromXHTML();
		this.modalInitialize();
		this.menuInitialize();

		// Resize desktop, page wrapper, modal overlay, and maximized windows when browser window is resized
		window.onresize = function(){ this.onBrowserResize(); }.bind(this);

	},
	menuInitialize: function(){
		// Fix for dropdown menus in IE6
		if (Browser.Engine.trident4 && this.desktopNavBar){
			this.desktopNavBar.getElements('li').each(function(element) {
				element.addEvent('mouseenter', function(){
					this.addClass('ieHover');
				})
				element.addEvent('mouseleave', function(){
					this.removeClass('ieHover');
				})
			})
		};
	},
	modalInitialize: function(){
		var modalOverlay = new Element('div', {
			'id': 'mochaModalOverlay',
			'styles': {
				'height': document.getCoordinates().height
			}
		});
		if (this.options.useDesktop && this.desktop) {
			modalOverlay.injectInside(this.desktop);
		}
		else {
			modalOverlay.injectInside(document.body);
		}

		modalOverlay.setStyle('opacity', .4);
		this.modalOpenMorph = new Fx.Morph($('mochaModalOverlay'), {
				'duration': 200
				});
		this.modalCloseMorph = new Fx.Morph($('mochaModalOverlay'), {
			'duration': 200,
			onComplete: function(){
				$('mochaModalOverlay').setStyle('display', 'none');
			}.bind(this)
		});
	},
	onBrowserResize: function(){
		this.setDesktopSize();
		this.setModalSize();
		// Resize maximized windows to fit new browser window size
		setTimeout( function(){
			$$('div.mocha').each(function(el){
				if (el.isMaximized) {

					var iframe = this.getSubElement(el, 'iframe');
					if ( iframe ) {
						iframe.setStyle('display', 'none');
					}

					var localFooterOffset = 3;
					var windowDimensions = document.getCoordinates();
					var contentWrapper = this.getSubElement(el, 'contentWrapper');
					var contentWrapperHeightTo = (windowDimensions.height - el.headerHeight - el.footerHeight - this.options.maximizedWindowOffsetTop - this.options.maximizedWindowOffsetBottom - localFooterOffset);
					var contentWrapperWidthTo = (windowDimensions.width - this.options.maximizedWindowOffsetLeft - this.options.maximizedWindowOffsetRight);
					contentWrapper.setStyles({
						'height': contentWrapperHeightTo,
						'width': contentWrapperWidthTo
					});

					this.drawWindow(el);
					if ( iframe ) {
						iframe.setStyles({
							'height': contentWrapper.getStyle('height')
						});
						iframe.setStyle('display', 'block');
					}
					
				}
			}.bind(this));
		}.bind(this), 100);
	},
	newWindowsFromXHTML: function(properties, cascade){
		$$('div.mocha').each(function(el, i) {
			// Get the window title and destroy that element, so it does not end up in window content
			if ( Browser.Engine.presto || Browser.Engine.trident5 )
				el.setStyle('display','block'); // Required by Opera, and probably IE7
			var title = el.getElement('h3.mochaTitle');
			var elDimensions = el.getStyles('height', 'width');
			var properties = {
				id: el.getProperty('id'),
				height: elDimensions.height.toInt(),
				width: elDimensions.width.toInt()
			}
			// If there is a title element, set title and destroy the element so it does not end up in window content
			if ( title ) {
				properties.title = title.innerHTML;
				title.destroy();
			}
			
			/*
			// Make sure there are no null values
			for(var key in properties) {
				if ( !properties[key] )
					delete properties[key];
			} */
			
			// Get content and destroy the element
			properties.content = el.innerHTML;
			el.destroy();

			// Create window
			this.newWindow(properties, true);
		}.bind(this));

		this.arrangeCascade();
	},
	/*

	Method: newWindowsFromJSON

	Description: Create one or more windows from JSON data. You can define all the same properties
	             as you can for newWindow. Undefined properties are set to their defaults.

	*/
	newWindowsFromJSON: function(properties){
		properties.each(function(properties) {
				this.newWindow(properties);
		}.bind(this));
	},
	/*

	Method: newWindow

	Arguments: 
		properties
		cascade - boolean - this is set to true for windows parsed from the original XHTML

	*/
	newWindow: function(properties, cascade) {

		var windowProperties = $extend({
			id:                null,
			title:            'New Window',
			loadMethod:       'html', 	             // html, xhr, or iframe
			content:           '',                   // used if loadMethod is set to 'html'
			contentURL:        'pages/lipsum.html',	 // used if loadMethod is set to 'xhr' or 'iframe'
			modal:             false,
			width:             300,
			height:            125,
			x:                 null,
			y:                 null,
			scrollbars:        true,
			draggable:         this.options.draggable,
			resizable:         this.options.resizable,
			minimizable:       this.options.minimizable,
			maximizable:       this.options.maximizable,
			closable:          this.options.closable,
			useDesktop:        this.options.useDesktop,
			minimizeLocation:  this.options.minimizeLocation, 

			// Styling
			footerHeight:      this.options.footerHeight,
			headerHeight:      this.options.headerHeight,
			headerTitleTop:    this.options.headerTitleTop,
			headerControlsTop: this.options.headerControlsTop,
			paddingVertical:   10,
			paddingHorizontal: 12,
			bodyBgColor:       this.options.bodyBgColor,
			headerStartColor:  this.options.headerStartColor,  // Header gradient's top color
			headerStopColor:   this.options.headerStopColor,   // Header gradient's bottom color
			footerBgColor:     this.options.footerBgColor,	   // Background color of the main canvas shape
			minimizeColor:     this.options.minimizeColor,     // Minimize button color
			maximizeColor:     this.options.maximizeColor,     // Maximize button color
			closeColor:        this.options.closeColor,        // Close button color
			resizableColor:    this.options.resizableColor,    // Resizable icon color

			// Skins
			minimizeIconImage: this.options.minimizeIconImage,  // Minimize button image
			maximizeIconImage: this.options.maximizeIconImage, // Maximize button image
			closeIconImage:    this.options.closeIconImage,    // Close button image
			minimizeIconImageOver: this.options.minimizeIconImageOver,  // Minimize button image over
			maximizeIconImageOver: this.options.maximizeIconImageOver,  // Maximize button image over
			closeIconImageOver:    this.options.closeIconImageOver,     // Close button image over

			// Events
			onContentLoaded:   $empty,  // Event, fired when content is successfully loaded via XHR
			onFocus:           $empty,  // Event, fired when the window is focused
			onResize:          $empty,  // Event, fired when the window is resized
			onMinimize:        $empty,  // Event, fired when the window is minimized
			onMaximize:        $empty,  // Event, fired when the window is maximized
			onClose:           $empty,  // Event, fired just before the window is closed
			onCloseComplete:   $empty   // Event, fired after the window is closed
		}, properties || {});
		var windowEl = $(windowProperties.id);

		// Check if window already exists and is not in progress of closing down
		if ( windowEl && !windowEl.isClosing ) {
			if ( windowEl.isMinimized )	// If minimized -> restore
				this.restoreMinimized(windowEl);
			else // else focus
				setTimeout(function(){ this.focusWindow(windowEl); }.bind(this),10);
			return;
		}

		if (windowProperties.id == null || windowProperties.id == ''){
			windowProperties.id = 'win' + (++this.windowIDCount)
		}

		// Create window div
		var windowEl = new Element('div', {
			'class': 'mocha',			
			'id':    windowProperties.id ,
			'styles': {
				'width':   windowProperties.width,
				'height':  windowProperties.height,
				'display': 'block'
			}
		});

		// Part of fix for scrollbar issues in Mac FF2
		if (Browser.Platform.mac && Browser.Engine.gecko){
			windowEl.setStyle('position', 'fixed');	
		}

		if (windowProperties.loadMethod == 'iframe') {
			// Iframes have their own scrollbars and padding.
			windowProperties.scrollbars = false;
			windowProperties.paddingVertical = 0;
			windowProperties.paddingHorizontal = 0;
		}

		// Extend our window element
		windowEl = $extend(windowEl, {
			// Custom properties
			id:         	windowProperties.id,
			oldTop:     	0,
			oldLeft:    	0,
			oldWidth:   	0,
			oldHeight:  	0,
			iconAnimation: 	$empty,
			modal:      	windowProperties.modal,
			scrollbars: 	windowProperties.scrollbars,
			contentBorder: 	null,
			closable:   	windowProperties.closable,
			resizable:  	windowProperties.resizable && !windowProperties.modal,
			draggable:  	windowProperties.draggable && !windowProperties.modal,
			minimizable: 	windowProperties.minimizable,
			maximizable: 	windowProperties.maximizable,
			iframe: 		windowProperties.loadMethod == 'iframe' ? true : false,
			isMaximized: 	false,
			isMinimized: 	false,
			minimizeLocation:  windowProperties.minimizeLocation,

			// Custom styling
			headerHeight: 	   windowProperties.headerHeight,
			footerHeight: 	   windowProperties.footerHeight,
			headerTitleTop:    windowProperties.headerTitleTop,
			headerControlsTop: windowProperties.headerControlsTop,
			headerStartColor:  windowProperties.headerStartColor,  // Header gradient's top color
			headerStopColor:   windowProperties.headerStopColor,   // Header gradient's bottom color
			footerBgColor:     windowProperties.footerBgColor,	   // Background color of the main canvas shape
			minimizeColor:     windowProperties.minimizeColor,     // Minimize button color
			maximizeColor:     windowProperties.maximizeColor,     // Maximize button color
			closeColor:        windowProperties.closeColor,        // Close button color
			resizableColor:    windowProperties.resizableColor,    // Resizable icon color

			// Custom skins
			minimizeIconImage: windowProperties.minimizeIconImage,  // Minimize button image
			maximizeIconImage: windowProperties.maximizeIconImage, // Maximize button image
			closeIconImage:    windowProperties.closeIconImage,    // Close button image
			minimizeIconImageOver: windowProperties.minimizeIconImageOver,  // Minimize button image over
			maximizeIconImageOver: windowProperties.maximizeIconImageOver,  // Maximize button image over
			closeIconImageOver:    windowProperties.closeIconImageOver,     // Close button image over

			// Custom events
			onFocus:           windowProperties.onFocus,
			onResize:          windowProperties.onResize,
			onMinimize:        windowProperties.onMinimize,
			onMaximize:        windowProperties.onMaximize,
			onClose:           windowProperties.onClose,
			onCloseComplete:   windowProperties.onCloseComplete
		});

		// insert sub elements inside windowEl and cache them locally while creating the new window 
		var subElements = this.insertWindowElements(windowEl, windowProperties.height, windowProperties.width);

		// Set title
		subElements.title.setHTML(windowProperties.title);

		// Add content to window		
		switch(windowProperties.loadMethod) {
			case 'xhr':
				new Request({
					url: windowProperties.contentURL,
					onRequest: function(){
						this.showLoadingIcon(subElements.canvasIcon);
					}.bind(this),
					onFailure: function(){
						subElements.content.setHTML('<p><strong>Error Loading XMLHttpRequest</strong></p><p>Make sure all of your content is uploaded to your server, and that you are attempting to load a document from the same domain as this page. XMLHttpRequests will not work on your local machine.</p>');
						this.hideLoadingIcon.delay(150, this, subElements.canvasIcon);
					}.bind(this),
					onSuccess: function(response) {
						subElements.content.setHTML(response);
						this.hideLoadingIcon.delay(150, this, subElements.canvasIcon);
						windowProperties.onContentLoaded();
					}.bind(this)
				}).get();
				break;
			case 'iframe':
				if ( windowProperties.contentURL == '') {
					break;
				}
				subElements.iframe = new Element('iframe', {
					'id': windowEl.id + '_iframe', 
					'class': 'mochaIframe',
					'src': windowProperties.contentURL,
					'marginwidth':  0,
					'marginheight': 0,
					'frameBorder':  0,
					'scrolling':    'auto'
				}).injectInside(subElements.content);
				// Add onload event to iframe so we can stop the loading icon and run onContentLoaded()
				subElements.iframe.addEvent('load', function(e) {
					this.hideLoadingIcon.delay(150, this, subElements.canvasIcon);
					windowProperties.onContentLoaded();
				}.bind(this));
				this.showLoadingIcon(subElements.canvasIcon);
				break;
			case 'html':
			default:
				subElements.content.setHTML(windowProperties.content);
				windowProperties.onContentLoaded();
				break;
		}

		// Set scrollbars, always use 'hidden' for iframe windows
		subElements.contentWrapper.setStyles({
			'overflow': windowProperties.scrollbars && !windowProperties.iframe ? 'auto' : 'hidden',
			'background': windowProperties.bodyBgColor
		});

		// Set content padding
		subElements.content.setStyles({
			'padding-top': windowProperties.paddingVertical,
			'padding-bottom': windowProperties.paddingVertical,
			'padding-left': windowProperties.paddingHorizontal,
			'padding-right': windowProperties.paddingHorizontal
		});

		// Attach events to the window
		this.attachResizable(windowEl, subElements);
		this.setupEvents(windowEl, subElements);

		// Move new window into position. If position not specified by user then center the window on the page
		var dimensions = document.getCoordinates();
		var headerFooterAndShawdow = windowEl.headerHeight + windowEl.footerHeight + this.shadowOffset;

		if (!windowProperties.y) {
			var windowPosTop = (dimensions.height * .5) - ((windowProperties.height + headerFooterAndShawdow) * .5);
		}
		else {
			var windowPosTop = windowProperties.y
		}
		
		if (!windowProperties.x) {
			var windowPosLeft =	(dimensions.width * .5) - (windowProperties.width * .5);
		}
		else {
			var windowPosLeft = windowProperties.x
		}
		
		if (windowEl.modal) {
			$('mochaModalOverlay').setStyle('display', 'block');
			if (this.options.effects == false){
				$('mochaModalOverlay').setStyle('opacity', .55);
			}
			else {
				this.modalCloseMorph.cancel();
				this.modalOpenMorph.start({
					'opacity': .55
				});
			}
			windowEl.setStyles({
				'top': windowPosTop,
				'left': windowPosLeft,
				'zIndex': 11000
			});
		}
		else if (cascade == true) {
			// do nothing
		}
		else if (this.options.effects == false){
			windowEl.setStyles({
				'top': windowPosTop,
				'left': windowPosLeft
			});
		}
		else {
			var opacity = Browser.Engine.trident ? 1 : 0;
			
			// TODO - Fade In
			windowEl.setStyles({
				'top': windowPosTop,
				'left': windowPosLeft,
				'opacity': opacity
			});

			windowEl.positionMorph = new Fx.Morph(windowEl, {
				'duration': 300
			});
			windowEl.positionMorph.start({
				'opacity': 1
			});

			setTimeout(function(){ this.focusWindow(windowEl); }.bind(this), 10);

		}

		// Inject window into DOM
		if (this.options.useDesktop && this.desktop) {
			windowEl.injectInside(this.desktop);
		}
		else {
			windowEl.injectInside(document.body);
		}

		this.drawWindow(windowEl, subElements);

		// Drag.Move() does not work in IE until element has been injected, thus setting here
		this.attachDraggable(windowEl, subElements.titleBar);

	},
	/*

	Method: closeWindow

	Arguments: 
		el: the $(window) to be closed

	Returns:
		true: the window was closed
		false: the window was not closed

	*/
	closeWindow: function(windowEl) {
		// Does window exist and is not already in process of closing ?
		if ( !(windowEl == $(windowEl)) || windowEl.isClosing )
			return;

		windowEl.isClosing = true;
		windowEl.onClose();

		// closing window without animation bc browser progress loader hangs at 99%
		if (true){
			windowEl.setStyle("display", "none");
			if (windowEl.modal) {
				//$('mochaModalOverlay').setStyle('opacity', 0);
				var closeMorph = new Fx.Morph($('mochaModalOverlay'), {
					'duration': 50
				});
				closeMorph.start({
					'opacity': 0
				});
			}

			windowEl.destroy();
			windowEl.onCloseComplete();
			return true;
		}

		if (this.options.effects == false){
			if (windowEl.modal) {
				$('mochaModalOverlay').setStyle('opacity', 0);
			}
			windowEl.destroy();
			windowEl.onCloseComplete();
		}
		else {
			// Redraws IE windows without shadows since IE messes up canvas alpha when you change element opacity
			if (Browser.Engine.trident) this.drawWindow(windowEl, null, false);
			if (windowEl.modal) {
				this.modalCloseMorph.start({
					'opacity': 0
				});
			}

			var closeMorph = new Fx.Morph(windowEl, {
				'duration': 250,
				'onComplete': function(){
					windowEl.destroy();
					windowEl.onCloseComplete();
				}.bind(this)
			});
			closeMorph.start({
				'opacity': .4
			});
		}
		return true;
	},
	/*

	Method: closeAll

	Notes: This closes all the windows

	Returns:
		true: the windows were closed
		false: the windows were not closed

	*/	
	closeAll: function() {
		$$('div.mocha').each(function(el) {
			this.closeWindow(el);
			$$('button.mochaDockButton').destroy();
		}.bind(this));

		return true;
	},
	/*

	Method: minimizeAll

	Notes: This minimizes all the windows

	Returns:
		true: the windows were minimized
		false: the windows were not minimized

	*/
	minimizeAll: function() {
		$$('div.mocha').each(function(el) {
			this.minimizeWindow(el);
			$$('button.mochaDockButton').destroy();
		}.bind(this));

		return true;
	},
	focusWindow: function(windowEl){
		if ( !(windowEl = $(windowEl)) )
			return;
		// Only focus when needed
		if ( windowEl.getStyle('zIndex').toInt() == this.indexLevel )
			return;
		this.indexLevel++;
		windowEl.setStyle('zIndex', this.indexLevel);
		windowEl.onFocus();
	},
	maximizeWindow: function(windowEl) {
		// If window no longer exists or is maximized, stop
		if ( !(windowEl = $(windowEl)) || windowEl.isMaximized )
			return;
		var contentWrapper = this.getSubElement(windowEl, 'contentWrapper');
		windowEl.onMaximize();

		// Save original position, width and height
		windowEl.oldTop = windowEl.getStyle('top');
		windowEl.oldLeft = windowEl.getStyle('left');
		windowOldWidth = windowEl.getStyle('width');
		windowOldHeight = windowEl.getStyle('height');
		contentWrapper.oldWidth = contentWrapper.getStyle('width');
		contentWrapper.oldHeight = contentWrapper.getStyle('height');

		// we should disable draggable when maximized

		var windowDimensions = document.getCoordinates();
		var localFooterOffset = 3;
		var contentWrapperHeightTo = (windowDimensions.height - windowEl.headerHeight - windowEl.footerHeight - this.options.maximizedWindowOffsetTop - this.options.maximizedWindowOffsetBottom - localFooterOffset);
		var contentWrapperWidthTo = (windowDimensions.width - this.options.maximizedWindowOffsetLeft - this.options.maximizedWindowOffsetRight);
		var morphDuration = this.options.maximizeWindowDuration;
		this.windowEl = windowEl;

		if (this.options.maximizeEffect == false) {
			windowEl.setStyles({
				'top': this.options.maximizedWindowOffsetTop,
				'left': "0px"
			});
			contentWrapper.setStyles({
				'height': contentWrapperHeightTo,
				'width':  contentWrapperWidthTo
			});
			this.drawWindow(windowEl);
			// Show iframe
			if ( windowEl.iframe ) {
				this.getSubElement(windowEl, 'iframe').setStyle('display', '');
			}
		}
		else {

			// Hide iframe
			// Iframe should be hidden when minimizing, maximizing, and moving for performance and Flash issues
			if ( windowEl.iframe && !this.options.showContentWhileMaximizing ) {
				this.getSubElement(windowEl, 'iframe').setStyle('display', 'none');
			}

			var maximizeMorph = new Fx.Elements([windowEl.getElement('.mochaContentWrapper'), windowEl], {
				'duration': morphDuration,
				'onStart': function(windowEl) {
					this.isAnimating = true;
					this.windowEl.setStyle('display', 'block');
					this.focusWindow(this.windowEl);
					this.maximizeAnimation = this.drawWindow.periodical(this.options.displayUpdateDuration, this, this.windowEl);
				}.bind(this),
				'onComplete': function(windowEl) {
					this.isAnimating = false;
					$clear(this.maximizeAnimation);
					this.drawWindow(this.windowEl);
					// Show iframe if hidden
					if ( this.windowEl.iframe ) {
						this.getSubElement(this.windowEl, 'iframe').setStyle('display', '');
					}
				}.bind(this)
			});

			maximizeMorph.start({
				'0': {	'height': contentWrapperHeightTo,
						'width':  contentWrapperWidthTo
				},
				'1': {	'top':  this.options.maximizedWindowOffsetTop,
						'left': this.options.maximizedWindowOffsetLeft
				}
			});
		}

		windowEl.isMaximized = true;
	},
	restoreWindow: function(windowEl) {
		// Window exists and is maximized ?
		if ( !(windowEl == $(windowEl)) || !windowEl.isMaximized )
			return;

		// Hide iframe
		// Iframe should be hidden when minimizing, maximizing, and moving for performance and Flash issues
		if ( windowEl.iframe && !this.options.showContentWhileRestoring) {
			this.getSubElement(windowEl, 'iframe').setStyle('display', 'none');
		}
		var contentWrapper = this.getSubElement(windowEl, 'contentWrapper');
		var morphDuration = this.options.restoreMaximizedDuration;
		var localCornerColor = "#0670ac";

		windowEl.isMaximized = false;

		if (this.options.effects == false){
			windowEl.setStyles({
				'top': windowEl.oldTop,
				'left': windowEl.oldLeft
			});
			contentWrapper.setStyles({
				'width':  contentWrapper.oldWidth,
				'height': contentWrapper.oldHeight
			});
			this.drawWindow(windowEl);
			// Show iframe
			if ( windowEl.iframe ) {
				this.getSubElement(windowEl, 'iframe').setStyle('display', '');
			}
		}
		else {
			var restoreMorph = new Fx.Elements([windowEl.getElement('.mochaContentWrapper'), windowEl], {
				'duration': morphDuration,
				'onStart': function(windowEl) {
					this.isAnimating = true;
					this.windowEl.setStyle('display', 'block');
					this.focusWindow(this.windowEl);
					this.restoreAnimation = this.drawWindow.periodical(this.options.displayUpdateDuration, this, this.windowEl);
				}.bind(this),
				'onComplete': function(windowEl) {
					this.isAnimating = false;
					$clear(this.restoreAnimation);
					this.drawWindow(this.windowEl);
					// Show iframe
					if ( this.windowEl.iframe ) {
						this.getSubElement(this.windowEl, 'iframe').setStyle('display', '');
					}
				}.bind(this)
			});

			restoreMorph.start({
				'0': {	'width': contentWrapper.oldWidth,
						'height': contentWrapper.oldHeight
				},
				'1': {	'top':  windowEl.oldTop,
						'left': windowEl.oldLeft
				}
			});
		}
	},
	minimizeWindow: function(windowEl) {
		if ( !(windowEl == $(windowEl))) return;

		var contentWrapper = this.getSubElement(windowEl, 'contentWrapper');

		// Save original position, width and height
		windowEl.oldTop2 = windowEl.getStyle('top');
		windowEl.oldLeft2 = windowEl.getStyle('left');
		contentWrapper.oldWidth2 = contentWrapper.getStyle('width');
		contentWrapper.oldHeight2 = contentWrapper.getStyle('height');

		// Hide iframe
		// Iframe should be hidden when minimizing, maximizing, and moving for performance and Flash issues
		if ( windowEl.iframe && !this.options.showContentWhileMinimizing) {
			this.getSubElement(windowEl, 'iframe').setStyle('display', 'none');
		}

		this.windowEl = windowEl;
		var morphDuration = this.options.minimizeWindowDuration;
		var windowDimensions = document.getCoordinates();

		var minimizeSizeMorph = new Fx.Elements([windowEl.getElement('.mochaContentWrapper'), windowEl], {
			'duration': morphDuration,
			'onStart': function(windowEl) {
				this.isAnimating = true;
				this.minimizeAnimation = this.drawWindow.periodical(this.options.displayUpdateDuration, this, this.windowEl);
			}.bind(this),
			'onComplete': function(windowEl){
				this.isAnimating = false;
				this.windowEl.isMinimized = true;
				$clear(this.minimizeAnimation);	
				this.windowEl.setStyle('display', 'none');
				this.makeMinimizeButton(this.windowEl);
				// Fixes a scrollbar issue in Mac FF2.
				// Have to use timeout because window gets focused when you click on the minimize button 
				setTimeout(function(){ this.windowEl.setStyle('zIndex', 1); }.bind(this),100);
				this.windowEl.onMinimize();
			}.bind(this)
		});

		var opacity = Browser.Engine.trident ? 1 : 0.1;
		
		if (windowEl.minimizeLocation=="center") {
			opacity = Browser.Engine.trident ? 1 : 0;
		}
		
		var minimizeLocation = this.getMinimizeLocation(windowEl);

		minimizeSizeMorph.start({
			'0': {	'height': this.options.dockIconHeight,
					'width':  this.options.dockIconWidth
			},
			'1': {	'top':  (this.dock.getProperty('dockPosition') == 'Top' && this.options.useDesktop) ? this.minimizeOffset : minimizeLocation[1],
					'left': minimizeLocation[0],
					'opacity': opacity
			}
		});

		 // Fixes a scrollbar issue in Mac FF2
		if (Browser.Platform.mac && Browser.Engine.gecko){
			this.getSubElement(windowEl, 'contentWrapper').setStyle('overflow', 'hidden');
		} 
	},
	makeMinimizeButton: function(windowEl) {
		var title = this.getSubElement(windowEl, 'title');
		var titleText = title.innerHTML;
		var dockButton = new Element('button', {
			'id': windowEl.id + '_dockButton',
			'class': 'mochaDockButton',
			'title': titleText
		}).setHTML(titleText.substring(0,13) + (titleText.length > 13 ? '...' : '')).injectInside($(this.dock));
		dockButton.addEvent('click', function(event) {
			this.restoreMinimized(windowEl);
		}.bind(this));

	},
	getMinimizeLocation: function(windowEl) {
		var minimizeLocation = windowEl.minimizeLocation;
		var windowDimensions = document.getCoordinates();
		var minimizeTop = 0; // default to top
		var minimizeLeft = 0; // default to left
		
		// vertical location
		if (minimizeLocation.indexOf("middle")!=-1) {
			minimizeTop = (windowDimensions.height.toInt() * .5) - (this.options.dockIconHeight * .5);
		}
		else if (minimizeLocation.indexOf("bottom")!=-1) {
			minimizeTop = windowDimensions.height.toInt() - (this.options.dockIconHeight * .5);
		}
		
		// horizontal location
		if (minimizeLocation.indexOf("center")!=-1) {
			minimizeLeft = (windowDimensions.width.toInt() * .5) - (this.options.dockIconWidth * .5);
		}
		else if (minimizeLocation.indexOf("right")!=-1) {
			minimizeLeft = windowDimensions.width.toInt() - this.options.dockIconWidth;
		}
		
		if (minimizeLocation=="center") {
			minimizeTop = (windowDimensions.height.toInt() * .5) - (this.options.dockIconWidth * .5);
			minimizeLeft = (windowDimensions.width.toInt() * .5) - (this.options.dockIconWidth * .5);
		}
		
		// pixel values
		if (minimizeLocation.indexOf(",")!=-1) {
			minimizeLeft = minimizeLocation.split(",")[0];
			minimizeTop = minimizeLocation.split(",")[1];
		}
		
		// location is array of [left, top]
		return [minimizeLeft, minimizeTop];
	},
	restoreMinimized: function(windowEl) {

		 // Part of Mac FF2 scrollbar fix
		if (windowEl.scrollbars == true && windowEl.iframe == false){ 
			this.getSubElement(windowEl, 'contentWrapper').setStyle('overflow', 'auto');
		}
		
		var contentWrapper = this.getSubElement(windowEl, 'contentWrapper');
		this.windowEl = windowEl;
		var windowDimensions = document.getCoordinates();
		if (this.dock) {
			this.dock.getElementById(windowEl.id + '_dockButton').destroy();
		}
		var morphDuration = this.options.restoreMinimizedDuration;

		var minimizeLocation = this.getMinimizeLocation(windowEl);
		
		if (this.dock.getProperty('dockPosition') == 'Top' && this.options.useDesktop) {
			this.windowEl.setStyle('top', this.minimizeOffset);
		}
		else {
			this.windowEl.setStyle('top', minimizeLocation[1]);
			this.windowEl.setStyle('left', minimizeLocation[0]);
		}

		var restoreSizeMorph = new Fx.Elements([windowEl.getElement('.mochaContentWrapper'), windowEl], { 
			'duration': 300,
			'onStart': function(windowEl){
				this.windowEl.setStyle('display', 'block');
				this.focusWindow(this.windowEl);
				this.restoreAnimation = this.drawWindow.periodical(this.options.displayUpdateDuration, this, this.windowEl);
			}.bind(this),
			'onComplete': function(windowEl){
				$clear(this.restoreAnimation);
				this.drawWindow(this.windowEl);
				// Show iframe
				if ( this.windowEl.iframe ) {
					this.getSubElement(this.windowEl, 'iframe').setStyle('display', '');
				}
				this.windowEl.isMinimized = false;
			}.bind(this)
		});

		restoreSizeMorph.start({
			'0': {	'height': contentWrapper.oldHeight2,
					'width':  contentWrapper.oldWidth2
			},
			'1': {	'top':  windowEl.oldTop2,
					'left': windowEl.oldLeft2,
					'opacity': 1
			}
		});

	},

	/* -- START Private Methods -- */

	/*
		Method: getSubElement()
		Description: 
			Get a single subElement within windowEl. Subelements have IDs that are made up of the windowEl ID plus
			an element key. e.g., myWindow_content or myWindow_iframe.
			Might rename these parentWindow and childElements in the future.
		Arguments: 
			windowEl, subElementKey
		Returns:
			subElement
	*/

	getSubElement: function(windowEl, subElementKey) {
		return windowEl.getElementById((windowEl.id + '_' + subElementKey));
	},
	/*
		Method: getSubElements()
		Description:
			Get subElements within windowEl referenced in array subElementsKeys 
		Arguments:
			windowEl, subElementKeys
		Returns:
			Object, where elements are object.key
	*/
	getSubElements: function(windowEl, subElementKeys) {
		var subElements = {};
		subElementKeys.each(function(key) {
			subElements[key] = this.getSubElement(windowEl, key);
		}.bind(this));
		return subElements;
	},
	/*
		Method: setupControlEvents()
		Usage: internal

		Arguments:
			windowEl
	*/
	setupEvents: function(windowEl, subElements) {
		/*if ( !subElements )
			subElements = this.getSubElements(windowEl, ['closeButton','minimizeButton','maximizeButton']);*/

		// Set events
		// Note: if a button does not exist, its due to properties passed to newWindow() stating otherwice
		if ( subElements.closeButton )
			subElements.closeButton.addEvent('click', function() { this.closeWindow(windowEl); }.bind(this));

		if ( !windowEl.modal )
			windowEl.addEvent('click', function() { this.focusWindow(windowEl); }.bind(this));

		if ( subElements.minimizeButton )
			subElements.minimizeButton.addEvent('click', function() { this.minimizeWindow(windowEl); }.bind(this));

		if ( subElements.maximizeButton ) {
			subElements.maximizeButton.addEvent('click', function() { 
				if ( windowEl.isMaximized ) {
					this.restoreWindow(windowEl);
					subElements.maximizeButton.setProperty('title', 'Maximize');
				} else {
					this.maximizeWindow(windowEl); 
					subElements.maximizeButton.setProperty('title', 'Restore');
				}
			}.bind(this));
		}
	},
	/*
		Method: attachDraggable()
		Description: make window draggable
		Usage: internal

		Arguments:
			windowEl
	*/
	attachDraggable: function(windowEl, handleEl){
		if ( !windowEl.draggable || windowEl.isMaximized) {
			return;
		}
		var newMove = new Drag.Move(windowEl, {
			handle: handleEl,
			onStart: function() {
				if (windowEl.isMaximized) { 
					newMove.stop();
					return;
				}
				this.isAnimating = true;
				this.focusWindow(windowEl);
				if ( windowEl.iframe && !this.options.showContentWhileDragging) { 
					this.getSubElement(windowEl, 'iframe').setStyle('display', 'none');
				}
				else {
					// allows use to show content while dragging and protects the cursor if it moves into the iframe
					this.getSubElement(windowEl, 'dragOverlay').setStyle('display', 'block');
					if (this.options.showDragCursor) {
						this.getSubElement(windowEl, 'dragOverlay').setStyle('cursor', 'move');
					}
				}
			}.bind(this),
			onComplete: function() {
				this.isAnimating = false;
				if ( windowEl.iframe ) {
					var iframe1 = this.getSubElement(windowEl, 'iframe');
					this.getSubElement(windowEl, 'iframe').setStyle('display', '');
				}
				this.getSubElement(windowEl, 'dragOverlay').setStyle('display', 'none');
				this.getSubElement(windowEl, 'dragOverlay').setStyle('cursor', 'default');
			}.bind(this)
		});
	},
	/*
		Method: attachResizable()
		Description: make window resizable
		Usage: internal

		Arguments:
			windowEl
	*/
	attachResizable: function(windowEl, subElements){
		if ( !windowEl.resizable ) { return; }

		var newResizable = subElements.contentWrapper.makeResizable({
			handle: subElements.resizeHandle,
			modifiers: {
				x: 'width',
				y: 'height'
			},
			limit: {
				x: [this.options.minWidth, this.options.maxWidth],
				y: [this.options.minHeight, this.options.maxHeight]
			},
			onStart: function() {
				if (windowEl.isMaximized) { 
					newResizable.stop();
					return;
				}
				this.cacheSubElements = this.getSubElements(windowEl, ['title', 'content', 'canvas', 'contentWrapper', 'overlay', 'titleBar', 'titleBarCenter', 'titleBarRight', 'titleBarLeft', 'controls', 'iframe', 'zIndexFix', 'footerBar', 'footerBarCenter', 'footerBarRight', 'footerBarLeft', 'shadow', 'shadowImage','dragOverlay']);
				if ( this.cacheSubElements.iframe && !this.options.showContentWhileResizing)  { 
					this.cacheSubElements.iframe.setStyle('display', 'none'); 
				}
				else {
					// allows use to show content while resizing and protects the cursor if it moves into the iframe
					this.cacheSubElements.dragOverlay.setStyle('display', 'block');
					this.cacheSubElements.dragOverlay.setStyle('cursor', 'se-resize');
				}
			}.bind(this),
			onDrag: function() {
				this.isAnimating = false; // false bc it affects the visual effect
				this.drawWindow(windowEl, this.cacheSubElements);
			}.bind(this),
			onComplete: function() {
				this.isAnimating = false;
				if ( this.cacheSubElements.iframe ) {
					this.cacheSubElements.iframe.setStyle('display', '');
				}
				// allows use to show content while resizing and protects the cursor if it moves into the iframe
				this.cacheSubElements.dragOverlay.setStyle('display', 'none');
				this.cacheSubElements.dragOverlay.setStyle('cursor', 'default');
				this.drawWindow(windowEl, this.cacheSubElements);
				delete this.cacheSubElements;
				this.cacheSubElements = null;
				windowEl.onResize();
			}.bind(this)
		});
	},
	setDesktopSize: function(){
		var windowDimensions = document.getCoordinates();

		if ( this.desktop ){
			this.desktop.setStyle('height', windowDimensions.height);
		}
		
		// Set pageWrapper height so the dock doesn't cover the pageWrapper scrollbars.

		if ( this.pageWrapper && this.desktopHeader) {
			var pageWrapperHeight = (windowDimensions.height - this.desktopHeader.offsetHeight - (this.dockVisible ? this.dock.offsetHeight : 0));	
			if ( pageWrapperHeight < 0 ) {
				pageWrapperHeight = 0;
			}
			this.pageWrapper.setStyle('height', pageWrapperHeight + 'px');
		}
	},
	setModalSize: function(){
		$('mochaModalOverlay').setStyle('height', document.getCoordinates().height);
	},
	/*
		Method: insertWindowElements
		Arguments:
			windowEl
		Returns:
			object containing all elements created within [windowEl]
	*/
	insertWindowElements: function(windowEl, height, width){
		var subElements = {};
		var contentWrapperHeight = parseInt(height) - windowEl.headerHeight - windowEl.footerHeight;
		var documentPath = String(window.location).substr(0,String(window.location).lastIndexOf("/"));

		if (Browser.Engine.trident4){
			subElements.zIndexFix = new Element('iframe', {
				'class': 'zIndexFix',
				'scrolling': 'no',
				'marginWidth': 0,
				'marginHeight': 0,
				'src': '',
				'id': windowEl.id + '_zIndexFix'
			}).injectInside(windowEl);
		}

		subElements.overlay = new Element('div', {
			'class': 'mochaOverlay',
			'id': windowEl.id + '_overlay'
		}).injectInside(windowEl);

		// we should be able to remove these shawdows?
		subElements.shadow = new Element('div', {
			'class': 'mochaShadow',
			'id': windowEl.id + '_shadow'
		}).injectInside(subElements.overlay);

		subElements.shadowImage = new Element('img', {
			'class': 'mochaShadowImage',
			'id': windowEl.id + '_shadowImage',
			'src': 'images/shadow.png'
		}).injectInside(subElements.shadow);

		// insert mochaTitlebar
		subElements.titleBar = new Element('div', {
			'class': 'mochaTitlebar',
			'id': windowEl.id + '_titleBar',
			'height': windowEl.headerHeight + 'px',
			'styles': {
				'cursor': (windowEl.draggable && this.options.showDragCursor) ? 'move' : 'default'
			}
		}).injectTop(subElements.overlay);

		// insert drag overlay (prevents drag issues in IE)
		subElements.dragOverlay = new Element('div', {
			'class': 'dragOverlay',
			'id': windowEl.id + '_dragOverlay',
			'styles': {
				'display' : 'none',
				'position' : 'absolute'
			}
		}).injectTop(subElements.overlay);

		// insert title bar left
		subElements.titleBarLeft = new Element('div', {
			'class': 'mochaTitleBarLeft',
			'id': windowEl.id + '_titleBarLeft'
		}).injectInside(subElements.titleBar);

		// insert title bar center
		subElements.titleBarCenter = new Element('div', {
			'class': 'mochaTitleBarCenter',
			'id': windowEl.id + '_titleBarCenter'
		}).injectInside(subElements.titleBar);

		// insert title bar right
		subElements.titleBarRight = new Element('div', {
			'class': 'mochaTitleBarRight',
			'id': windowEl.id + '_titleBarRight'
		}).injectInside(subElements.titleBar);

		// insert window header text
		subElements.title = new Element('h3', {
			'class': 'mochaTitle',
			'id': windowEl.id + '_title',
			'top': windowEl.headerTitleTop + 'px',
			'styles': {
				'cursor': (windowEl.draggable && this.options.showDragCursor) ? 'move' : 'default'
			}
		}).injectInside(subElements.titleBar);

		// insert content wrappers
		windowEl.contentBorder = new Element('div', {
			'class': 'mochaContentBorder',
			'id': windowEl.id + '_contentBorder'
		}).injectInside(subElements.overlay);	

		// UPDATE THIS! we should make the height of this MINUS the header and footer height
		subElements.contentWrapper = new Element('div', {
			'class': 'mochaContentWrapper',
			'id': windowEl.id + '_contentWrapper',
			'styles': {
				'width': width + 'px',
				'height': contentWrapperHeight + 'px'
			}
		}).injectInside(windowEl.contentBorder);

		subElements.content = new Element('div', {
			'class': 'mochaContent',
			'id': windowEl.id + '_content'
		}).injectInside(subElements.contentWrapper);

		// insert canvas
		subElements.canvas = new Element('canvas', {
			'class': 'mochaCanvas',
			'width': 1,
			'height': 1,
			'id': windowEl.id + '_canvas'
		}).injectInside(windowEl);

		// Dynamically initialize canvas using excanvas. This is only required by IE
		if ( Browser.Engine.trident && this.ieSupport == 'excanvas'  ) {
			G_vmlCanvasManager.initElement(subElements.canvas);
			// This is odd, .getContext() method does not exist before retrieving the
			// element via getElement
			subElements.canvas = windowEl.getElement('.mochaCanvas');
		}

		// insert skinnable footer bar
		subElements.footerBar = new Element('div', {
			'class': 'mochaFooterBar',
			'id': windowEl.id + '_footerBar'
		}).injectBottom(subElements.overlay);

		// insert footer bar left
		subElements.footerBarLeft = new Element('div', {
			'class': 'mochaFooterBarLeft',
			'id': windowEl.id + '_footerBarLeft'
		}).injectInside(subElements.footerBar);

		// insert footer bar center
		subElements.footerBarCenter = new Element('div', {
			'class': 'mochaFooterBarCenter',
			'id': windowEl.id + '_footerBarCenter'
		}).injectInside(subElements.footerBar);

		// insert footer bar right
		subElements.footerBarRight = new Element('div', {
			'class': 'mochaFooterBarRight',
			'id': windowEl.id + '_footerBarRight'
		}).injectInside(subElements.footerBar);

		// insert resize handles
		if (windowEl.resizable) {
			subElements.resizeHandle = new Element('div', {
				'class': 'resizeHandle',
				'id': windowEl.id + '_resizeHandle'
			}).injectInside(subElements.footerBar);

			if ( Browser.Engine.trident ) {
				subElements.resizeHandle.setStyle('zIndex', 2);
			}
		}

		// insert mochaTitlebar controls
		subElements.controls = new Element('div', {
			'class': 'mochaControls',
			'top': windowEl.headerControlsTop + 'px',
			'id': windowEl.id + '_controls'
		}).injectAfter(subElements.overlay);

		// insert close button
		if (windowEl.closable){
			subElements.closeButton = new Element('div', {
				'class': 'mochaClose',
				'title': 'Close Window',
				'style': 'background-image:url('+documentPath+windowEl.closeIconImage+')',
				'id': windowEl.id + '_closeButton'
			}).injectInside(subElements.controls);
			// mouseover
			subElements.closeButton.addEvent('mouseover', function() {
				subElements.closeButton.setStyle('background-image', 'url('+documentPath+windowEl.closeIconImageOver+')');
			});
			// mouseout
			subElements.closeButton.addEvent('mouseout', function() {
				subElements.closeButton.setStyle('background-image', 'url('+documentPath+windowEl.closeIconImage+')');
			});
		}

		// insert maximize button
		if (windowEl.maximizable){
			subElements.maximizeButton = new Element('div', {
				'class': 'maximizeToggle',
				'title': 'Maximize',
				'style': 'background-image:url('+documentPath+windowEl.maximizeIconImage+')',
				'id': windowEl.id + '_maximizeButton'
			}).injectInside(subElements.controls);
			subElements.maximizeButton.addEvent('mouseover', function() {
				subElements.maximizeButton.setStyle('background-image', 'url('+documentPath+windowEl.maximizeIconImageOver+')');
			});
			subElements.maximizeButton.addEvent('mouseout', function() {
				subElements.maximizeButton.setStyle('background-image', 'url('+documentPath+windowEl.maximizeIconImage+')');
			});
		}

		// insert minimize button
		if (windowEl.minimizable){
			subElements.minimizeButton = new Element('div', {
				'class': 'minimizeToggle',
				'title': 'Minimize',
				'style': 'background-image:url('+documentPath+windowEl.minimizeIconImage+')',
				'id': windowEl.id + '_minimizeButton'
			}).injectInside(subElements.controls);
			subElements.minimizeButton.addEvent('mouseover', function() {
				subElements.minimizeButton.setStyle('background-image', 'url('+documentPath+windowEl.minimizeIconImageOver+')');
			});
			subElements.minimizeButton.addEvent('mouseout', function() {
				subElements.minimizeButton.setStyle('background-image', 'url('+documentPath+windowEl.minimizeIconImage+')');
			});
		}

		// insert canvas
		subElements.canvasIcon = new Element('canvas', {
			'class': 'mochaLoadingIcon',
			'width': 18,
			'height': 18,
			'id': windowEl.id + '_canvasIcon'
		}).injectBottom(windowEl);	

		// Dynamically initialize canvas using excanvas. This is only required by IE
		if (Browser.Engine.trident && this.ieSupport == 'excanvas') {
			G_vmlCanvasManager.initElement(subElements.canvasIcon);
			// This is odd, .getContext() method does not exist before retrieving the
			// element via getElement
			subElements.canvasIcon = windowEl.getElement('.mochaLoadingIcon');
		}

		if ( Browser.Engine.trident ) {
			subElements.controls.setStyle('zIndex', 2)
			subElements.overlay.setStyle('zIndex', 2)
		}

		// For Mac Firefox 2 to help reduce scrollbar bugs in that browser
		if (Browser.Platform.mac && Browser.Engine.gecko)
			subElements.overlay.setStyle('overflow', 'auto');
		this.setMochaControlsWidth(windowEl, subElements);
		return subElements;
	},
	/*

	Method: drawWindow

	Arguments: 
		windowEl: the $(window)
		subElements: children of $(window)
		shadows: (boolean) false will draw a window without shadows
		
	Notes: This is where we create the canvas GUI	

	*/
	drawWindow: function(windowEl, subElements, shadows) {
		// uncomment to enable profiler
		// to use place profile[i++] = new Date().getTime(); before and after the test code. 
		// use firebug to put check the difference or add to the global profiler array this.options.profiler[this.options.profiler.length] = profile;
		//var i = 0;var profile = [];profile[i++] = new Date().getTime();

		// check if elements cache exists
		if ( !subElements ) {
			subElements = this.getSubElements(windowEl, ['title', 'content', 'canvas', 'contentWrapper', 'overlay', 'titleBar', 'titleBarCenter', 'titleBarRight', 'titleBarLeft', 'controls', 'iframe', 'zIndexFix', 'footerBar', 'footerBarCenter', 'footerBarRight', 'footerBarLeft', 'shadow', 'shadowImage',  'dragOverlay']);
		}

		windowEl.contentBorder.setStyles({
			'width': subElements.contentWrapper.offsetWidth
		});

		// Resize iframe when window is resized
		if ( windowEl.iframe ) {
			subElements.iframe.setStyles({
				'height': subElements.contentWrapper.offsetHeight
			});
		}

		var shadowOffset = this.shadowOffset;
		var headerHeight = windowEl.headerHeight;
		var footerHeight = windowEl.footerHeight;
		var nonContentHeight = headerHeight + footerHeight + shadowOffset;

		// total height
		var mochaHeight = subElements.contentWrapper.getStyle('height').toInt() + nonContentHeight;
		var mochaWidth = subElements.contentWrapper.getStyle('width').toInt() + shadowOffset;

		var footerLeftWidth = subElements.footerBarLeft.getStyle('width').toInt();
		var footerRightWidth = subElements.footerBarRight.getStyle('width').toInt();

		var titleLeftWidth = subElements.titleBarLeft.getStyle('width').toInt();
		var titleRightWidth = subElements.titleBarRight.getStyle('width').toInt();

		var mochaWidthAdjusted = mochaWidth - shadowOffset;

		subElements.overlay.setStyle('height', mochaHeight);
		windowEl.setStyle('height', mochaHeight);

		// If opera height and width must be set like this, when resizing:
		subElements.canvas.height = Browser.Engine.webkit ? 4000 : mochaHeight;
		subElements.canvas.width = Browser.Engine.webkit ? 2000 : mochaWidth;

		// Part of the fix for IE6 select z-index bug and FF on Mac scrollbar z-index bug
		if ( Browser.Engine.trident4 ){
			subElements.zIndexFix.setStyles({
				'width': mochaWidth,
				'height': mochaHeight
			})
		}

		// Set width
		windowEl.setStyle('width', mochaWidth);
		subElements.overlay.setStyle('width', mochaWidth);

		// Set draggable overlay area width and height
		subElements.dragOverlay.setStyle('width', mochaWidth);
		subElements.dragOverlay.setStyle('height', mochaHeight);

		// Set shadow width and height
		//subElements.shadowImage.setStyle('width', mochaWidth);
		//subElements.shadowImage.setStyle('height', mochaHeight);

		// set the title bar styles
		subElements.titleBar.setStyles({
			'width': mochaWidthAdjusted,
			'height': headerHeight
		});

		// set the title header - we should set height and padding here
		subElements.title.setStyles({
			'width': mochaWidth - shadowOffset,
			'top': windowEl.headerTitleTop + 'px'
		});

		subElements.titleBarLeft.setStyles({
			'left': "0px",
			'height': headerHeight
		});

		subElements.titleBarCenter.setStyles({
			'left': titleLeftWidth,
			'height': headerHeight,
			'width': mochaWidthAdjusted - titleLeftWidth - titleRightWidth
		});

		subElements.titleBarRight.setStyles({
			'height': headerHeight,
			'left': mochaWidthAdjusted - titleRightWidth
		});

		// set the header controls
		subElements.controls.setStyles({
			'top': windowEl.headerControlsTop + 'px'
		});

		// set the footer bar styles
		subElements.footerBar.setStyles({
			'width': mochaWidthAdjusted,
			'height': footerHeight
		});

		subElements.footerBarLeft.setStyles({
			'left': "0px",
			'height': footerHeight
		});

		subElements.footerBarCenter.setStyles({
			'height': footerHeight,
			'left': footerLeftWidth,
			'width': mochaWidthAdjusted - footerLeftWidth - footerRightWidth
		});

		subElements.footerBarRight.setStyles({
			'height': footerHeight,
			'left': mochaWidthAdjusted - footerRightWidth
		});

		// Draw shapes and shadows
		var ctx = subElements.canvas.getContext('2d');
		var dimensions = document.getCoordinates();
		ctx.clearRect(0, 0, dimensions.width, dimensions.height);

		if (!this.isAnimating == true) {

			// This is the drop shadow. It is created onion style with three layers
			// I really don't know if the roundedRect function is accurate
			// roundedRect: function(ctx, x, y, width, height, radius, rgb, alpha)
			if ( shadows != false ) {
				this.roundedRect(ctx, 0, 0, mochaWidth - 2, mochaHeight, this.options.cornerRadius, [0, 0, 0], 0.06); 
				this.roundedRect(ctx, 1, 1, mochaWidth - 4, mochaHeight - 2, this.options.cornerRadius, [0, 0, 0], 0.08);
				this.roundedRect(ctx, 2, 2, mochaWidth - 6, mochaHeight - 4, this.options.cornerRadius, [0, 0, 0], 0.3);
			}
		}

		//this.options.profiler[this.options.profiler.length] = profile;

		// this condition prevents drawing if we are using skinning
		if (this.options.useGraphicalSkinning != false) {
			return;
		}

		// Mocha body
		this.bodyRoundedRect(
			ctx,							 // context
			3,                               // x
			2,                               // y
			mochaWidth - this.shadowOffset,  // width
			mochaHeight - this.shadowOffset, // height
			this.options.cornerRadius,       // corner radius
			windowEl.footerBgColor           // Footer color
		);

		// Mocha header
		this.topRoundedRect(
			ctx,							 // context
			3,                               // x
			2,                               // y
			mochaWidth - this.shadowOffset,  // width
			this.options.headerHeight,       // height
			this.options.cornerRadius,       // corner radius
			windowEl.headerStartColor,       // Header gradient's top color
			windowEl.headerStopColor         // Header gradient's bottom color
		);

		// Calculate X position for controlbuttons
		this.closebuttonX = mochaWidth - (windowEl.closable ? 15 : -4);
		this.maximizebuttonX = this.closebuttonX - (windowEl.maximizable ? 19 : 0);
		this.minimizebuttonX = this.maximizebuttonX - (windowEl.minimizable ? 19 : 0);

		if ( windowEl.closable )
			this.closebutton(ctx, this.closebuttonX, 15, windowEl.closeColor, 1.0);
		if ( windowEl.maximizable )
			this.maximizebutton(ctx, this.maximizebuttonX, 15, windowEl.maximizeColor, 1.0);
		if ( windowEl.minimizable )
			this.minimizebutton(ctx, this.minimizebuttonX, 15, windowEl.minimizeColor, 1.0); // Minimize
		if ( windowEl.resizable ) 
			this.triangle(ctx, mochaWidth - 20, mochaHeight - 20, 12, 12, windowEl.resizableColor, 1.0); // Resize handle

		// Invisible dummy object. The last element drawn is not rendered consistently while resizing in IE6 and IE7.
		this.triangle(ctx, 0, 0, 10, 10, windowEl.resizableColor, 0); 

	},
	// Window body
	bodyRoundedRect: function(ctx, x, y, width, height, radius, rgb){
		ctx.fillStyle = 'rgba(' + rgb.join(',') + ', 100)';
		ctx.beginPath();
		ctx.moveTo(x, y + radius);
		ctx.lineTo(x, y + height - radius);
		ctx.quadraticCurveTo(x, y + height, x + radius, y + height);
		ctx.lineTo(x + width - radius, y + height);
		ctx.quadraticCurveTo(x + width, y + height, x + width, y + height - radius);
		ctx.lineTo(x + width, y + radius);
		ctx.quadraticCurveTo(x + width, y, x + width - radius, y);
		ctx.lineTo(x + radius, y);
		ctx.quadraticCurveTo(x, y, x, y + radius);
		ctx.fill(); 
	},
	roundedRect: function(ctx, x, y, width, height, radius, rgb, a){
		ctx.fillStyle = 'rgba(' + rgb.join(',') + ',' + a + ')';
		ctx.beginPath();
		ctx.moveTo(x, y + radius);
		ctx.lineTo(x, y + height - radius);
		ctx.quadraticCurveTo(x, y + height, x + radius, y + height);
		ctx.lineTo(x + width - radius, y + height);
		ctx.quadraticCurveTo(x + width, y + height, x + width, y + height - radius);
		ctx.lineTo(x + width, y + radius);
		ctx.quadraticCurveTo(x + width, y, x + width - radius, y);
		ctx.lineTo(x + radius, y);
		ctx.quadraticCurveTo(x, y, x, y + radius);
		ctx.fill(); 
	},
	// Window header with gradient background
	topRoundedRect: function(ctx, x, y, width, height, radius, headerStartColor, headerStopColor){

		// Create gradient
		if (Browser.Engine.presto != null ){
			var lingrad = ctx.createLinearGradient(0, 0, 0, this.options.headerHeight + 2);
		}
		else {
			var lingrad = ctx.createLinearGradient(0, 0, 0, this.options.headerHeight);
		}

		lingrad.addColorStop(0, 'rgba(' + headerStartColor.join(',') + ', 100)');
		lingrad.addColorStop(1, 'rgba(' + headerStopColor.join(',') + ', 100)');
		ctx.fillStyle = lingrad;

		// Draw header
		ctx.beginPath();
		ctx.moveTo(x, y);
		ctx.lineTo(x, y + height);
		ctx.lineTo(x + width, y + height);
		ctx.lineTo(x + width, y + radius);
		ctx.quadraticCurveTo(x + width, y, x + width - radius, y);
		ctx.lineTo(x + radius, y);
		ctx.quadraticCurveTo(x, y, x, y + radius);
		ctx.fill(); 
	},
	// Resize handle
	triangle: function(ctx, x, y, width, height, rgb, a){
		ctx.beginPath();
		ctx.moveTo(x + width, y);
		ctx.lineTo(x, y + height);
		ctx.lineTo(x + width, y + height);
		ctx.closePath();
		ctx.fillStyle = 'rgba(' + rgb.join(',') + ',' + a + ')';
		ctx.fill();
	},
	drawCircle: function(ctx, x, y, diameter, rgb, a){
		// Circle
		ctx.beginPath();
		ctx.moveTo(x, y);
		ctx.arc(x, y, diameter, 0, Math.PI*2, true);
		ctx.fillStyle = 'rgba(' + rgb.join(',') + ',' + a + ')';
		ctx.fill();
	},
	maximizebutton: function(ctx, x, y, rgb, a){ // This could reuse the drawCircle method above
		// Circle
		ctx.beginPath();
		ctx.moveTo(x, y);
		ctx.arc(x, y, 7, 0, Math.PI*2, true);
		ctx.fillStyle = 'rgba(' + rgb.join(',') + ',' + a + ')';
		ctx.fill();
		// X sign
		ctx.beginPath();
		ctx.moveTo(x, y - 4);
		ctx.lineTo(x, y + 4);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(x - 4, y);
		ctx.lineTo(x + 4, y);
		ctx.stroke();
	},
	closebutton: function(ctx, x, y, rgb, a){ // This could reuse the drawCircle method above
		// Circle
		ctx.beginPath();
		ctx.moveTo(x, y);
		ctx.arc(x, y, 7, 0, Math.PI*2, true);
		ctx.fillStyle = 'rgba(' + rgb.join(',') + ',' + a + ')';
		ctx.fill();
		// Plus sign
		ctx.beginPath();
		ctx.moveTo(x - 3, y - 3);
		ctx.lineTo(x + 3, y + 3);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(x + 3, y - 3);
		ctx.lineTo(x - 3, y + 3);
		ctx.stroke();
	},
	minimizebutton: function(ctx, x, y, rgb, a){ // This could reuse the drawCircle method above
		// Circle
		ctx.beginPath();
		ctx.moveTo(x,y);
		ctx.arc(x,y,7,0,Math.PI*2,true);
		ctx.fillStyle = 'rgba(' + rgb.join(',') + ',' + a + ')';
		ctx.fill();
		// Minus sign
		ctx.beginPath();
		ctx.moveTo(x - 4, y);
		ctx.lineTo(x + 4, y);
		ctx.stroke();
	},
	hideLoadingIcon: function(canvas) {
		$(canvas).setStyle('display', 'none');
		$clear(canvas.iconAnimation);
	},
	/*

	Method: showLoadingIcon	

	*/
	showLoadingIcon: function(canvas) {
		var iconWidth = $(canvas).getStyle('width').toInt();
		var iconHeight = $(canvas).getStyle('height').toInt();

		$(canvas).setStyles({
			'display': 'block'
		});
		var t = 1;
		var iconAnimation = function(canvas){ 
			var ctx = $(canvas).getContext('2d');
			ctx.clearRect(0, 0, iconWidth, iconHeight); // Clear canvas
			ctx.save();
			ctx.translate(9, 9);
			ctx.rotate(t*(Math.PI / 8));
			var color = 0;
			for (i=0; i < 8; i++){ // Draw individual dots
				color = Math.floor(255 / 8 * i);
				ctx.fillStyle = "rgb(" + color + "," + color + "," + color + ")";  	
				ctx.rotate(-Math.PI / 4);
				ctx.beginPath();
				ctx.arc(0, 7, 2, 0, Math.PI*2, true);
				ctx.fill();
			}
			ctx.restore();
			t++;
		}.bind(this);
		canvas.iconAnimation = iconAnimation.periodical(125, this, canvas);
	},
	setMochaControlsWidth: function(windowEl, subElements){
		// for images skinning update the control width and the margin width to your needs
		var controlWidth = 17;
		var marginWidth = 5;
		this.mochaControlsWidth = 0;
		if ( windowEl.minimizable )
			this.mochaControlsWidth += (marginWidth + controlWidth);
		if ( windowEl.maximizable ) {
			this.mochaControlsWidth += (marginWidth + controlWidth);
			subElements.maximizeButton.setStyle('margin-left', marginWidth);
		}
		if ( windowEl.closable ) {
			this.mochaControlsWidth += (marginWidth + controlWidth);
			subElements.closeButton.setStyle('margin-left', marginWidth);
		}
		subElements.controls.setStyle('width', this.mochaControlsWidth);
	},
	toggleDock: function(){
		if ( !this.dockVisible ) {
			this.dock.setStyle('display', 'block');
			this.dockVisible = true;
			this.setDesktopSize();
		}
		else {
			this.dock.setStyle('display', 'none');
			this.dockVisible = false;
			this.setDesktopSize();
		}
	},
	setDockVisibility: function(value){
		if ( value ) {
			this.dock.setStyle('display', 'block');
			this.dockVisible = true;
			this.setDesktopSize();
		}
		else {
			this.dock.setStyle('display', 'none');
			this.dockVisible = false;
			this.setDesktopSize();
		}
	},
	initializeDock: function (){
		this.dock.setStyles({
			'display':  'block',
			'position': 'absolute',
			'top':      null,
			'bottom':   0,
			'left':     0
		});

		this.dock.setStyle('display', 'none');
		this.dockVisible = false;
		this.setDesktopSize();

		// Probably: this event should be added/removed when toggling AutoHide, since we dont need it when AutoHide is turned off
		// this.dockVisible tracks the status of the dock, so that showing/hiding is not done when not needed

		document.addEvent('mousemove', function(event) {
			if ( !this.dockAutoHide )
				return;
			var ev = new Event(event);
			if ( ev.client.y > (document.getCoordinates().height - 25) ) {
				if ( !this.dockVisible ) {
					this.dock.setStyle('display', 'block');
					this.dockVisible = true;
					this.setDesktopSize();
				}
			} else {
				if ( this.dockVisible ) {
					this.dock.setStyle('display', 'none');
					this.dockVisible = false;
					this.setDesktopSize();
				}
			}
		}.bind(this));

		// insert canvas
		var canvas = new Element('canvas', {
			'class':  'mochaCanvas',
			'id':     'dockCanvas',
			'width':  '15',
			'height': '18'
		}).injectInside(this.dock).setStyles({
			position: 'absolute',
			top:      '4px',
			left:     '2px',
			zIndex:   2
		});

		// Dynamically initialize canvas using excanvas. This is only required by IE
		if (Browser.Engine.trident && this.ieSupport == 'excanvas') {
			G_vmlCanvasManager.initElement(canvas);
		}

		// Position top or bottom selector
		$('mochaDockPlacement').setProperty('title','Position Dock Top');

		// Auto Hide toggle switch
		$('mochaDockAutoHide').setProperty('title','Turn Auto Hide On');

		// Attach event
		$('mochaDockPlacement').addEvent('click', function(event){
			var ctx = this.dock.getElement('.mochaCanvas').getContext('2d');

			// Move dock to top position
			if (this.dock.getStyle('position') != 'relative'){
				this.dock.setStyles({
					'position':      'relative',
					'bottom':         null,
					'border-top':    '1px solid #fff',
					'border-bottom': '1px solid #bbb'
				})
				this.setDesktopSize();
				this.dock.setProperty('dockPosition','Top');
				this.drawCircle(ctx, 5, 4, 3, [0, 255, 0], 1.0); // green
				this.drawCircle(ctx, 5, 14, 3, [212, 208, 200], 1.0); // gray
				$('mochaDockPlacement').setProperty('title', 'Position Dock Bottom');
				$('mochaDockAutoHide').setProperty('title', 'Auto Hide Disabled in Top Dock Position');
				this.dockAutoHide = false;
			}
			// Move dock to bottom position
			else {
				this.dock.setStyles({
					'position':      'absolute',
					'bottom':        0,
					'border-top':    '1px solid #bbb',
					'border-bottom': '1px solid #fff'
				})
				this.setDesktopSize();
				this.dock.setProperty('dockPosition','Bottom');
				this.drawCircle(ctx, 5, 4, 3, [241, 102, 116], 1.0); // orange
				this.drawCircle(ctx, 5 , 14, 3, [241, 102, 116], 1.0); // orange 
				$('mochaDockPlacement').setProperty('title', 'Position Dock Top');
				$('mochaDockAutoHide').setProperty('title', 'Turn Auto Hide On');
			}
		}.bind(this));

		// Attach event Auto Hide 
		$('mochaDockAutoHide').addEvent('click', function(event){
			if ( this.dock.getProperty('dockPosition') == 'Top' )
				return false;

			var ctx = this.dock.getElement('.mochaCanvas').getContext('2d');
			this.dockAutoHide = !this.dockAutoHide;	// Toggle
			if ( this.dockAutoHide ) {
				$('mochaDockAutoHide').setProperty('title', 'Turn Auto Hide Off');
				this.drawCircle(ctx, 5 , 14, 3, [0, 255, 0], 1.0); // green
			} else {
				$('mochaDockAutoHide').setProperty('title', 'Turn Auto Hide On');
				this.drawCircle(ctx, 5 , 14, 3, [241, 102, 116], 1.0); // orange
			}
		}.bind(this));
		
		this.drawDock(this.dock);
	},
	drawDock: function (el){
		var ctx = el.getElement('.mochaCanvas').getContext('2d');
		this.drawCircle(ctx, 5 , 4, 3, [241, 102, 116], 1.0);  // orange
		this.drawCircle(ctx, 5 , 14, 3, [241, 102, 116], 1.0); // orange
	},
	dynamicResize: function (windowEl){
			this.getSubElement(windowEl, 'contentWrapper').setStyle('height', this.getSubElement(windowEl, 'content').offsetHeight);
			this.drawWindow(windowEl);
	},
	/*

	Method: arrangeCascade

	*/
	arrangeCascade: function(){
		var x = this.options.desktopLeftOffset
		var y = this.options.desktopTopOffset;
		$$('div.mocha').each(function(windowEl){
			if (!windowEl.isMinimized && !windowEl.isMaximized){
				this.focusWindow(windowEl);
				x += this.options.mochaLeftOffset;
				y += this.options.mochaTopOffset;
				
				if (this.options.effects == false){	
					windowEl.setStyles({
						'top': y,
						'left': x
					});
				}
				else {
					var cascadeMorph = new Fx.Morph(windowEl, {
						'duration': 550
					});
					cascadeMorph.start({
						'top': y,
						'left': x
					});
				}
			}
		}.bind(this));
	},
	/*

	Method: garbageCleanup

	Notes: Empties an all windows of their children, removes and garbages the windows.
	It is does not trigger onClose() or onCloseComplete().
	This is useful to clear memory before the pageUnload. 

	*/
	garbageCleanUp: function() {
		$$('div.mocha').each(function(el) {
			el.destroy();
		}.bind(this));
	}
});
MochaUI.implement(new Options);

/* -----------------------------------------------------------------

	MOCHA SCREENS
	Notes: This class can be removed if you are not creating multiple screens/workspaces.

   ----------------------------------------------------------------- */

var MochaScreens = new Class({
	options: {
		defaultScreen: 0 // Default screen
	},
	initialize: function(options){
		this.setOptions(options);
		this.setScreen(this.options.defaultScreen);
	},
	setScreen: function(index) {
		if ( !$('mochaScreens') )
			return;
		$$('#mochaScreens div.screen').each(function(el,i) {
			el.setStyle('display', i == index ? 'block' : 'none');
		});
	}
});
MochaScreens.implement(new Options);

/* -----------------------------------------------------------------

	MOCHA WINDOW FROM FORM
	Notes: This class can be removed if you are not creating new windows dynamically from a form.

   ----------------------------------------------------------------- */

var MochaWindowForm = new Class({
	options: {
		id: null,
		title: 'New Window',
		loadMethod: 'html', // html, xhr, or iframe
		content: '', // used if loadMethod is set to 'html'
		contentURL: 'pages/lipsum.html', // used if loadMethod is set to 'xhr' or 'iframe'
		modal: false,
		width: 300,
		height: 125,
		scrollbars: true, // true sets the overflow to auto and false sets it to hidden
		x: null, // if x or y is null or modal is false the new window is centered in the browser window
		y: null,
		paddingVertical: 10,
		paddingHorizontal: 12
	},
	initialize: function(options){
		this.setOptions(options);
		this.options.id = 'win' + (++document.mochaUI.windowIDCount);
		this.options.title = $('mochaNewWindowHeaderTitle').value;
		if ($('htmlLoadMethod').checked){
			this.options.loadMethod = 'html';
		}
		if ($('xhrLoadMethod').checked){
			this.options.loadMethod = 'xhr';
		}
		if ($('iframeLoadMethod').checked){
			this.options.loadMethod = 'iframe';
		}
		this.options.content = $('mochaNewWindowContent').value;
		if ($('mochaNewWindowContentURL').value){
			this.options.contentURL = $('mochaNewWindowContentURL').value;
		}
		if ($('mochaNewWindowModal').checked) {
			this.options.modal = true;
		}
		this.options.width = $('mochaNewWindowWidth').value.toInt();
		this.options.height = $('mochaNewWindowHeight').value.toInt();
		this.options.x = $('mochaNewWindowX').value.toInt();
		this.options.y = $('mochaNewWindowY').value.toInt();
		this.options.paddingVertical = $('mochaNewWindowPaddingVertical').value.toInt();
		this.options.paddingHorizontal = $('mochaNewWindowPaddingHorizontal').value.toInt();
		document.mochaUI.newWindow(this.options);
	}
});
MochaWindowForm.implement(new Options);


/* -----------------------------------------------------------------

	Corner Radius Slider
	Notes: Remove this function and it's reference in onload if you are not
	using the example corner radius slider

   ----------------------------------------------------------------- */

function addSlider(){
	if ($('sliderarea')) {
		mochaSlide = new Slider($('sliderarea'), $('sliderknob'), {
			steps: 20,
			offset: 5,
			onChange: function(pos){
				$('updatevalue').setHTML(pos);
				document.mochaUI.options.cornerRadius = pos;
				$$('div.mocha').each(function(windowEl, i) {
					document.mochaUI.drawWindow(windowEl);
				});
				document.mochaUI.indexLevel++;
			}
		}).set(document.mochaUI.options.cornerRadius);
	}
}

/* -----------------------------------------------------------------

	Initialize Everything onLoad

   ----------------------------------------------------------------- */

window.addEvent('domready', function(){
		document.mochaScreens = new MochaScreens();
		document.mochaUI = new MochaUI();
		attachMochaLinkEvents(); // See mocha-events.js
		addSlider();             // remove this if you remove the example corner radius slider
});

// This runs when a person leaves your page.
window.addEvent('unload', function(){
		if (document.mochaUI) document.mochaUI.garbageCleanUp();
});
