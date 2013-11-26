package tld.wvxvw.drawpad.bus {

    public interface ICommand {

        /**
         * Will perform whatever action this command is meant
         * to perform. The setup for the command should happen
         * when this command is created.
         */
        function execute():ICommand;

        /**
         * Undo the effect of the action previously performed
         * by <code>execute</code>
         */
        function undo():ICommand;
    }
}