package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class ClosepathOp implements IOpcode {

        public function ClosepathOp() { super(); }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):Boolean {
            throw "should not happen";
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}