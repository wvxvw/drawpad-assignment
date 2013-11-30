package tld.wvxvw.drawpad.stage {

    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.events.EventDispatcher;
    import flash.geom.Matrix;
    import tld.wvxvw.drawpad.bus.History;
    import tld.wvxvw.drawpad.bus.Command;
    import tld.wvxvw.drawpad.bus.IClient;
    import tld.wvxvw.drawpad.bus.IServer;
    import tld.wvxvw.functions.Futils;
    import tld.wvxvw.debugging.Console;
    
    public class GraphicClient extends EventDispatcher implements IClient {

        public function set server(value:IServer):void {
            this.eventServer = value;
        }

        public function get server():IServer {
            return this.eventServer;
        }
        
        protected var renderer:DisplayObjectContainer;

        protected const children:Vector.<DisplayObject> = new <DisplayObject>[];
        protected const commands:Vector.<String> =
            new <String>["yank", "place", "move", "select", "unselect"];
        protected var selection:DisplayObject;
        protected var history:History;
        protected var eventServer:IServer;
        protected var ourSelection:Boolean;
        
        public function GraphicClient(history:History,
            renderer:DisplayObjectContainer = null) {
            super();
            this.history = history;
            if (renderer) this.init(renderer);
        }

        public function handle(response:String, data:Array):void {
            Console.log("handle begin", this.commands, response);
            if (this.commands.indexOf(response) > -1) {
                Console.log("Client received response", response, String(data));
                if (data && data.length)
                    (this[response] as Function).apply(this, data);
                else this[response]();
            }
        }
        
        private function init(renderer:DisplayObjectContainer):void {
            this.renderer = renderer;
            renderer.mouseChildren = false;
        }

        public function yank(child:DisplayObject):void {
            if (this.ourSelection)
                this.doInteractiveCommand(this.yankCommand(child));
        }

        public function place(child:DisplayObject):void {
            Console.log("placing...");
            this.doInteractiveCommand(this.placeCommand(child));
            Console.log("placed...");
        }

        public function select(x:int, y:int):void {
            if (this.renderer.getBounds(this.renderer.stage).contains(x, y)) {
                this.doInteractiveCommand(this.selectCommand(x, y));
                this.ourSelection = true;
            } else {
                this.ourSelection = false;
            }
        }

        public function unselect():void {
            if (this.ourSelection)
                this.doInteractiveCommand(this.unselectCommand());
        }

        public function move(x:int, y:int):void {
            if (this.ourSelection)
                this.doInteractiveCommand(this.moveCommand(x, y));
        }

        protected function doInteractiveCommand(action:Vector.<Function>):void {
            this.history.push(
                new Command(Futils.bind(action[0], this),
                    Futils.bind(action[1], this)));
        }
        
        protected function placeCommand(child:DisplayObject):Vector.<Function> {
            return new <Function>[
                function ():void {
                    this.history.inhibit = true;
                    this.yank(child);
                    this.history.inhibit = false;
                    this.children.unshift(child);
                    this.renderer.addChild(child);
                },
                function ():void {
                    this.history.inhibit = true;
                    this.yank(child);
                    this.history.inhibit = false;
                }];
        }

        protected function yankCommand(child:DisplayObject):Vector.<Function> {
            var index:int = -1;
            return new <Function>[
                function ():void {
                    index = this.children.indexOf(child);
                    if (index > -1) this.children.splice(index, 1);
                },
                function ():void {
                    if (index > -1) this.children.splice(index, 0, 1);
                }
            ];
        }

        protected function selectCommand(x:int, y:int):Vector.<Function> {
            var selected:DisplayObject, lastSelected:DisplayObject = this.selection;
            // This is easier then to use getObjectsUnderPoint()
            return new <Function>[
                function ():void {
                    for each (var child:DisplayObject in this.children) {
                        if (child.getBounds(this.renderer.stage).contains(x, y)) {
                            selected = child;
                            this.place(child);
                            break;
                        }
                    }
                    this.selection = selected;
                },
                function ():void { this.selection = lastSelected; }];
        }

        protected function unselectCommand():Vector.<Function> {
            var selection:DisplayObject = this.selection;
            return new <Function>[
                function ():void { this.selection = null; },
                function ():void { this.selection = selection; }];
        }
        
        protected function moveCommand(x:int, y:int):Vector.<Function> {
            var oldMatrix:Matrix, selection:DisplayObject = this.selection;
            return new <Function>[
                function ():void {
                    if (selection) {
                        // Using matrix to avoid unnecessary screen update
                        // created by two separate movements which would
                        // be performed if we assigned x and y separately
                        oldMatrix = selection.transform.matrix;
                        var matrix:Matrix = oldMatrix.clone();
                        matrix.translate(x, y);
                        this.selection.transform.matrix = matrix;
                    }
                },
                function ():void {
                    if (oldMatrix) selection.transform.matrix = oldMatrix;
                }];
        }
    }
}