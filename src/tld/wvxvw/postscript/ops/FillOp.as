package tld.wvxvw.postscript {
    
    public class FillOp implements IOpcode {

        public function FillOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}