package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class EndStringOp implements IOpcode {

        private const args:Vector.<String> = new <String>[];

        public function EndStringOp() { super(); }

        public function bind(context:Context, arg:Object):Boolean {
            throw "should not happen";
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.isString = false;
        }

        /** @inheritDoc */
        public function get arity():uint { return uint.MAX_VALUE; }
    }
}