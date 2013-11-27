package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class SetrgbcolorOp implements IOpcode {

        private const args:Vector.<uint> = new <uint>[];
        
        public function SetrgbcolorOp() { super(); }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):Boolean {
            return Boolean(this.args.push(uint(arg)));
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.color = (this.args[0] << 16) | (this.args[1] << 8) | this.args[2];
        }

        /** @inheritDoc */
        public function get arity():uint { return 3; }
    }
}