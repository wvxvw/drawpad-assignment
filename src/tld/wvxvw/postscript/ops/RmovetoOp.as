package tld.wvxvw.postscript {
    
    public class RmovetoOp implements IOpcode {

        public function RmovetoOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}