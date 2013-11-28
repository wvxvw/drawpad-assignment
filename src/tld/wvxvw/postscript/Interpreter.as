package tld.wvxvw.postscript {

    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.events.EventDispatcher;
    import flash.events.AsyncErrorEvent;
    import flash.events.Event;
    import tld.wvxvw.debugging.Console;

    [Event(type="flash.events.AsyncErrorEvent", name="asyncError")]
    [Event(type="flash.events.Event", name="complete")]
    
    public class Interpreter extends EventDispatcher {

        public function get shape():Shape { return this.context.shape; }
        
        private var stream:IAsyncInputStream;
        private var opcodes:Opcodes = new Opcodes();
        private var context:Context;
        private var reader:Reader;
        private const stack:Array = [];
        private const delimiter:RegExp = /[\r\t ]+|(?=\n)|(?<=\n)|(?<=%)/g;
        
        public function Interpreter(stream:IAsyncInputStream = null,
            context:Context = null) {
            super();
            Console.log("Interpreter created 1", Boolean(stream && context));
            if (stream && context) this.interpret(stream, context);
        }

        public function interpret(stream:IAsyncInputStream,
            context:Context):void {
            Console.log("Initializing interpeter:", stream.isAtEnd);
            if (!stream.isAtEnd) {
                this.reader = new Reader(context);
                this.reader.addEventListener(
                    AsyncErrorEvent.ASYNC_ERROR, super.dispatchEvent);
                this.context = context;
                this.stream = stream;
                this.delimiter.lastIndex = 0;
                stream.readToken(this.onReadToken, this.delimiter);
            }
            Console.log("Interpreter initialized");
        }

        private function onReadToken(token:String):void {
            this.reader.read(token);
            if (!this.stream.isAtEnd)
                stream.readToken(this.onReadToken, this.delimiter);
            else super.dispatchEvent(new Event(Event.COMPLETE));
        }
    }
}