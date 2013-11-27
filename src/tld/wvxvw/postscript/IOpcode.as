package tld.wvxvw.postscript {
    
    public interface IOpcode {

        /**
         * Tells this opcode to perform its action on the context with
         * <code>rest</code> arguments.
         */
        function invoke(context:Context, ...rest:Array):void;

        /**
         * The required number of arguments for this opcode to be inoked.
         */
         function get arity():uint;
    }
}