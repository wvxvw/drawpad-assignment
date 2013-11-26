package tld.wvxvw.drawpad {
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import tld.wvxvw.debugging.Console;
    import tld.wvxvw.drawpad.bus.History;
    import tld.wvxvw.drawpad.bus.Server;
    import tld.wvxvw.drawpad.stage.Canvas;
    
    public class Application extends Sprite {

        private var canvas:Canvas;
        private var history:History = new History();
        private var server:Server;
        
        public function Application() {
            super();
            if (super.stage) this.init();
            else super.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        private function init(event:Event = null):void {
            Console.log("it works!");
            super.stage.scaleMode = StageScaleMode.NO_SCALE;
            super.stage.align = StageAlign.TOP_LEFT;
            this.canvas = new Canvas(this.history, this);
            this.server = new Server(super.stage);
            this.server.addClient(this.canvas);
        }
    }
}