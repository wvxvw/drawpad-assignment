package tld.wvxvw.postscript {

    import flash.events.EventDispatcher;
    import flash.errors.IllegalOperationError;
    import flash.display.Shape;
    import flash.net.URLRequest;
    import tld.wvxvw.debugging.Console;

    public class PS {

        public function PS() {
            super();
        }

        public function load(source:*, where:Shape = null):EventDispatcher {
            if (source is String)
                return this.loadString(source as String, where);
            else if (source is URLRequest)
                return this.loadUrl(source as URLRequest, where);
            else throw IllegalOperationError(
                "`source' must be either a String or a URLRequest");
        }

        private function loadString(source:String, where:Shape):EventDispatcher {
            Console.log("loading string");
            return new Interpreter(new StringAsyncStream(source),
                new Context(where));
        }

        private function loadUrl(source:URLRequest, where:Shape):EventDispatcher {
            throw "Not implemented";
        }
    }
}