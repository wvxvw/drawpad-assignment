package tld.wvxvw.postscript {
    
    public class NewpathOp implements IOpcode {

        public function NewpathOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}