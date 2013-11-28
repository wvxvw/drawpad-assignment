package tld.wvxvw.postscript {
    
    import flash.events.IEventDispatcher;

    [Event(type="flash.events.AsyncErrorEvent", name="asyncError")]
    
    public interface IAsyncInputStream extends IEventDispatcher {

        /**
         * <code>true</code> if the stream was all already read.
         */
        function get isAtEnd():Boolean;

        /**
         * <code>true</code> if no character was read yet.
         */
         function get isAtStart():Boolean;
        
        /**
         * Will invoke <code>callback</code> each time a new char is read.
         *
         * @param callback Function called each time new character is
         *                 read froms stream.
         *
         * @throws flash.errors.EOFError
         */
        function readChar(callback:Function):void;

        /**
         * Reads all input up to <code>\n</code> character.
         */
        function readLine(callback:Function):void;

        /**
         * Reads input delimited by <code>delimiter</code> invoking
         * <code>callback</code> on the chunk of intput up to, but not
         * including the delimiter.
         */
        function readToken(callback:Function, delimiter:RegExp = null):void;
    }
}