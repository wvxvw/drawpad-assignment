package tld.wvxvw.postscript {
    
    public class ClosepathOp implements IOpcode {

        public function ClosepathOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}