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
        
        public function StringAsyncStream(source:String) {
            super();
        }

        public function readChar(callback:Function):void {
            if (!this.isAtEnd) {
                this.callback = callback;
                this.timer.reset();
                this.timer.start();
            } else throw new EOFError();
        }

        private function timerHandler(event:TimerEvent):void {
            this.callback(this.source.charAt(this.position++));
        }
    }
}