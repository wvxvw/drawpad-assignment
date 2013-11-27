package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class CommentOp implements IOpcode {

        public function CommentOp() { super(); }

        public function bind(context:Context, arg:Object):Boolean {
            // just ignore whatever that is
            return true;
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.isComment = true;
        }

        /** @inheritDoc */
        public function get arity():uint { return uint.MAX_VALUE; }
    }
}