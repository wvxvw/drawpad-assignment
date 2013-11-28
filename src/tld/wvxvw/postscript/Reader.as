package tld.wvxvw.postscript {

    import flash.events.EventDispatcher;
    import flash.events.AsyncErrorEvent;
    import tld.wvxvw.postscript.ops.ClosepathOp;
    import tld.wvxvw.postscript.ops.CommentOp;
    import tld.wvxvw.postscript.ops.CommentEndOp;
    import tld.wvxvw.postscript.ops.StringStartOp;
    import tld.wvxvw.postscript.ops.EndStringOp;
    import tld.wvxvw.postscript.ops.FillOp;
    import tld.wvxvw.postscript.ops.LinetoOp;
    import tld.wvxvw.postscript.ops.MovetoOp;
    import tld.wvxvw.postscript.ops.NewpathOp;
    import tld.wvxvw.postscript.ops.RlinetoOp;
    import tld.wvxvw.postscript.ops.RmovetoOp;
    import tld.wvxvw.postscript.ops.SetlinewidthOp;
    import tld.wvxvw.postscript.ops.SetrgbcolorOp;
    import tld.wvxvw.postscript.ops.ShowpageOp;
    import tld.wvxvw.postscript.ops.StrokeOp;
    import tld.wvxvw.postscript.ErrorMessages;
    import tld.wvxvw.postscript.PostScriptError;
    import tld.wvxvw.debugging.Console;
    
    public class Reader extends EventDispatcher {

        private var head:Context;
        private var opcode:IOpcode;

        private const symols:Object = {
            "closepath" : ClosepathOp,
            "\n" : CommentEndOp,
            "%" : CommentOp,
            "(" : StringStartOp,
            ")" : EndStringOp,
            "fill" : FillOp,
            "lineto" : LinetoOp,
            "moveto" : MovetoOp,
            "newpath" : NewpathOp,
            "rlineto" : RlinetoOp,
            "rmoveto" : RmovetoOp,
            "setlinewidth" : SetlinewidthOp,
            "setrgbcolor" : SetrgbcolorOp,
            "showpage" : ShowpageOp,
            "stroke" : StrokeOp
        };
        
        public function Reader(context:Context) {
            super();
            this.head = context;
        }

        public function read(token:String):void {
            Console.log("Reading token", token,
                this.head.isString, this.head.isComment,
                this.symols[token] == CommentEndOp);
            if (!(this.head.isString || this.head.isComment)) {
                if (token in this.symols) {
                    Console.log("Processing:", token);
                    this.opcode = new this.symols[token]() as IOpcode;
                    while (this.opcode.needMoreArguments()) {
                        if (!this.head.stack.length) {
                            super.dispatchEvent(
                                new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR,
                                    false, false, ErrorMessages.ARGUMENT_COUNT_MISMATCH,
                                    new PostScriptError(ErrorMessages.ARGUMENT_COUNT_MISMATCH)));
                        }
                        this.opcode.bind(this.head, this.head.stack.pop());
                    }
                    this.opcode.invoke(this.head);
                    this.opcode = null;
                } else {
                    this.head.stack.push(token);
                }
            } else if ((!this.head.isString && this.head.isComment &&
                this.symols[token] == CommentEndOp) ||
                (!this.head.isComment && this.head.isString &&
                this.symols[token] == EndStringOp)) {
                Console.log("Uncomment or end string");
                (new this.symols[token]() as IOpcode).invoke(this.head);
            }
            Console.log("Finished token", token, this.head.isString, this.head.isComment);
        }
    }
}