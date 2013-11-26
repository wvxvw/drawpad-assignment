package tld.wvxvw.drawpad.bus {

    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import tld.wvxvw.drawpad.tools.Keymap;
    
    public class Server implements IServer {

        private var dispatcher:EventDispatcher;
        private var keymap:Keymap = new Keymap();
        private const clients:Vector.<IClient> = new <IClient>[];
        
        public function Server(dispatcher:EventDispatcher) {
            super();
            this.init(dispatcher);
        }

        private function init(dispatcher:EventDispatcher):void {
            this.dispatcher = dispatcher;
            this.dispatcher.addEventListener(
                KeyboardEvent.KEY_UP, this.keyUpHandler);
            this.dispatcher.addEventListener(
                KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            this.dispatcher.addEventListener(
                MouseEvent.MOUSE_DOWN, this.mousDownHandler);
            this.dispatcher.addEventListener(
                MouseEvent.MOUSE_UP, this.mousUpHandler);
        }

        public function addClient(client:IClient):void {

        }

        public function request(client:IClient,
            request:String, ...data:Array):void {

        }

        private function keyUpHandler(event:KeyboardEvent):void {

        }

        private function keyDownHandler(event:KeyboardEvent):void {

        }

        private function mousUpHandler(event:MouseEvent):void {

        }

        private function mousDownHandler(event:MouseEvent):void {

        }
    }
}