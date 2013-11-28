package tld.wvxvw.postscript.ops {

    import flash.display.GraphicsSolidFill;
    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class SetlinewidthOp implements IOpcode {

        private const args:Vector.<uint> = new <uint>[];
        
        public function SetlinewidthOp() { super(); }

        /** @inheritDoc */
        public function needMoreArguments():Boolean {
            return this.args.length < 1;
        }
        
        /** @inheritDoc */
        public function bind(context:Context, arg:Object):void {
            this.args.push(uint(arg));
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.stroke.thickness = this.args[0];
            if (!context.stroke.fill)
                context.stroke.fill = new GraphicsSolidFill();
        }
    }
}