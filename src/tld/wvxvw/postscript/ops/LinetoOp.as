package tld.wvxvw.postscript {
    
    public class LinetoOp implements IOpcode {

        public function LinetoOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}