package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class RmovetoOp implements IOpcode {

        private const args:Vector.<String> = new <String>[];
        
        public function RmovetoOp() { super(); }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):Boolean {
            return Boolean(this.args.push(arg as String));
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}