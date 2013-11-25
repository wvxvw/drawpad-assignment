package tld.wvxvw.postscript {
    
    public class MovetoOp implements IOpcode {

        public function MovetoOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}