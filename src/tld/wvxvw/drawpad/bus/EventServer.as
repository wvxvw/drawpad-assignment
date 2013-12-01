package tld.wvxvw.drawpad.bus {

    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.display.Shape;
    import tld.wvxvw.debugging.Console;
    
    public class EventServer extends Server {

        private var step:uint = 20;
        private var position:Point = new Point();
        
        public function EventServer(dispatcher:EventDispatcher) {
            super(dispatcher);
        }

        public function help(event:Event = null):void {
            Console.log("Drapwpad help. topic:");
        }

        public function complete(client:IClient):void {
            Console.log("Completed loading shape");
        }

        public function place(shape:Shape):void {
            Console.log("Placing shape");
            this.tell("place", [shape]);
        }
        
        public function moveLeft(event:Event = null):void {
            Console.log("moving left");
            this.tell("move", [-this.step, 0]);
        }

        public function moveUp(event:Event = null):void {
            Console.log("moving up");
            this.tell("move", [0, -this.step]);
        }

        public function moveDown(event:Event = null):void {
            Console.log("moving down");
            this.tell("move", [0, this.step]);
        }

        public function moveRight(event:Event = null):void {
            Console.log("moving right");
            this.tell("move", [this.step, 0]);
        }

        public function move(event:Event = null):void {
            Console.log("selecting");
            var deltaX:int, deltaY:int;
            if (event is MouseEvent) {
                deltaX =  (event as MouseEvent).stageX - this.position.x;
                deltaY = (event as MouseEvent).stageY - this.position.y;
            }
            this.position.offset(deltaX, deltaY);
            this.tell("move", [deltaX, deltaY]);
        }
        
        public function rotateLeft(event:Event = null):void {
            Console.log("rotating left");
            tell("rotate", [-this.step]);
        }

        public function rotateRight(event:Event = null):void {
            Console.log("rotating right");
            this.tell("rotate", [this.step]);
        }

        public function select(event:Event = null):void {
            Console.log("selecting");
            if (event is MouseEvent) {
               this.position.x = (event as MouseEvent).stageX;
               this.position.y = (event as MouseEvent).stageY;
           }
           this.tell("select", [this.position.x, this.position.y]);
        }

        public function drop(event:Event = null):void {
            Console.log("dropping");
            if (event is MouseEvent) {
                this.position.x = (event as MouseEvent).stageX;
                this.position.y = (event as MouseEvent).stageY;
            }
            this.tell("drop", [this.position.x, this.position.y]);
        }
        
        protected override function onRequest(client:IClient,
            request:String, data:Array):void {
            Console.debug("EventServer received request", request);
        }

        private function tell(request:String, data:Array = null):void {
            Console.debug("telling clients:", super.clients.length);
            for each (var client:IClient in super.clients) {
                try { client.handle(request, data); }
                catch (error:*) {
                    Console.error("Client", String(client), "failed request",
                        request, "with arguments", String(data), String(error));
                }
            }
        }
    }
}