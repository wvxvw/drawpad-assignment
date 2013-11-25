package tld.wvxvw.postscript {

    import flash.display.Graphics;
    import flash.events.EventDispatcher;
    import flash.events.AsyncErrorEvent;

    [Event(type="flash.events.AsyncErrorEvent", name="asyncError")]
    
    public class Interpreter extends EventDispatcher {

        private var stream:IAsyncInputStream;
        private var opcodes:Opcodes = new Opcodes();
        private var context:Graphics;
        private var stream:IAsyncInputStream;
        private var reader:Reader = new Reader();
        private var stack:Array = [];
        
        public function Interpreter(stream:IAsyncInputStream = null,
            graphics:Graphics = null) {
            super();
            if (stream && graphics) this.interpret(stream, graphics);
        }

        public function interpret(stream:IAsyncInputStream,
            graphics:Graphics):void {
            if (!stream.isAtEnd) {
                this.context = graphics;
                this.stream = stream;
                stream.readChar(this.onReadChar);
            }
        }

        private function onReadChar(char:String):void {
            this.advance(char);
            if (!this.stream.isAtEnd) stream.readChar(this.onReadChar);
        }

        private function advance(char:String):void {
            var token:String, opcode:IOpcode;
            
            this.reader.read(char);
            if (this.reader.token) {
                token = this.reader.token;
                if (token in this.opcodes) {
                    opcode = this.opcodes[token] as IOpcode;
                    if (this.stack.length >= opcode.arity) {
                        opcode.invoke(this.context,
                            this.stack.splice(
                                this.stack.length - opcode.arity, opcode.arity));
                    } else super.dispatchEvent(
                        new AsyncErrorEvent(
                            AsyncErrorEvent.ASYNC_ERROR, false, false,
                            ErrorMessages.ARGUMENT_COUNT_MISMATCH,
                            new PostScriptError(
                                ErrorMessages.ARGUMENT_COUNT_MISMATCH,
                                opcode, opcode.arity, this.stack.length)));
                } else if (!isNaN(parseFloat(token))) {
                    this.stack.push(parseFloat(token));
                } else super.dispatchEvent(
                    new AsyncErrorEvent(
                        AsyncErrorEvent.ASYNC_ERROR, false, false,
                        ErrorMessages.UNKNOWN_OPCODE,
                        new PostScriptError(ErrorMessages.UNKNOWN_OPCODE, token)));
            }
        }
    }
}