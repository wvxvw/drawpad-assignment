package tld.wvxvw.postscript.ops {

    import flash.display.GraphicsSolidFill;
    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class FillOp implements IOpcode {

        public function FillOp() { super(); }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):Boolean {
            throw "should not happen";
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.solidFill = new GraphicsSolidFill(context.color);
        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}