package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class ClosepathOp implements IOpcode {

        public function ClosepathOp() { super(); }

        public function needMoreArguments():Boolean { return false; }
        
        /** @inheritDoc */
        public function bind(context:Context, arg:Object):void {
            throw "should not happen";
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {

        }
    }
}