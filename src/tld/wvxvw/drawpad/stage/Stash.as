package tld.wvxvw.drawpad.stage {

    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import tld.wvxvw.drawpad.bus.History;
    import tld.wvxvw.debugging.Console;
    
    public class Stash extends GraphicClient {

        private var numslots:uint;
        private var padding:uint;
        
        public function Stash(history:History,
            renderer:DisplayObjectContainer = null,
            numslots:uint = 5, padding:uint = 10) {
            super(history, renderer);
            this.numslots = numslots;
            this.padding = padding;
        }

        private function lineUp():void {
            var matrix:Matrix, y:uint = padding, bounds:Rectangle;
            for each (var child:DisplayObject in super.children) {
                matrix = child.transform.matrix;
                bounds = child.getBounds(child);
                Console.debug("bounds:", bounds);
                matrix.ty = y - bounds.y;
                matrix.tx = this.padding
                y = matrix.ty + this.padding;
                child.transform.matrix = matrix;
            }
        }
        
        protected override function yankCommand(child:DisplayObject):Vector.<Function> {
            var index:int = -1;
            return new <Function>[
                function ():void {
                    index = this.children.indexOf(child);
                    if (index > -1) {
                        if (this.children.length < this.numslots) {
                            this.children.splice(index, 1);
                            this.lineUp();
                        } else {
                            index = -1;
                            this.server.request(this, "fail", ["yank", [child]]);
                        }
                    }
                },
                function ():void {
                    if (index > -1) {
                        this.children.splice(index, 0, 1);
                        this.lineUp();
                        index = -1;
                    }
                }
            ];
        }
        
        protected override function moveCommand(x:int, y:int):Vector.<Function> {
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

        protected override function placeCommand(child:DisplayObject):Vector.<Function> {
            return new <Function>[
                function ():void {
                    Console.warn("stash placeCommand");
                    this.history.inhibit = true;
                    this.yank(child);
                    this.history.inhibit = false;
                    this.children.unshift(child);
                    this.renderer.addChild(child);
                    this.lineUp();
                },
                function ():void {
                    this.history.inhibit = true;
                    this.yank(child);
                    this.history.inhibit = false;
                    this.lineUp();
                }];
        }

        protected override function selectCommand(x:int, y:int):Vector.<Function> {
            var selected:DisplayObject, lastSelected:DisplayObject = this.selection,
                copy:Shape;
            // This is easier then to use getObjectsUnderPoint()
            return new <Function>[
                function ():void {
                    for each (var child:DisplayObject in this.children) {
                        if (child.getBounds(this.renderer.stage).contains(x, y)) {
                            selected = child;
                            Console.debug("found selection, will duplicate it",
                                child is Shape, String(this));
                            copy = new Shape();
                            copy.graphics.copyFrom((child as Shape).graphics);
                            Console.debug("graphics copied", copy.width, copy.height);
                            this.server.request(this, "echo", "pick", copy);
                            break;
                        }
                    }
                    this.selection = selected;
                },
                function ():void {
                    this.selection = lastSelected;
                    if (copy) {
                        if (copy.parent) copy.parent.removeChild(copy);
                        copy = null;
                    }
                }];
        }

        protected override function unselectCommand(x:int, y:int):Vector.<Function> {
            var selection:DisplayObject = this.selection;
            return new <Function>[
                function ():void {
                    this.selection = null;
                    this.server.request(this, "echo", "drop", x, y);
                },
                function ():void { this.selection = selection; }];
        }
    }
}