package tld.wvxvw.drawpad.bus {
    
    public class History {

        public const clipboard:Array = [];

        public var inhibit:Boolean;
        
        private const commands:Vector.<ICommand> = new <ICommand>[];
        
        public function History() {
            super();
        }

        public function push(command:ICommand):void {
            if (this.inhibit) command.execute();
            else this.commands.push(command.execute());
        }

        public function undo():void {
            var command:ICommand = this.commands.pop();
            command.undo();
        }
    }
}