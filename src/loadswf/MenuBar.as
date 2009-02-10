package selfdesizenUI
{
	import fl.controls.Label;
	import fl.controls.TileList;
	import fl.controls.List;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import fl.controls.listClasses.CellRenderer;
	public class MenuBar extends Sprite
	{
		protected var keepMenuOpen:Boolean = false;
		private var _myMenuBar:TileList;
		private var _menu1:List;
		private var _menu2:List;
		private var _menu3:List;
		private var _menu4:List;
		private var _selectedMenu_txt:Label;
		public function MenuBar()
		{
			super();
			_myMenuBar = this.getChildByName("myMenuBar") as TileList;
			_menu1 = this.getChildByName("menu1") as List;
			_menu2 = this.getChildByName("menu2") as List;
			_menu3 = this.getChildByName("menu3") as List;
			_menu4 = this.getChildByName("menu4") as List;
			_selectedMenu_txt = this.getChildByName("selectedMenu_txt") as Label;
			hideAllMenusExcept(null);
			_myMenuBar.selectable=false;
			_menu1.selectable = false;
			_menu2.selectable = false;
			_menu3.selectable = false;
			_menu4.selectable = false;
			
			_myMenuBar.setStyle("cellRenderer", CellRenderer);
			var keepMenuOpen:Boolean = false;
			_myMenuBar.addEventListener(MouseEvent.MOUSE_DOWN, menuBarMouseHandler);
			
		}
		import fl.controls.listClasses.ICellRenderer; 
/*
 * Handler for mouse events for TileList menu bar.
 */
function menuBarMouseHandler(e:MouseEvent):void {
    // the target of the mouse event will often be the ICellRenderer
    // for the cell being clicked or moused over.  By using the as
    // keyword, we ensure that we have an instance of a class which
    // implements the ICellRenderer interface, and if target is not
    // an instance of such a class, we get null.  It turns out in
    // some cases the target can be the TileList itself, and in this
    // case the event is not interesting to us so we check for null
    // and return immediately in that case.
    var cellRenderer:ICellRenderer = e.target as ICellRenderer;
    if (cellRenderer == null) return;
 
    // rather than have a handler for each MouseEvent we handle,
    // it simplifies the code to have one handler and switch on the
    // event type.
    switch (e.type) {
    case MouseEvent.MOUSE_DOWN:
        // the List drop down menus have instance names
        // which match the label for the corresponding item
        // in the TileList menu bar, so we can get the correct
        // List instance by referencing the label we get from
        // the ICellRenderer instance's data property.
        openMenuBar(this[cellRenderer.data.label]);
        // see MOUSE_UP handling below for discussion of keepMenuOpen
        keepMenuOpen = true;
        break;
    case MouseEvent.MOUSE_OVER:
        hideAllMenusExcept(this[cellRenderer.data.label]);
        break;
    case MouseEvent.MOUSE_UP:
        // this event will only be hit on the first mouseUp after the
        // first mouseDown which opened the menus.  We need to handle
        // this to prevent the Stage mouseUp listener from closing the
        // menus.  We could stop the stage listener from getting the
        // event at all by calling e.stopPropagation(), but since this
        // will eventually become component code that could be used in
        // an arbitrary application, it seems dangerous to stop event
        // propagation since we do not know what sort of event handling
        // the user might be coding on top of ours.  So instead we use
        // the keepMenuOpen:Boolean.
        _myMenuBar.removeEventListener(MouseEvent.MOUSE_UP, menuBarMouseHandler);
        keepMenuOpen = true;
        break;
    }
}
 
/*
 * Handler for mouse events for List drop down menus.
 */
function menuMouseHandler(e:MouseEvent):void {
    // see comment in menuBarMouseHandler for explanation of
    // next two lines of code
    var cellRenderer:ICellRenderer = e.target as ICellRenderer;
    if (cellRenderer == null) return;
 
    switch (e.type) {
    case MouseEvent.MOUSE_UP:
        // we aren't doing any real event dispatching yet, just tracing
        trace(cellRenderer.data.label);
        // also set the contents of a TextField on stage, just for the
        // prototype, we will remove this when we move to component
        _selectedMenu_txt.text = cellRenderer.data.label;
        closeMenuBar();
        break;
    case MouseEvent.MOUSE_DOWN:
        // keep stage listener from closing the menus
        // more on use of keepMenuOpen in comment
        // for mouseUp event in menuBarMouseHandler()
        keepMenuOpen = true;
        break;
    }
}
	 
	/*
	 * handler for Stage mouse events.  mouseUp or mouseDown
	 * on the Stage closes the menus, unless the event hit
	 * the TileList menu bar or a List drop-down menu first.
	 */
	function stageMouseHandler(e:MouseEvent):void {
	    if (keepMenuOpen) {
	        // keepMenuOpen is used by the TileList menu bar mouseUp event
	        // to signal that the next stage mouseUp event should not close
	        // the menus.  We set it to false, so that the subsequent stage
	        // mouseUp event WILL close the menus, and do nothing else.
	        keepMenuOpen = false;
	    } else {
	        closeMenuBar();
	    }
	}
	 
	/*
	 * Shows the drop down menu passed in as a parameter and adds
	 * all the events used to track the open menus and decide when
	 * to close them.  Only the mouseDown event listener on the
	 * TileList menu bar is active until the menus are active.
	 */
	function openMenuBar(menuToOpen:List):void {
	    // open the List drop down menu
	    hideAllMenusExcept(menuToOpen);
	 
	    // we need to handle mouseOver once a menu is opened to switch
	    // which menu is dropped down
	    _myMenuBar.addEventListener(MouseEvent.MOUSE_OVER, menuBarMouseHandler);
	 
	    // we want to handle the first mouseUp event after the first
	    // mouseDown on the TileList menu bar to prevent the Stage
	    // mouseUp listener from closing the menus
	    _myMenuBar.addEventListener(MouseEvent.MOUSE_UP, menuBarMouseHandler);
	 
	    // if we get a mouseDown anywhere on the Stage aside
	    // from the TileList menu bar or the List drop-down menus
	    // we will close the menus
	    stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseHandler);
	 
	    // if the first mouseUp after the initial mouseDown to
	    // open the menu is not over the TileList menu bar or
	    // the List drop-down menus, we should close the menus
	    stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseHandler);
	 
	    // When we get a mouseUp on a List drop down menu, this means
	    // the user has made a selection which we must handle
	    _menu1.addEventListener(MouseEvent.MOUSE_UP, menuMouseHandler);
	    _menu2.addEventListener(MouseEvent.MOUSE_UP, menuMouseHandler);
	    _menu3.addEventListener(MouseEvent.MOUSE_UP, menuMouseHandler);
	    _menu4.addEventListener(MouseEvent.MOUSE_UP, menuMouseHandler);
	 
	    // we just need to handle mouseDown on the List drop down
	    // menus to prevent the stage listener from closing the menus
	    _menu1.addEventListener(MouseEvent.MOUSE_DOWN, menuMouseHandler);
	    _menu2.addEventListener(MouseEvent.MOUSE_DOWN, menuMouseHandler);
	    _menu3.addEventListener(MouseEvent.MOUSE_DOWN, menuMouseHandler);
	    _menu4.addEventListener(MouseEvent.MOUSE_DOWN, menuMouseHandler);
	}
	 
	/*
	 * hide all List drop-down menus and remove all of the event
	 * listeners added in openMenuBar()
	 */
	function closeMenuBar():void {
	    // close all menus
	    hideAllMenusExcept(null);
	    // reset the state of keepMenuOpen, just for good housekeeping
	    keepMenuOpen = false;
	    // remove all the event listeners we added in openMenuBar()
	    _myMenuBar.removeEventListener(MouseEvent.MOUSE_UP, menuBarMouseHandler);
	    _myMenuBar.removeEventListener(MouseEvent.MOUSE_OVER, menuBarMouseHandler);
	    stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseHandler);
	    stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseHandler);
	    _menu1.removeEventListener(MouseEvent.MOUSE_UP, menuMouseHandler);
	    _menu2.removeEventListener(MouseEvent.MOUSE_UP, menuMouseHandler);
	    _menu3.removeEventListener(MouseEvent.MOUSE_UP, menuMouseHandler);
	    _menu4.removeEventListener(MouseEvent.MOUSE_UP, menuMouseHandler);
	    _menu1.removeEventListener(MouseEvent.MOUSE_DOWN, menuMouseHandler);
	    _menu2.removeEventListener(MouseEvent.MOUSE_DOWN, menuMouseHandler);
	    _menu3.removeEventListener(MouseEvent.MOUSE_DOWN, menuMouseHandler);
	    _menu4.removeEventListener(MouseEvent.MOUSE_DOWN, menuMouseHandler);
	}
	 
	// need to import List to use it as a parameter in hideAllMenusExcept()
	import fl.controls.List;
	 
	/*
	 * takes a parameter indicating which List drop down menu
	 * should be open.  All the other menus will be made
	 * invisible.  Pass in null to hide all of the drop down menus.
	 */
	function hideAllMenusExcept(except:List):void {
	    _menu1.visible = (except == _menu1);
	    _menu2.visible = (except == _menu2);
	    _menu3.visible = (except == _menu3);
	    _menu4.visible = (except == _menu4);
	}
		
	}
}