package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class CommentEndOp implements IOpcode {

        public function CommentEndOp() { super(); }

        public function bind(context:Context, arg:Object):Boolean {
            throw "should never happen";
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.isComment = false;
        }

        /** @inheritDoc */
        public function get arity():uint { return uint.MAX_VALUE; }
    }
}