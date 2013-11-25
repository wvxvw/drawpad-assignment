package tld.wvxvw.postscript {
    
    public class RlinetoOp implements IOpcode {

        public function RlinetoOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}