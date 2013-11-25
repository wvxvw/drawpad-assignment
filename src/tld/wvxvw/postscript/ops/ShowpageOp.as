package tld.wvxvw.postscript {
    
    public class ShowpageOp implements IOpcode {

        public function ShowpageOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}