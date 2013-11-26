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
    
    public class Canvas extends EventDispatcher implements IClient {

        public function set server(value:IServer):void {
            this.eventServer = value;
        }
        
        public var renderer:DisplayObjectContainer;

        private const children:Vector.<DisplayObject> = new <DisplayObject>[];
        private var selection:DisplayObject;
        private var history:History;
        private var eventServer:IServer;
        
        public function Canvas(history:History,
            renderer:DisplayObjectContainer = null) {
            super();
            this.history = history;
            if (renderer) this.init(renderer);
        }

        public function handle(response:String, ...data:Array):void {

        }
        
        private function init(renderer:DisplayObjectContainer):void {
            renderer.mouseChildren = false;
        }

        public function yank(child:DisplayObject):void {
            this.doInteractiveCommand(this.yankCommand(child));
        }

        private function doInteractiveCommand(action:Vector.<Function>):void {
            this.history.push(
                new Command(Futils.bind(action[0], this),
                    Futils.bind(action[1], this)));
        }
        
        private function placeCommand(child:DisplayObject):Vector.<Function> {
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

        private function yankCommand(child:DisplayObject):Vector.<Function> {
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

        private function selectCommand(x:int, y:int):Vector.<Function> {
            var selected:DisplayObject, lastSelected:DisplayObject = this.selection;
            // This is easier then to use getObjectsUnderPoint()
            return new <Function>[
                function ():void {
                    for each (var child:DisplayObject in this.children) {
                        if (child.getBounds(this.renderer).contains(x, y)) {
                            selected = child;
                            this.place(child);
                            break;
                        }
                    }
                    this.selection = selected;
                },
                function ():void { this.selection = lastSelected; }];
        }

        private function unselectCommand():Vector.<Function> {
            var selection:DisplayObject = this.selection;
            return new <Function>[
                function ():void { this.selection = null; },
                function ():void { this.selection = selection; }];
        }
        
        private function moveCommand(x:int, y:int):Vector.<Function> {
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