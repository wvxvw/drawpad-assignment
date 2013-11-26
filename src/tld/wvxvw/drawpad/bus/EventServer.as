package tld.wvxvw.drawpad.bus {

    import flash.events.EventDispatcher;
    import tld.wvxvw.debugging.Console;
    
    public class EventServer extends Server {

        public function EventServer(dispatcher:EventDispatcher) {
            super(dispatcher);
        }

        public function help(topic:String = null):void {
            Console.log("Drapwpad help. topic:", topic);
        }
        
        protected override function onRequest(client:IClient,
            request:String, data:Array):void {
            Console.debug("EventServer received request", request);
        }
    }
}