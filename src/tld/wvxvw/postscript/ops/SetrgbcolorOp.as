package tld.wvxvw.postscript {
    
    public class SetrgbcolorOp implements IOpcode {

        public function SetrgbcolorOp() { super(); }
        
        /** @inheritDoc */
        public function invoke(context:Graphics, ...rest:Array):void {

        }

        /** @inheritDoc */
        public function get arity():uint { return 0; }
    }
}