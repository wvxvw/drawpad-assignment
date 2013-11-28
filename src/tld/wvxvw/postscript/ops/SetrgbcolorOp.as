package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class SetrgbcolorOp implements IOpcode {

        private const args:Vector.<uint> = new <uint>[];
        
        public function SetrgbcolorOp() { super(); }

        /** @inheritDoc */
        public function needMoreArguments():Boolean {
            return this.args.length < 3;
        }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):void {
            this.args.push(uint(255 * Number(arg)));
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.color = 0xFF000000 | (this.args[2] << 16) |
                (this.args[1] << 8) | this.args[0];
        }
    }
}