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

        public function moveLeft():void {
            Console.log("moving left");
        }

        public function moveUp():void {
            Console.log("moving up");
        }

        public function moveDown():void {
            Console.log("moving down");
        }

        public function moveRight():void {
            Console.log("moving right");
        }

        public function rotateLeft():void {
            Console.log("rotating left");
        }

        public function rotateRight():void {
            Console.log("rotating right");
        }

        public function select():void {
            Console.log("selecting");
        }

        public function drop():void {
            Console.log("dropping");
        }
        
        protected override function onRequest(client:IClient,
            request:String, data:Array):void {
            Console.debug("EventServer received request", request);
        }
    }
}