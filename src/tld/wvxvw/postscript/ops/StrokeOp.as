package tld.wvxvw.postscript {
    
    public class StrokeOp implements IOpcode {

        public function StrokeOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}