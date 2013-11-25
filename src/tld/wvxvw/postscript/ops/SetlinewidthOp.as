package tld.wvxvw.postscript {
    
    public class SetlinewidthOp implements IOpcode {

        public function SetlinewidthOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}