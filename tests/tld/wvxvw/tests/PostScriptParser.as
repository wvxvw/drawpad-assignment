package tld.wvxvw.tests {

    import flash.events.Event;
    import flash.display.Shape;
    import tld.wvxvw.postscript.PS;
    import tld.wvxvw.postscript.Interpreter;
    import tld.wvxvw.debugging.Console;

    public class PostScriptParser {

        private static const SQUARE:String =
        ["%!PS",
            "% Draws a red rectangle with a black border",
            "newpath",
            "0 0    moveto",
            "0 100  rlineto",
            "100 0  rlineto",
            "0 -100 rlineto",
            "-100 0 rlineto",
            "2      setlinewidth",
            "1 0 0  setrgbcolor",
            "fill",
            "stroke"].join("\n");

        public function PostScriptParser() {
            super();
        }

        public function testSquare(where:Shape):void {
            Console.log("Square testSquare");
            new PS().load(SQUARE).addEventListener(
                Event.COMPLETE, this.completeHandler);
            Console.log("Square testSquare load start");
        }

        private function completeHandler(event:Event):void {
            var interpreter:Interpreter = event.currentTarget as Interpreter;
            Console.log("Square height:", interpreter.shape.height,
                "Square width:", interpreter.shape.width);
        }
    }
}