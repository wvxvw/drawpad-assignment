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
            return this.endTester();
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
        private const buffer:ByteArray = new ByteArray();
        private var bufferSize:uint = 1204;
        private var bufferString:String;
        private var position:uint;
        
        public function UrlAsyncStream(request:URLRequest) {
            super();
            this.request = request;
            Console.log("UrlAsyncStream created");
        }

        private function fillBuffer():void {
            this.buffer.position = this.buffer.bytesAvailable;
            this.buffer.writeUTFBytes(
                this.stream.readUTFBytes(
                    Math.min(this.stream.bytesAvailable,
                        this.bufferSize - this.buffer.position)));
            this.buffer.position = 0;
            this.bufferString = this.buffer.readUTFBytes(this.buffer.length);
            this.buffer.position = 0;
        }
        
        private function startReading(callback:Function, handler:Function):void {
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

        }

        private function charHandler(event:ProgressEvent):void {
            this.callback(this.bufferString.charAt(this.position++));
        }

        protected function endTester():Boolean {
            // This should test for the null byte, is meant to be overriden
            // if someone wants the test to be performed different, however,
            // this test must take into account that after the stream was
            // disconnected, it must be at the end.
            return this.stream &&
                (this.buffer[Math.max(this.buffer.position - 1, 0)] == 0 ||
                !this.stream.connected);
        }
        
        private function tokenHandler(event:ProgressEvent = null):void {
            var result:Object =
                this.lastResult || this.delimiter.exec(this.bufferString), match:String;

            Console.log("result:", result);
            
        }
    }
}