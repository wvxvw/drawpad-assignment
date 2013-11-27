package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class SetlinewidthOp implements IOpcode {

        private const args:Vector.<uint> = new <uint>[];
        
        public function SetlinewidthOp() { super(); }
        
        /** @inheritDoc */
        public function bind(context:Context, arg:Object):Boolean {
            return Boolean(this.args.push(uint(arg)));
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.stroke.thickness = this.args[0];
        }

        /** @inheritDoc */
        public function get arity():uint { return 1; }
    }
}