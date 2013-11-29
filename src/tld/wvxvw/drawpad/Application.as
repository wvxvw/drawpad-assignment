package tld.wvxvw.drawpad {
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import tld.wvxvw.debugging.Console;
    import tld.wvxvw.drawpad.bus.History;
    import tld.wvxvw.drawpad.bus.EventServer;
    import tld.wvxvw.drawpad.config.Init;
    import tld.wvxvw.drawpad.stage.Canvas;
    import tld.wvxvw.postscript.PS;
    import tld.wvxvw.postscript.Interpreter;
    
    public class Application extends Sprite {

        private var canvas:Canvas;
        private var server:EventServer;
        private const config:Init = new Init();
        private const history:History = new History();
        private const ps:PS = new PS();
        
        public function Application() {
            super();
            if (super.stage) this.init();
            else super.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        private function init(event:Event = null):void {
            Console.debug("Initiating application");
            super.stage.scaleMode = StageScaleMode.NO_SCALE;
            super.stage.align = StageAlign.TOP_LEFT;
            this.canvas = new Canvas(this.history, this);
            Console.debug("Starting EventServer");
            this.server = new EventServer(super.stage);
            Console.debug("EventServer started");
            this.server.loadConfig(this.config)
            this.server.add(this.canvas);
            Console.debug("Application initiated");
            this.load();
        }

        private function load():void {
            for each (var service:String in this.server.listServices())
                this.ps.load(this.server.callRpcService(this.canvas, service))
                    .addEventListener(Event.COMPLETE, this.completeHandler);
        }

        private function completeHandler(event:Event):void {
            var interpreter:Interpreter = event.currentTarget as Interpreter;
            this.server.place(interpreter.shape);
            Console.debug("Shape loaded", String(event.currentTarget));
        }
    }
}