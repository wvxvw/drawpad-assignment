package tld.wvxvw.drawpad.stage {

    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.geom.Matrix;
    import tld.wvxvw.drawpad.bus.History;
    import tld.wvxvw.debugging.Console;
    
    public class Canvas extends GraphicClient {

        private var picked:Shape;
        
        public function Canvas(history:History,
            renderer:DisplayObjectContainer = null) {
            super(history, renderer);
            super.commands.push("pick", "drop");
        }

        public function pick(shape:Shape):void {
            this.doInteractiveCommand(this.pickCommand(shape));
        }

        public function drop():void {
            this.doInteractiveCommand(this.dropCommand());
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
        
        protected function dropCommand():Vector.<Function> {
            return new <Function>[
                function ():void {
                    Console.warn("dropping");
                    if (this.picked) {
                        picked.parent.removeChild(this.picked);
                        this.renderer.stage.removeEventListener(
                            Event.ENTER_FRAME, this.enterFrameHandler);
                        this.place(this.picked);
                        this.picked = null;
                    }
                },
                function ():void {
                    // not sure what to do here yet
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