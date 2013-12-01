package tld.wvxvw.drawpad.stage {

    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import tld.wvxvw.drawpad.bus.History;
    import tld.wvxvw.debugging.Console;
    
    public class Canvas extends GraphicClient {

        private var picked:Shape;
        
        public function Canvas(history:History,
            renderer:DisplayObjectContainer = null) {
            super(history, renderer);
            super.commands.push("pick", "drop", "rotate");
        }

        public function pick(shape:Shape):void {
            this.doInteractiveCommand(this.pickCommand(shape));
        }

        public function drop(x:int, y:int):void {
            this.doInteractiveCommand(this.dropCommand(x, y));
        }

        public function rotate(angle:int):void {
            if (this.ourSelection)
                this.doInteractiveCommand(this.rotateCommand(angle));
        }

        protected function rotateCommand(angle:int):Vector.<Function> {
            var selected:DisplayObject, lastSelected:DisplayObject = this.selection,
                oldMatrix:Matrix;
            // This is easier then to use getObjectsUnderPoint()
            return new <Function>[
                function ():void {
                    // There's a little problem with these figures
                    // they aren't in the (0,0) of their coordinate space,
                    // neither is their centre at (0,0), so rotating them
                    // around the centre is difficult... not at this late hour anyway.
                    var matrix:Matrix = this.selection.transform.matrix,
                        oldX:Number = matrix.tx,
                        oldY:Number = matrix.ty;
                    oldMatrix = matrix.clone();
                    matrix.tx = matrix.ty = 0;
                    matrix.rotate(angle);
                    matrix.tx = oldX;
                    matrix.ty = oldY;
                    this.selection.transform.matrix = matrix;
                },
                function ():void {
                    this.selection.transform.matrix = oldMatrix;
                }];
        }
        
        protected function pickCommand(shape:Shape):Vector.<Function> {
            return new <Function>[
                function ():void {
                    Console.warn("picking");
                    this.picked = shape;
                    this.renderer.stage.addEventListener(
                        Event.ENTER_FRAME, this.enterFrameHandler);
                    this.renderer.stage.addChild(shape);
                },
                function ():void {
                    if (this.picked) {
                        if (this.picked.parent)
                            picked.parent.removeChild(this.picked);
                        this.renderer.stage.removeEventListener(
                            Event.ENTER_FRAME, this.enterFrameHandler);
                        this.picked = null;
                    }
                }];
        }
        
        protected function dropCommand(x:int, y:int):Vector.<Function> {
            return new <Function>[
                function ():void {
                    Console.warn("dropping");
                    if (this.picked) {
                        picked.parent.removeChild(this.picked);
                        this.renderer.stage.removeEventListener(
                            Event.ENTER_FRAME, this.enterFrameHandler);
                        if (this.renderer.getBounds(this.renderer.stage).contains(x, y)) {
                            // We landed inside our renderer, so add us
                            this.place(this.picked);
                        } 
                        // Else we are outside the rendere, discard us
                        this.picked = null;
                    }
                },
                function ():void {
                    // not sure what to do here yet
                }];
        }

        protected override function selectCommand(x:int, y:int):Vector.<Function> {
            var selected:DisplayObject, lastSelected:DisplayObject = this.selection;
            // This is easier then to use getObjectsUnderPoint()
            return new <Function>[
                function ():void {
                    for each (var child:DisplayObject in this.children) {
                        if (child.getBounds(this.renderer.stage).contains(x, y)) {
                            selected = child;
                            break;
                        }
                    }
                    this.selection = selected;
                    if (this.selection) this.pick(selection);
                },
                function ():void {
                    this.selection = lastSelected;
                }];
        }
        
        private function enterFrameHandler(event:Event):void {
            var matrix:Matrix = this.picked.transform.matrix;
            matrix.tx = this.picked.stage.mouseX;
            matrix.ty = this.picked.stage.mouseY;
            this.picked.transform.matrix = matrix;
        }
    }
}