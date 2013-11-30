package tld.wvxvw.postscript.ops {

    import tld.wvxvw.postscript.Context;
    import tld.wvxvw.postscript.IOpcode;
    
    public class MovetoOp implements IOpcode {

        private const args:Vector.<Number> = new <Number>[];
        
        public function MovetoOp() { super(); }

        /** @inheritDoc */
        public function needMoreArguments():Boolean { return this.args.length < 2; }

        /** @inheritDoc */
        public function bind(context:Context, arg:Object):void {
            this.args.push(Number(arg));
        }
        
        /** @inheritDoc */
        public function invoke(context:Context):void {
            context.position.offset(this.args[1], -this.args[0]);
            context.path.moveTo(context.position.x, context.position.y);
        }
    }
}