package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class EndStringOp implements IOpcode {

        private const args:Vector.<String> = new <String>[];

        public function EndStringOp() { super(); }

        /** @inheritDoc */
        public function needMoreArguments():Boolean { return false; }
        
        public function bind(context:Context, arg:Object):void {
            throw "should not happen";
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.isString = false;
        }
    }
}