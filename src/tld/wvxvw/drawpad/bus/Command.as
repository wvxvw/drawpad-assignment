package tld.wvxvw.drawpad.bus {
    
    public class Command implements ICommand {

        private var action:Function;
        private var restore:Function;
        
        public function Command(action:Function, restore:Function) {
            super();
            this.action = action;
            this.restore = restore;
        }
        
        /** @inheritDoc */
        public function execute():ICommand {
            this.action();
            return this;
        }

        /** @inheritDoc */
        public function undo():ICommand {
            this.restore();
            return this;
        }
    }
}