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
    import tld.wvxvw.debugging.Console;
    
    public class Context {

        public function get isString():Boolean {
            return this._isString;
        }

        public function set isString(value:Boolean):void {
            this._isString = value;
            if (!value) {
                this.stack.push(this.string.join(""));
                this.string.splice(0, this.string.length);
            }
        }

        public function get isComment():Boolean {
            return this._isComment;
        }

        public function set isComment(value:Boolean):void {
            this._isComment = value;
        }

        public var parent:Context;
        public var graphics:Graphics;
        public var position:Point;
        public var color:uint;
        public var solidFill:GraphicsSolidFill;
        public var gradientFill:GraphicsGradientFill;
        public var shape:Shape;
        public var _isComment:Boolean;
        public var _isString:Boolean;
        public const children:Vector.<Context> = new <Context>[];
        public const stack:Vector.<String> = new <String>[];
        public const string:Vector.<String> = new <String>[];
        public const stroke:GraphicsStroke = new GraphicsStroke();
        public const path:GraphicsPath = new GraphicsPath();
        public const graphicData:Vector.<IGraphicsData> = new <IGraphicsData>[];

        public function Context(shape:Shape) {
            super();
            this.shape = shape;
            this.graphics = shape.graphics;
            this.position = new Point();
            Console.log("Context created");
        }

        /**
         * Draws all data collected so far into the graphics associated
         * with this context.
         */
        public function flush():void {
            Console.debug("Contex flushing");
            if (this.stroke.thickness) this.graphicData.push(this.stroke);
            if (this.solidFill) this.graphicData.push(this.solidFill);
            if (this.gradientFill) this.graphicData.push(this.gradientFill);
            if (this.path.commands.length) this.graphicData.push(this.path);
            if (this.solidFill || this.gradientFill)
                this.graphicData.push(new GraphicsEndFill());
            Console.debug("Contex drawing");
            this.graphics.drawGraphicsData(this.graphicData);
            Console.debug("Contex done flushing", this.graphicData);
        }

        /**
         * Resets the context to its original state, so that it could be reused.
         */
        public function reset():void {
            this.color = this.position.x = this.position.y = 0;
            this.solidFill = null;
            this.gradientFill = null;
            this.stroke.thickness = NaN;
            this.stroke.fill = null;
            this.path.commands = new <int>[];
            this.path.data = new <Number>[];
            this.graphicData.splice(0, this.graphicData.length);
        }

        /**
         * Generates a child context, based on this context.
         */
        public function offspring():Context {
            throw "not implemented";
        }
    }
}