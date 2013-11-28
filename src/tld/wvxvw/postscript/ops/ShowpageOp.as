package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class ShowpageOp implements IOpcode {

        public function ShowpageOp() { super(); }

        /** @inheritDoc */
        public function needMoreArguments():Boolean { return false; }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):void {
            throw "should'nt happen";
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {

        }
    }
}