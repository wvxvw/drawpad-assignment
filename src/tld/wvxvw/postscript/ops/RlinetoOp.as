package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class RlinetoOp implements IOpcode {

        private const args:Vector.<Number> = new <Number>[];
        
        public function RlinetoOp() { super(); }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):Boolean {
            return Boolean(this.args.push(arg as String));
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.position.offset(this.args[0], this.args[1]);
            context.path.moveTo(context.position.x, context.position.y);
        }

        /** @inheritDoc */
        public function get arity():uint { return 2; }
    }
}