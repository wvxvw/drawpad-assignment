package tld.wvxvw.drawpad.bus {

    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import tld.wvxvw.drawpad.tools.Keymap;
    import tld.wvxvw.debugging.Console;
    
    public class Server implements IServer {

        protected var keymap:Keymap = new Keymap();
        
        private var dispatcher:EventDispatcher;
        private const clients:Vector.<IClient> = new <IClient>[];
        private const commands:Vector.<String> =
            new <String>["add", "disconnect"];
        
        public function Server(dispatcher:EventDispatcher) {
            super();
            this.init(dispatcher);
        }

        private function init(dispatcher:EventDispatcher):void {
            this.dispatcher = dispatcher;
            this.dispatcher.addEventListener(
                KeyboardEvent.KEY_UP, this.keyHandler);
            this.dispatcher.addEventListener(
                KeyboardEvent.KEY_DOWN, this.keyHandler);
            this.dispatcher.addEventListener(
                MouseEvent.MOUSE_DOWN, this.mousDownHandler);
            this.dispatcher.addEventListener(
                MouseEvent.MOUSE_UP, this.mousUpHandler);
        }

        public function add(client:IClient):void {
            var index:int = this.clients.indexOf(client);
            if (index < 0) this.clients.push(client);
        }

        public function disconnect(client:IClient):void {
            var index:int = this.clients.indexOf(client);
            if (index > -1) this.clients.splice(index, 1);
        }

        public function request(client:IClient,
            request:String, ...data:Array):void {
            var index:int = this.commands.indexOf(request);
            if (index > -1) {
                if (data && data.length)
                    (this[request] as Function).apply(this, data);
                else this[request]();
            } else this.onRequest(client, request, data);
        }

        protected function onRequest(client:IClient,
            request:String, data:Array):void {
            Console.debug("Unknown command", request);
        }
        
        private function keyHandler(event:KeyboardEvent):void {
            this.keymap.dispatch(event);
        }

        private function mousUpHandler(event:MouseEvent):void {

        }

        private function mousDownHandler(event:MouseEvent):void {

        }
        
        public function loadConfig(keys:Object):void {
            Console.debug("Loading config", keys, keys.prefix);
            for each (var key:String in keys.prefix)
                this.keymap.definePrefixKey(key);
            Console.debug("Prefix keys defined");
            for (key in keys.bindings)
                this.keymap.defineKey(key, this[keys.bindings[key]]);
            Console.debug("Config loaded");
        }
    }
}