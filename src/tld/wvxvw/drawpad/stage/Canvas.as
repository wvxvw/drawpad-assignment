package tld.wvxvw.drawpad.stage {

    import flash.display.DisplayObjectContainer;
    import flash.events.EventDispatcher;
    import flash.geom.Matrix;
    
    public class Canvas extends EventDispatcher {

        public var renderer:DisplayObjectContainer;

        private const children:Vector.<DisplayObject> = new <DisplayObject>[];
        private var selection:DisplayObject;
        
        public function Canvas(history:History,
            renderer:DisplayObjectContainer = null) {
            super();
            if (renderer) this.init(renderer);
        }

        private function init(renderer:DisplayObjectContainer):void {
            renderer.mouseChildren = false;
        }
        
        private function placeCommand(child:DisplayObject):void {
            this.yank(child);
            this.children.unshift(child);
            this.renderer.addChild(child);
        }

        private function yankCommand(child:DisplayObject):void {
            var index:int = this.children.indexOf(child);
            if (index > -1) this.children.splice(index, 1);
        }

        private function selectCommand(x:int, y:int):DisplayObject {
            // This is easier then to use getObjectsUnderPoint()
            var selected:DisplayObject;
            foreach (var child:DisplayObject in this.children) {
                if (child.getBounds(this.renderer).contains(x, y)) {
                    selected = child;
                    this.place(child);
                    break;
                }
            }
            return this.selection = selected;
        }

        private function unselectCommand():void {
            this.selection = null;
        }
        
        private function moveCommand(x:int, y:int):void {
            if (this.selection) {
                // Using matrix to avoid unnecessary screen update
                // created by two separate movements which would
                // be performed if we assigned x and y separately
                var matrix:Matrix = this.selection.transform.matrix;
                matrix.translate(x, y);
                this.selection.transform.matrix = matrix;
            }
        }
    }
}