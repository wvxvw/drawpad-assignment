package tld.wvxvw.postscript {

    import flash.net.URLRequest;
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    import flash.errors.EOFError;
    import flash.events.ProgressEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.AsyncErrorEvent;
    import tld.wvxvw.debugging.Console;

    [Event(type="flash.events.AsyncErrorEvent", name="asyncError")]
    [Event(type="flash.events.IOErrorEvent", name="ioError")]
    [Event(type="flash.events.SecurityErrorEvent", name="securityError")]
    
    public class UrlAsyncStream extends EventDispatcher
                                implements IAsyncInputStream {

        public function get isAtEnd():Boolean {
            return this.completed && !this.buffer;
        }

        public function get isAtStart():Boolean {
            return this.position == 0;
        }

        private var request:URLRequest;
        private var callback:Function;
        private var lastHandler:Function;
        private var defaultDelimiters:RegExp = /\s+/g;
        private var delimiter:RegExp;
        private var lastResult:Object;
        private var stream:URLStream;
        private var buffer:String = "";
        private var bufferSize:uint = 1204;
        private var position:uint;
        private var completed:Boolean;
        
        public function UrlAsyncStream(request:URLRequest) {
            super();
            this.request = request;
            Console.log("UrlAsyncStream created");
        }

        private function fillBuffer():void {
            this.buffer +=
                this.stream.readUTFBytes(
                    Math.min(this.stream.bytesAvailable, this.bufferSize));
        }
        
        private function startReading(callback:Function, handler:Function):void {
            Console.debug("UrlAsyncStream startReading", this.isAtEnd);
            this.callback = callback;
            if (!this.isAtEnd) {
                this.stream = new URLStream();
                this.stream.addEventListener(Event.COMPLETE, this.completeHandler);
                this.stream.addEventListener(
                    IOErrorEvent.IO_ERROR, super.dispatchEvent);
                this.stream.addEventListener(
                    SecurityErrorEvent.SECURITY_ERROR, super.dispatchEvent);
                this.stream.addEventListener(
                    ProgressEvent.PROGRESS, handler);
                this.stream.load(this.request);
            } else {
                var error:EOFError = new EOFError();
                super.dispatchEvent(
                    new AsyncErrorEvent(
                        AsyncErrorEvent.ASYNC_ERROR,
                        false, false, error.message, error));
            }
            Console.debug("UrlAsyncStream startReading done");
        }
        
        public function readChar(callback:Function):void {
            this.startReading(callback, this.charHandler);
        }

        public function readLine(callback:Function):void {
            this.readToken(callback, /\n?\r|\r?\n/g);
        }

        public function readToken(callback:Function,
            delimiter:RegExp = null):void {
            this.delimiter = delimiter || this.defaultDelimiters;
            this.startReading(callback, this.tokenHandler);
        }

        private function completeHandler(event:Event):void {
            this.completed = true;
        }

        private function charHandler(event:ProgressEvent):void {
            var char:String = this.buffer.charAt();
            this.position++;
            this.buffer = this.buffer.substr(1);
            this.callback(char);
        }

        private function lastJunkBytes():Boolean {
            var char:String = this.stream.readUTFBytes(1);
            this.buffer += char;
            return Boolean(char);
        }
        
        private function tokenHandler(event:ProgressEvent = null, advance:uint = 0):void {
            var result:Object, match:String, token:String,
                lastIndex:int = this.delimiter.lastIndex - advance;
            
            if (!this.buffer) this.fillBuffer();
            result = this.delimiter.exec(this.buffer);
            
            Console.log("result:", result, this.buffer);
            if (result) {
                // If we made no progress, advance one character, and try again
                if (lastIndex == this.delimiter.lastIndex) {
                    this.delimiter.lastIndex++;
                    this.tokenHandler(event, advance + 1);
                    return;
                }
                // We found next delimiter and we have enough space to
                // read all the text up to it
                match = result[0];
                token = this.buffer.substring(0, this.delimiter.lastIndex - match.length);
                Console.log("Match:", "|" + match + "|", "token", "|" + token + "|");
                if (this.buffer == token + match) this.buffer = "";
                else this.buffer = this.buffer.substr(token.length + match.length);
                this.delimiter.lastIndex = 0;
                this.callback(token);
            } else if (this.completed) {
                this.callback(this.buffer);
                this.buffer = "";
            } else if (this.stream.bytesAvailable && !this.lastJunkBytes()) {
                this.fillBuffer();
                this.tokenHandler(event);
            }
        }
    }
}