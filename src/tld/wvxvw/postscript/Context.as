package tld.wvxvw.postscript {

    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.IGraphicsData;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsGradientFill;
    import flash.display.GraphicsStroke;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsEndFill;
    import flash.geom.Point;
    
    public class Context {

        public var graphics:Graphics;
        public var position:Point;
        public var color:uint;
        public var solidFill:GraphicsSolidFill;
        public var gradientFill:GraphicsGradientFill;
        public var stroke:GraphicsStroke;
        public var shape:Shape;
        public const path:GraphicsPath = new GraphicsPath();
        public const graphicData:Vector.<IGraphicsData> = new <IGraphicsData>[];

        public function Context(shape:Shape) {
            super();
            this.shape = shape;
            this.graphics = shape.graphics;
            this.position = new Point();
        }

        /**
         * Draws all data collected so far into the graphics associated
         * with this context.
         */
        public function flush():void {
            if (this.solidFill) this.graphicData.push(this.solidFill);
            if (this.gradientFill) this.graphicData.push(this.gradientFill);
            if (this.stroke) this.graphicData.push(this.stroke);
            if (this.path.commands.length) this.graphicData.push(this.path);
            if (this.solidFill || this.gradientFill)
                this.graphicData.push(new GraphicsEndFill());
            this.graphics.drawGraphicsData(this.graphicData);
        }

        /**
         * Resets the context to its original state, so that it could be reused.
         */
        public function reset():void {
            this.color = this.position.x = this.position.y = 0;
            this.solidFill = null;
            this.gradientFill = null;
            this.stroke = null;
            this.path.commands = new <int>[];
            this.path.data = new <Number>[];
            this.graphicData.splice(0, this.graphicData.length);
        }
    }
}