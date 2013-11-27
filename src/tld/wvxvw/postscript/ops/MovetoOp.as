package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class MovetoOp implements IOpcode {

        public function MovetoOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Context, ...rest:Array):void {
            context.path.moveTo(rest[0], rest[1]);
        }

        /** @inheritDoc */
        public function get arity():uint { return 2; }
    }
}