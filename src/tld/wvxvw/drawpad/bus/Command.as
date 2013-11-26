package tld.wvxvw.drawpad.bus {
    
    public class Command implements ICommand {

        private var method:Function;
        private var restore:Function;
        
        public function Command(method:Function, restore:Function) {
            super();
            this.method = method;
            this.restore = restore;
        }
        
        /** @inheritDoc */
        public function execute(args:Array):ICommand {
            if (args.length) this.method.apply(null, args);
            else this.method();
            return this;
        }

        /** @inheritDoc */
        public function undo():void {
            this.restore();
        }
    }
}