package tld.wvxvw.drawpad.bus {

    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.utils.Dictionary;
    import tld.wvxvw.drawpad.tools.Keymap;
    import tld.wvxvw.drawpad.config.Init;
    import tld.wvxvw.debugging.Console;
    import tld.wvxvw.postscript.IAsyncInputStream;
    import tld.wvxvw.postscript.UrlAsyncStream;
    
    public class Server implements IServer {

        protected var keymap:Keymap = new Keymap();
        protected const clients:Vector.<IClient> = new <IClient>[];
        
        private var dispatcher:EventDispatcher;
        private const commands:Vector.<String> =
            new <String>["add", "disconnect", "echo", "fail"];

        private var rpcDestination:String;
        private var rpcMethod:String;
        private var rpcServices:Object;
        private var rpcClients:Dictionary = new Dictionary();
        
        public function Server(dispatcher:EventDispatcher) {
            super();
            this.init(dispatcher);
        }

        private function init(dispatcher:EventDispatcher):void {
            this.dispatcher = dispatcher;
            this.dispatcher.addEventListener(
                KeyboardEvent.KEY_UP, this.keymap.dispatch);
            this.dispatcher.addEventListener(
                KeyboardEvent.KEY_DOWN, this.keymap.dispatch);
            this.dispatcher.addEventListener(
                MouseEvent.MOUSE_DOWN, this.keymap.dispatch);
            this.dispatcher.addEventListener(
                MouseEvent.MOUSE_UP, this.keymap.dispatch);
        }

        private function initRPC(serverConfig:Object):void {
            this.rpcDestination = serverConfig.location;
            this.rpcMethod = serverConfig.method;
            this.rpcServices = serverConfig.services;
        }

        public function add(client:IClient):void {
            var index:int = this.clients.indexOf(client);
            if (index < 0) {
                client.server = this;
                this.clients.push(client);
            }
            Console.debug("total clients:", this.clients.length);
        }

        public function echo(command:String, ...args:Array):void {
            for each (var client:IClient in this.clients) {
                client.handle(command, args);
            }
        }

        public function fail(client:IClient, command:String, ...args:Array):void {
            Console.error("Client:", String(client), "failed command:", command);
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

        public function listServices():Vector.<String> {
            var result:Vector.<String> = new <String>[];
            for (var service:String in this.rpcServices) result.push(service);
            return result;
        }

        public function serviceArguments(name:String,
            mandatoryOnly:Boolean = false):Array {
            var result:Array = this.rpcServices[name].mandatory;
            if (!mandatoryOnly)
                result = result.concat(this.rpcServices[name].optional);
            return result;
        }

        public function callRpcService(client:IClient, name:String,
            ...args:Array):IAsyncInputStream {
            var request:URLRequest =
                new URLRequest(this.rpcDestination + "/" + name);
            request.method = this.rpcMethod.toUpperCase();
            Console.log("Request created:", request.url, request.method);
            if (args && args.length) {
                var variables:URLVariables = new URLVariables();
                // This is done so because keys are allowed to repeat
                for each (var pair:Object in args)
                    variables[pair.key] = pair.value;
                request.data = variables;
            } else {
                // assholes
                request.data = 1;
            }
            var stream:UrlAsyncStream = new UrlAsyncStream(request);
            stream.addEventListener(Event.COMPLETE, this.completeHandler);
            this.rpcClients[stream] = client;
            return stream;
        }

        private function completeHandler(event:Event):void {
            this.onRequest(null, event.type,
                this.rpcClients[event.currentTarget]);
            delete this.rpcClients[event.currentTarget];
        }
        
        public function loadConfig(config:Init):void {
            var keys:Object = config.keybindings();
            
            Console.debug("Loading config", keys, keys.prefix);
            for each (var key:String in keys.prefix)
                this.keymap.definePrefixKey(key);
            Console.debug("Prefix keys defined");
            for (key in keys.bindings)
                this.keymap.defineKey(key, this[keys.bindings[key]]);
            this.initRPC(config.server());
            Console.debug("Config loaded");
        }
    }
}