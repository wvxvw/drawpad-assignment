package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class StringStartOp implements IOpcode {

        private const args:Vector.<String> = new <String>[];

        public function StringStartOp() { super(); }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):Boolean {
            return Boolean(context.string.push(arg));
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.isString = true;
        }

        /** @inheritDoc */
        public function get arity():uint { return uint.MAX_VALUE; }
    }
}