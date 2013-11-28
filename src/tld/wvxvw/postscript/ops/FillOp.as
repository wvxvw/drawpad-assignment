package tld.wvxvw.postscript.ops {

    import flash.display.GraphicsSolidFill;
    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class FillOp implements IOpcode {

        public function FillOp() { super(); }

        /** @inheritDoc */
        public function needMoreArguments():Boolean { return false; }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):void {
            throw "should not happen";
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.solidFill = new GraphicsSolidFill(context.color);
        }
    }
}