package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class CommentEndOp implements IOpcode {

        public function CommentEndOp() { super(); }

        public function needMoreArguments():Boolean { return false; }
        
        public function bind(context:Context, arg:Object):void {
            throw "should never happen";
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.isComment = false;
        }
    }
}