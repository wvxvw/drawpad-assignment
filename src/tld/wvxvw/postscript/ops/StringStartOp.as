package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class StringStartOp implements IOpcode {

        public function StringStartOp() { super(); }

        /** @inheritDoc */
        public function needMoreArguments():Boolean { return true; }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):void {
            context.string.push(arg);
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.isString = true;
        }
    }
}