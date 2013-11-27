package tld.wvxvw.postscript {

    import flash.events.EventDispatcher;
    import flash.errors.IllegalOperationError;
    import flash.display.Shape;
    import flash.net.URLRequest;

    public class PS {

        public function PS() {
            super();
        }

        public function load(source:*):EventDispatcher {
            if (source is String) return this.loadString(source as String);
            else if (source is URLRequest)
                return this.loadUrl(source as URLRequest);
            else throw IllegalOperationError(
                "`source' must be either a String or a URLRequest");
        }

        private function loadString(source:String):EventDispatcher {
            return new Interpreter(new StringAsyncStream(source),
                new Context(new Shape()));
        }

        private function loadUrl(source:URLRequest):EventDispatcher {
            throw "Not implemented";
        }
    }
}