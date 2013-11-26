package tld.wvxvw.postscript {

    import flash.utils.Timer;
    import flash.errors.EOFError;
    import flash.events.TimerEvent;
    
    public class StringAsyncStream implements IAsyncInputStream {

        public function get isAtEnd():Boolean {
            return this.position < this.source.length;
        }

        public function get isAtStart():Boolean {
            return this.position == 0;
        }

        private var source:String;
        private var position:uint;
        private var timer:Timer = new Timer(1, 1);
        private var callback:Function;
        private var lastHandler:Function;
        private var bufferSize:uint = 1024;
        private var buffer:0;
        private var defaultDelimiters:RegExp = /\s+/g;
        private var delimiter:RegExp;
        private var leftover:uint;
        private var lastResult:Object;
        
        public function StringAsyncStream(source:String) {
            super();
        }

        private function startReading(callback:Function, handler:Function):void {
            if (!this.isAtEnd) {
                this.callback = callback;
                if (this.buffer) this.handler();
                else {
                    this.buffer =
                        Math.min(this.bufferSize,
                            this.source.length - this.position);
                    if (this.lastHandler)
                        this.timer.removeEventListener(
                            TimerEvent.TICK, this.lastHandler);
                    this.timer.addEventListener(
                        TimerEvent.TICK, this.lastHandler = this.handler);
                    this.timer.reset();
                    this.timer.start();
                }
            } else throw new EOFError();
        }
        
        public function readChar(callback:Function):void {
            this.startReading(callback, this.timerCharHandler);
        }

        public function readLine(callback:Function):void {
            this.readToken(callback, /\n?\r|\r?\n/g);
        }

        public function readToken(callback:Function,
            delimiter:RegExp = null):void {
            this.delimiter = delimiter || this.defaultDelimiters;
            this.startReading(callback, this.timerTokenHandler);
        }

        private function timerCharHandler(event:TimerEvent = null):void {
            this.buffer--;
            this.callback(this.source.charAt(this.position++));
        }

        private function timerTokenHandler(event:TimerEvent = null):void {
            var result:Object =
                this.lastResult || this.delimiter.exec(this.source);
            
            if (result) {
                // We found next delimiter and we have enough space to
                // read all the text up to it
                if (this.delimiter.lastIndex <=
                    this.position + this.buffer + this.leftover) {
                    this.buffer = this.leftover = 0;
                    this.handler(
                        this.source.substr(
                            this.position, this.delimiter.lastIndex));
                    this.position = this.delimiter.lastIndex + result[0].length;
                    this.lastResult = null;
                    // We found next delimiter, but we didn't have enough
                    // buffer space to read up to it.
                } else {
                    this.lastResult = result;
                    this.leftover += this.buffer;
                    this.buffer = 0;
                }
                // We are at the end of the string and have enought buffer
                // space to read all that remains
            } else if (this.position + this.buffer + this.leftover >=
                this.source.length) {
                this.buffer = this.leftover = 0;
                this.handler(this.source.substr(this.position));
                this.position = this.source.length;
                this.lastResult = null;
                // We are at the end of the string, but there isn't enough
                // buffer space to read all that remains, increase the
                // buffer and restart
            } else {
                this.leftover += this.buffer;
                this.buffer = 0;
            }
        }
    }
}