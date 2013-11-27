package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class SetlinewidthOp implements IOpcode {

        public function SetlinewidthOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Context, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}