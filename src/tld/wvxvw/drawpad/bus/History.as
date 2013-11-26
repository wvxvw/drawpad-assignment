package tld.wvxvw.drawpad.bus {
    
    public class History {

        private const commands:Vector.<ICommand> = new <ICommand>[];
        
        public function History() {
            super();
        }

        public function push(command:ICommand, ...args:Array):void {
            this.commands.push(command.execute(args));
        }

        public function undo():void {
            var command:ICommand = this.commands.pop();
            command.undo();
        }
    }
}