package tld.wvxvw.postscript {
    
    public interface IOpcode {

        /**
         * Binds (sets) next argument for the operation.
         * The opcode needs to return <code>true</code> if
         * it requires more arguments before it can be invoked.
         */
        function bind(context:Context, arg:Object):void;

        /**
         * Returns <code>true</code> if this opcode doesn't have
         * enough arguments.
         */
        function needMoreArguments():Boolean;

        /**
         * Tells this opcode to perform its action on the context with
         * <code>rest</code> arguments.
         */
        function invoke(context:Context):void;
    }
}