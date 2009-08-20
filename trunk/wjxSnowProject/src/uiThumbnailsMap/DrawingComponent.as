package uiThumbnailsMap {
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.events.MouseEvent;
    import mx.core.UIComponent;
    import flash.events.Event;

    public class DrawingComponent extends UIComponent {

        private var _colorPallet:Array = [0xFFFFFF, 0xFF0000, 0xFF00, 0xFF, 0];
        private var _colorListeners:Array = [onWhite, onRed, onGreen, onBlue, onBlack];
        private var _currentColor:uint = 0;
        private var _paper:UIComponent;
        
        public function DrawingComponent() {
        	this.addEventListener( "creationComplete", init );
        }
        public function init( event : Event ):void {
            createPaper();
            createPallet();
        }
        private function createPaper():void {
            var _paper:UIComponent = new UIComponent();
            _paper.percentWidth = 100;
            _paper.percentHeight = 100;
            _paper.visible = true;
            _paper.graphics.beginFill(0xDDDDDD, 1);
            _paper.graphics.drawRect(0, 0, this.width, this.height );
            _paper.addEventListener(MouseEvent.MOUSE_DOWN, onBeginDraw);
            _paper.addEventListener(MouseEvent.MOUSE_UP, onEndDraw);
            addChild(_paper);
        }
        private function createPallet():void {
            for(var i:int = 0; i < _colorPallet.length; i++) {
                var s:Sprite = new Sprite();
                s.graphics.beginFill(_colorPallet[i], 1);
                s.graphics.drawCircle(20, 25 * i + 10, 10);
                s.buttonMode = true;
                s.useHandCursor = true;
                s.addEventListener(MouseEvent.CLICK, _colorListeners[i]);
                addChild(s);
            }
        }
        private function onBeginDraw(e:MouseEvent):void {
            e.target.graphics.endFill();
            e.target.graphics.moveTo(mouseX, mouseY);
            e.target.graphics.lineStyle(5, _currentColor, 1);
            e.target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        private function onEndDraw(e:MouseEvent):void {
            e.target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        private function onMouseMove(e:MouseEvent):void {
            e.target.graphics.lineTo(mouseX, mouseY);
        }
        private function onWhite(e:MouseEvent):void {
            _currentColor = 0xFFFFFF;
        }
        private function onRed(e:MouseEvent):void {
            _currentColor = 0xFF0000;
        }
        private function onGreen(e:MouseEvent):void {
            _currentColor = 0xFF00;
        }
        private function onBlue(e:MouseEvent):void {
            _currentColor = 0xFF;
        }
        private function onBlack(e:MouseEvent):void {
            _currentColor = 0;
        }
    }
}
