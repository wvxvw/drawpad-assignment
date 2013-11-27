package tld.wvxvw.postscript {

    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.events.EventDispatcher;
    import flash.events.AsyncErrorEvent;
    import flash.events.Event;

    [Event(type="flash.events.AsyncErrorEvent", name="asyncError")]
    [Event(type="flash.events.Event", name="complete")]
    
    public class Interpreter extends EventDispatcher {

        public function get shape():Shape { return this.context.shape; }
        
        private var stream:IAsyncInputStream;
        private var opcodes:Opcodes = new Opcodes();
        private var context:Context;
        private var reader:Reader;
        private const stack:Array = [];
        
        public function Interpreter(stream:IAsyncInputStream = null,
            context:Context = null) {
            super();
            if (stream && shape) this.interpret(stream, context);
        }

        public function interpret(stream:IAsyncInputStream,
            context:Context):void {
            if (!stream.isAtEnd) {
                this.reader = new Reader(context);
                this.context = context;
                this.stream = stream;
                stream.readToken(this.onReadToken);
            }
        }

        private function onReadToken(token:String):void {
            this.reader.read(token);
            if (!this.stream.isAtEnd) stream.readToken(this.onReadToken);
        }
    }
}