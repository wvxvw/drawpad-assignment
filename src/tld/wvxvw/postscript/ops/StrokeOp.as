package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class StrokeOp implements IOpcode {

        public function StrokeOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Context, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}